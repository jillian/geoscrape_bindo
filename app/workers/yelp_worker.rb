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
    url = "http://www.yelp.com/search/snippet?find_desc=#{category}&find_loc=&l=g%3A-#{bound[1]}%2C#{bound[0]}%2C-#{bound[3]}%2C#{bound[2]}&parent_request_id=#{parent_request_id}&request_origin=user"
    puts "url #{url}"
    search_results = RestClient.get(url, :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36" )
    # begin

      results = JSON.parse(search_results)
      if !results["search_results"].include?('no-results')

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

            if !full_address.css('br')[0].nil?
              city = full_address.css('br')[0].next.text.strip.split(" ")[0..-3].join(" ").chomp(",")
              puts "city #{city}"
            end

            exists = Business.where(name: name, address: street_address)
            if exists.size <= 0
              cat_found = Category.find_by_url_name(category)
              business = Business.new({
                name: name,
                address: street_address,
                zipcode: zipcode,
                city: city_name,
                state: state,
                image: image,
                category_id: cat_found.id
              })
              business.save

              Rails.logger.error("Business: #{business}")
              puts "category=== #{category}"
              map_results = results["search_map"]["markers"]
              loc = map_results[data_key.to_s] if map_results.has_key?(data_key.to_s)
              puts "loc #{loc}"

              if loc.present?
                business.location = Location.new(loc['location'])
                business.save
              end #loc.present?
            end # if exists.size <=0
          end # full_address parsing
        end # doc.css parsing
      end # search_results parsing
    # rescue RestClient::ResourceNotFound => ex
    #   puts "after first rescue #{ex}"
    # rescue Exception => e
    #   puts "after exception #{e}"
    # end
  end
end