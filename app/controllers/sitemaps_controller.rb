class SitemapsController < ApplicationController
  layout false

  # Public sitemap
  def index
    respond_to do |format|
      format.xml
    end
  end
end
