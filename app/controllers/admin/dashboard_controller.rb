module Admin
  class DashboardController < BaseController
    def index
      @users_count   = User.count
      @admins_count  = User.admins.count
      @recent_users  = User.order(created_at: :desc).limit(5)

      @cities_count    = City.count
      @locations_count = Location.count
      @matches_count   = Match.count

      @upcoming_matches = Match
                            .includes(:city, :location)
                            .where("date >= ?", Date.today)
                            .order(:date, :time)
                            .limit(5)
    end

    def show
      # Optional: kan användas senare
    end
  end
end
