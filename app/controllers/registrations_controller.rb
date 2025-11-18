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

      # Default to member count, let user override but never exceed members_count
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
      redirect_to schedule_path,
                  notice: (registration_type == "team" ? "Laget är anmält till matchen." : "Du är anmäld till matchen.")
    else
      redirect_back fallback_location: schedule_path,
                    alert: registration.errors.full_messages.to_sentence,
                    status: :see_other
    end
  end

  private

  def pick_team_for_match(match)
    return nil if match.hard_limit_reached?

    # Prefer team with soft capacity, then any with hard capacity
    match.teams.find { |t| !t.soft_limit_reached? && !t.hard_limit_reached? } ||
      match.teams.find { |t| !t.hard_limit_reached? }
  end
end
