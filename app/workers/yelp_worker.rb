require 'nokogiri'
require 'json'
require 'rest_client'

RestClient.log =
  Object.new.tap do |proxy|
    def proxy.<<(message)
      Rails.logger.info message
    end
  end

class YelpWorker
  include Sidekiq::Worker

  def perform(bound, category, parent_request_id)
     puts "args category #{category}, bound #{bound}, parent_request_id #{parent_request_id}"
      url = "http://www.yelp.com/search/snippet?find_desc=#{category}&find_loc=&l=g%3A-#{bound[1]}%2C#{bound[0]}%2C-#{bound[3]}%2C#{bound[2]}&parent_request_id=#{parent_request_id}&request_origin=user"
      puts "url #{url}"
      search_results = RestClient.get(url, :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36" )

        results = JSON.parse(search_results)
        if !results["search_results"].include?('class="no-results"')
          # puts "results[search_results] #{results['search_results']}"
          # puts "what do i return? #{results["search_results"].include?('class="no-results"')}"
          doc = Nokogiri::HTML(results["search_results"])
          doc.css('ul.search-results div.search-result').each do |element|
            name = element.css('.media-story .biz-name').text
            puts "****BUSINESS******"
            puts "name #{name}"

            img_node = element.css('.media-avatar img:first')
            image = img_node.xpath("@*[starts-with(name(), 'src')]").text
            puts "image #{image}"
            data_key = element.xpath("@*[starts-with(name(), 'data-key')]").text.to_i

            full_address_nodeset = element.css('.secondary-attributes address:first')
            if !full_address_nodeset.empty?
              #full_address_nodeset is a nokogiri nodeset with one node.
              full_address = full_address_nodeset.first.children
              street_address = full_address.first.text.strip
              puts "#{street_address}"
              zipcode = full_address.text.split(' ')[-1].to_i
              if zipcode.is_a?(Integer)
                zipcode = zipcode
              end
              puts "zipcode = #{zipcode}"
              state = full_address.text.split(' ')[-2]
              puts "state #{state}"

              city_name = full_address.text.split(' ')[-3]
              puts "city #{city_name}"

              puts "jkladjksa"
              exists = Business.where(name: name, address: street_address)
              puts "category 1 #{category}"
              puts "exists #{exists}"
              if exists.size <= 0
                business = Business.new({
                  name: name,
                  address: street_address,
                  zipcode: zipcode,
                  city: city_name,
                  state: state,
                  image: image,
                  category: Category.find_by_url_name(category)
                })
                business.save
                map_results = results["search_map"]["markers"]
                loc = map_results[data_key.to_s] if map_results.has_key?(data_key.to_s)
                puts "loc #{loc}"

                if loc.present?
                  business.location = Location.new(loc['location'])
                  business.save
                end

                end #address loop
              end #doc.css

            end
          end #doc loop
        end #address loop

      # rescue RestClient::ResourceNotFound => ex
      #   puts "after first rescue #{ex}"
      # rescue Exception => e
      #   puts "after exception #{e}"
      # end

end