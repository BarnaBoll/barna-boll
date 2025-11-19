class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def create
    match = Match.find(params[:match_id])
    registration_type = params[:registration_type].to_s

    team = pick_team_for_match(match)
    unless team
      redirect_back fallback_location: schedule_path,
                    alert: "Den här matchen är fullbokad.",
                    status: :see_other
      return
    end

    user_team = nil
    team_size = 1

    if registration_type == "team"
      user_team = current_user.user_teams.find_by(id: params[:user_team_id])

      unless user_team
        redirect_back fallback_location: schedule_path,
                      alert: "Vi kunde inte hitta laget du valde.",
                      status: :see_other
        return
      end

      members_count = user_team.members.count

      if members_count <= 0
        redirect_back fallback_location: schedule_path,
                      alert: "Ditt lag har inga spelare ännu.",
                      status: :see_other
        return
      end

      raw_team_size = params[:team_size].to_i
      team_size =
        if raw_team_size <= 0
          members_count
        else
          [ raw_team_size, members_count ].min
        end
    end

    registration = team.registrations.build(
      user: current_user,
      team_size: team_size,
      user_team: user_team,
      status: :confirmed
    )

    if registration.save
      if registration_type == "team" && user_team.present?
        # Email all members of the team about the upcoming match
        user_team.members.find_each do |member|
          MatchMailer.team_registration(registration.id, member.id).deliver_later
        end

        redirect_to schedule_path,
                    notice: "Laget är anmält till matchen."
      else
        # Individual registration email
        MatchMailer.individual_registration(registration.id).deliver_later

        redirect_to schedule_path,
                    notice: "Du är anmäld till matchen."
      end
    else
      redirect_back fallback_location: schedule_path,
                    alert: registration.errors.full_messages.to_sentence,
                    status: :see_other
    end
  end

  private

  def pick_team_for_match(match)
    return nil if match.hard_limit_reached?

    match.teams.find { |t| !t.soft_limit_reached? && !t.hard_limit_reached? } ||
      match.teams.find { |t| !t.hard_limit_reached? }
  end
end
