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

  def social
    instagram_client = InstagramClient.new

    @instagram_media =
      Rails.cache.fetch("instagram:media", expires_in: 10.minutes) do
        instagram_client.recent_media(limit: 12)
      end

    @instagram_stories =
      Rails.cache.fetch("instagram:stories", expires_in: 1.minute) do
        instagram_client.current_stories(limit: 12)
      end
  end
end
