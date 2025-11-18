# app/controllers/admin/cities_controller.rb
module Admin
  class CitiesController < BaseController
    before_action :set_city, only: [ :show, :edit, :update, :destroy ]

    def index
      @cities = City.order(:name)
    end

    def show
      @locations = @city.locations.order(:name)
      @upcoming_matches = @city.matches
                              .where("date >= ?", Date.today)
                              .order(:date, :time)
    end

    def new
      @city = City.new
    end

    def create
      @city = City.new(city_params)
      if @city.save
        redirect_to admin_city_path(@city), notice: "Stad skapad."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @city.update(city_params)
        redirect_to admin_city_path(@city), notice: "Stad uppdaterad."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @city.destroy
      redirect_to admin_cities_path, notice: "Stad borttagen."
    end

    private

    def set_city
      @city = City.from_param(params[:id])
    end

    def city_params
      params.require(:city).permit(:name, :description, :color)
    end
  end
end
