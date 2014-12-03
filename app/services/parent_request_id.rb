require 'rest_client'
require 'nokogiri'
require "pry"
require 'json'

# split into distinct jobs - scrape cities, 
# 

class ParentRequestId


  def grab

      #dummy query to get parent_request_id
  category = 'active'
  city = 'Los_Angeles'
  neighborhood = 'Downtown'
  state = 'CA'
    
    initial_page_request = RestClient.get("http://www.yelp.com/search?cflt=#{category}&l=p%3A#{state}%3A#{city}%3A%3A#{neighborhood}", "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36")
    # find main("\w*") and string parse for unique ID:
    html_page = Nokogiri::HTML(initial_page_request)
    scripts = html_page.css('script').map(&:text) 
    parent_request_id = scripts.map do |script|
      script.match(/main\(\"\w*\"\)/).to_s
    end.reject!(&:empty?).last.scan(/\(([^\)]+)\)/).last.first.scan(/\w*/)[1]
    puts "parent_request_id ==> #{parent_request_id}"
    rescue => e
      puts "Unable to get parent_request_id: #{e}" 
      sleep 5
    ensure
      sleep 3.0 + rand
  end

  ParseBusinessesWorker.perform_async(parent_request_id)
end

test = ParentRequestId.new
test.grab
