require 'rest_client'

class MainController < ApplicationController

  def scrape
    grid = Grid.new
    geo_grid = grid.build 
    categories = Category.all
    parent_request_id = ParentRequestId.get_id

    geo_grid.each do |bound|
      sleep 5
      categories.each do |category|
        sleep 5
        YelpWorker.perform_async(bound, category.url_name, parent_request_id)
      end
    end
    redirect_to root_url
  end
end

