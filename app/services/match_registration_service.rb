class MatchRegistrationService
  class RegistrationError < StandardError; end

  def initialize(match, current_user, params)
    @match = match
    @current_user = current_user
    @registration_type = params[:registration_type].to_s
    @user_team_id = params[:user_team_id]
    @raw_team_size = params[:team_size].to_i
    @present_member_ids = params[:present_member_ids] || []
  end

  def call
    Registration.transaction do
      # Lock the match row so concurrent requests wait in line
      @match.lock!

      validate_user_not_already_registered!

      if @registration_type == "team"
        register_team!
      else
        register_individual!
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.record.errors.full_messages.to_sentence }
  rescue RegistrationError => e
    { success: false, error: e.message }
  end

  private

  def validate_user_not_already_registered!
    if @match.registrations.where(user_id: @current_user.id).exists?
      raise RegistrationError, "Du är redan anmäld till denna match."
    end
  end

  def register_individual!
    team = pick_team_for_match
    raise RegistrationError, "Den här matchen är fullbokad." unless team

    registration = team.registrations.create!(
      user: @current_user,
      team_size: 1,
      status: :confirmed
    )

    MatchMailer.individual_registration(registration.id).deliver_later
    { success: true, message: "Du är anmäld till matchen." }
  end

  def register_team!
    user_team = @current_user.user_teams.find_by(id: @user_team_id)
    raise RegistrationError, "Vi kunde inte hitta laget du valde." unless user_team

    if @match.registrations.where(user_team_id: user_team.id).exists?
      raise RegistrationError, "Det här laget är redan anmält till matchen."
    end

    members_count = user_team.members.count
    raise RegistrationError, "Ditt lag har inga spelare ännu." if members_count <= 0

    team = pick_team_for_match
    raise RegistrationError, "Den här matchen är fullbokad." unless team

    # Derive team size from present members array
    actual_size = @present_member_ids.any? ? @present_member_ids.count : [ @raw_team_size, members_count ].min
    actual_size = members_count if actual_size <= 0

    registration = team.registrations.create!(
      user: @current_user,
      user_team: user_team,
      team_size: actual_size,
      status: :confirmed
    )

    # Save relational records for the specific members attending
    valid_member_ids = user_team.members.where(id: @present_member_ids).pluck(:id)
    valid_member_ids.each do |member_id|
      registration.registration_members.create!(user_id: member_id)
    end

    user_team.members.find_each do |member|
      MatchMailer.team_registration(registration.id, member.id).deliver_later
    end

    { success: true, message: "Laget är anmält till matchen." }
  end

  def pick_team_for_match
    return nil if @match.hard_limit_reached?

    @match.teams.find { |t| !t.soft_limit_reached? && !t.hard_limit_reached? } ||
      @match.teams.find { |t| !t.hard_limit_reached? }
  end
end
