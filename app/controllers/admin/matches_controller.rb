module Admin
  class MatchesController < BaseController
    before_action :set_match, only: [ :show, :edit, :update, :destroy ]
    before_action :load_cities_and_locations, only: [ :new, :edit, :create, :update ]

    def index
      @matches = Match.includes(:city, :location).order(date: :desc, time: :desc)
    end

    def show
      @teams = @match.teams.includes(:registrations)
    end

    def new
      @match = Match.new
    end

    def create
      @match = Match.new(match_params)
      if @match.save
        redirect_to admin_match_path(@match), notice: "Match skapad."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @match.update(match_params)
        redirect_to admin_match_path(@match), notice: "Match uppdaterad."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @match.destroy
      redirect_to admin_matches_path, notice: "Match borttagen."
    end

    private

    def set_match
      @match = Match.find(params[:id])
    end

    def match_params
      params.require(:match).permit(
        :title,
        :description,
        :price,
        :date,
        :time,
        :city_id,
        :location_id,
        :soft_limit_per_team,
        :hard_limit_total,
        :teams_count,
        :reminder_offset_minutes
      )
    end

    def load_cities_and_locations
      @cities    = City.order(:name).includes(:locations)
      @locations = Location.includes(:city).order(:name)
    end
  end
end
