# app/controllers/admin/locations_controller.rb
module Admin
  class LocationsController < BaseController
    before_action :set_city
    before_action :set_location, only: [ :show, :edit, :update, :destroy ]

    def index
      @locations = @city.locations.order(:name)
    end

    def show; end

    def new
      @location = @city.locations.new
    end

    def create
      @location = @city.locations.new(location_params)

      if @location.save
        redirect_to admin_city_location_path(@city, @location),
                    notice: "Plats skapad."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @location.update(location_params)
        redirect_to admin_city_location_path(@city, @location),
                    notice: "Plats uppdaterad."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @location.destroy
      redirect_to admin_city_locations_path(@city),
                  notice: "Plats borttagen."
    end

    private

    def set_city
      @city = City.from_param(params[:city_id])
    end

    def set_location
      @location = @city.locations.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:name, :address, :description)
    end
  end
end
