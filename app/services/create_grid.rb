require 'json'
require 'rest_client'
require 'nokogiri'

class CreateGrid(parent_request_id)
    
  grid_array = []
  original_grid_block = [33.818300.to_f, 118.500300.to_f, 33.818800.to_f, 118.499800.to_f]
  grid_array << original_grid_block
  #.0005 at 47 degrees latitude ~ 0.05 km

  grid = original_grid_block
  #this until loop creates columns within bounds
  until grid[2] >= 34.159200.to_f
    #builds a grid row
    until grid[3] <= 118.039200.to_f
      block = []
      block[0] = grid[0]
      block[1] = grid[3].round(6)
      block[2] = grid[2]
      block[3] = (grid[3] - 0.000500.to_f).round(6)
      grid_array << block
      grid = block
    end # end of row loop
    grid[2] = (grid[2] + 0.000500).round(6)
    grid[0] = (grid[0] + 0.000500).round(6)
    grid[1] = original_grid_block[1]
    grid[3] = original_grid_block[3]
  end #end of column loop

  grid_array.each do |bound|
    # Category_worker.perform_async(bound, parent_request_id)
    categories = Category.all
    categories.each do |category|
      # Parse_Businesses_Worker.perform_async()
      #bound = [sw_lat, sw_lng, ne_lat, ne_lng]
      url = "http://www.yelp.com/search/snippet?find_desc=#{category.url_name}&find_loc=&l=g%3A#{bound[0]}%2C#{bound[1]}%2C#{bound[2]}%2C#{bound[3]}&parent_request_id=#{parent_request_id}&request_origin=user"
      puts "url #{url}"
      begin
        search_results = RestClient.get(url, :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36" )

        if !search_results.nil?
          results = JSON.parse(search_results)
          doc = Nokogiri::HTML(results["search_results"])
          next_url = results["seo_pagination"]["relNextUrl"]
          # if !next_url.empty?
          #   ParseBusinessesWorker.perform_async(next_url)
          # end

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
            
              city_name = city.gsub("_", " ")
              puts "city #{city_name}"

              # exists = Business.where(name: name, address: street_address)
              # if exists.size <= 0
              #   business = Business.create({
              #     name: name,
              #     address: street_address,
              #     zipcode: zipcode,
              #     city: city_name,
              #     state: state,
              #     image: image,
              #     category: Category.find_by(name: category)
              #   })
              
                html_page.css('script').map(&:text)
               
                map_results = results["search_map"]["markers"]
                loc = map_results[data_key.to_s] if map_results.has_key?(data_key.to_s)
                puts "loc #{loc}"
                # if loc.present?
                #   business.location = Location.new(loc['location'])
                #   business.save
                # end
              # end
            end

          end
        end
  end
  
end
