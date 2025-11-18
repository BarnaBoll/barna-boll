# app/controllers/dashboards_controller.rb
class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    # Teams the user is part of
    @user_teams = @user.user_teams.includes(:creator, :members)
    @user_team  = UserTeam.new

    # Upcoming matches for you OR any of your teammates (from user teams)
    member_ids_from_teams =
      @user_teams
        .joins(:members)
        .pluck("user_team_memberships.user_id")
        .uniq

    ids_for_scope = ([ @user.id ] + member_ids_from_teams).uniq

    @upcoming_matches =
      if ids_for_scope.empty?
        Match.none
      else
        Match
          .joins(teams: :registrations)
          .where("matches.date >= ?", Date.today)
          .where(registrations: { user_id: ids_for_scope })
          .includes(:city, :location)
          .distinct
          .order(:date, :time)
      end
  end
end
