require 'rest_client'

class MainController < ApplicationController

  def scrape
    grid = Grid.new
    geo_grid = grid.build
    categories = Category.all
    pr_id = ParentRequestId.new
    request_id = pr_id.get_id

    # manual_grid = [
    #   # [34.037000000, 118.208000000, 34.0770000000, 118.208000000]
    #   # [37.746964676, 122.453784943, 37.7876744001, 122.402629852],
    #   # [33.746964676, 118.453784943, 33.7876744001, 118.402629852],
    #   # [33.746964676, 118.402629852, 33.7876744001, 118.352629852],
    #   # [33.746964676, 118.352629852, 33.7876744001, 118.302629852],
    #   # [33.746964676, 118.302629852, 33.7876744001, 118.252629852],
    #   # [33.746964676, 118.252629852, 33.7876744001, 118.202629852],
    #   # [33.787674400, 118.252629852, 33.8276744001, 118.202629852],
    #   [33.827674400, 118.252629852, 33.8676744001, 118.202629852]
    # ]

    geo_grid.each do |bound|
      sleep 10
      categories.each do |category|
        sleep 10
        crawler = YelpWorker.perform_async(bound, category.url_name, request_id)
      end
    end
  end
end