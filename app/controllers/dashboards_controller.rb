# app/controllers/dashboards_controller.rb
class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    # Teams the user is part of
    @user_teams = @user.user_teams.includes(:creator, :members)

    # Matches the user (or teammates) is registered for
    member_ids_from_teams =
      @user_teams
        .joins(:members)
        .pluck("user_team_memberships.user_id")
        .uniq

    ids_for_scope = ([ @user.id ] + member_ids_from_teams).uniq

    @registered_matches =
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

    # ---- HERE is the important part ----
    # Upcoming matches to register for (next 5), with optional city filter
    @cities = City.order(:name)

    @selected_city =
      if params[:city].present?
        begin
          City.from_param(params[:city])
        rescue ActiveRecord::RecordNotFound
          nil
        end
      end

    @selected_city_color =
      if @selected_city
        @selected_city.try(:accent_color).presence ||
          @selected_city.try(:color_hex).presence ||
          @selected_city.try(:primary_color).presence ||
          @selected_city.try(:color).presence
      end

    discover_scope =
      Match
        .includes(:city, :location)
        .where("date >= ?", Date.today)

    discover_scope = discover_scope.where(city: @selected_city) if @selected_city

    @discover_matches =
      discover_scope
        .order(:date, :time)
        .limit(5)
  end
end
