class PagesController < ApplicationController
  def home
    @city_colors = City.pluck(:name, :color).to_h
  end

  def about; end
  def privacy; end
  def terms; end
  def contact; end

  def features; end
  def business; end
  def help; end
end
