class ScrapeController < ApplicationController
  def run
    test = Scrape.new
    test.scrape_businesses
    redirect_to root_url
  end
end
