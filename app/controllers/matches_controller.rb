class MatchesController < ApplicationController
  # Public schedule – no authentication

  def schedule
    @cities = City.order(:name)

    # now includes list view
    @view = params[:view].in?(%w[week month list]) ? params[:view] : "month"

    @selected_city =
      if params[:city].present?
        begin
          City.from_param(params[:city])
        rescue ActiveRecord::RecordNotFound
          nil
        end
      end

    # Used to color the closed <select> label
    @selected_city_color =
      if @selected_city
        @selected_city.try(:accent_color).presence ||
          @selected_city.try(:color_hex).presence ||
          @selected_city.try(:primary_color).presence ||
          @selected_city.try(:color).presence
      end

    reference_date =
      if params[:start].present?
        begin
          Date.parse(params[:start])
        rescue ArgumentError
          Date.today
        end
      else
        Date.today
      end

    @reference_date = reference_date

    scope = Match.includes(:city, :location).where("date >= ?", Date.today)
    scope = scope.where(city: @selected_city) if @selected_city

    case @view
    when "week"
      @start_date = reference_date.beginning_of_week(:monday)
      @end_date   = @start_date + 6.days
    when "list"
      # rolling 14-day window
      @start_date = reference_date
      @end_date   = reference_date + 13.days
    else # "month"
      @start_date = reference_date.beginning_of_month.beginning_of_week(:monday)
      @end_date   = reference_date.end_of_month.end_of_week(:monday)
    end

    @matches_by_date = scope.where(date: @start_date..@end_date).group_by(&:date)
  end
end
