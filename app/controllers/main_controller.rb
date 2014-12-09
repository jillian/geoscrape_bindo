require 'rest_client'

class MainController < ApplicationController

  def scrape
    grid = Grid.new
    geo_grid = grid.build
    categories = Category.all
    pr_id = ParentRequestId.new
    request_id = pr_id.get_id

    manual_grid = [
      [37.746964676, 122.453784943, 37.7876744001, 122.402629852],
      [33.746964676, 118.453784943, 33.7876744001, 118.402629852],
      [33.746964676, 118.402629852, 33.7876744001, 118.352629852],
      [33.746964676, 118.352629852, 33.7876744001, 118.302629852]
    ]

    manual_grid.each do |bound|
      sleep 10
      #bound = [33.746964676, 118.453784943, 33.7876744001, 118.402629852]
      categories.each do |category|
        sleep 10
        crawler = YelpWorker.new
        crawler.perform(bound, category.url_name, request_id)
      end
    # redirect_to :root_url
    end
  end
end