require 'rest_client'

class MainController < ApplicationController

  def scrape
    grid = Grid.new
    geo_grid = grid.build
    categories = Category.all
    pr_id = ParentRequestId.new
    request_id = pr_id.get_id

    # geo_grid.each do |bound|
      sleep 10
      bound = [37.746964676, 122.453784943, 37.7876744001, 122.402629852]
      categories.each do |category|
        sleep 10
        crawler = YelpWorker.new
        crawler.perform(bound, category.url_name, request_id)
      end
    # redirect_to :root_url
    # end
  end
end