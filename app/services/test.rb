# require 'rest_client'
# require 'nokogiri'
# require 'json'
# require 'pry'

# class Test
#   def do
#     #dummy query to get parent_request_id
#     category = 'active'
#     city = 'Los_Angeles'
#     neighborhood = 'Downtown'
#     state = 'CA'
#     begin
#       initial_page_request = RestClient.get("http://www.yelp.com/search?cflt=#{category}&l=p%3A#{state}%3A#{city}%3A%3A#{neighborhood}", "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36")
#       # find main("\w*") and string parse for unique ID:
#       html_page = Nokogiri::HTML(initial_page_request)
#       scripts = html_page.css('script').map(&:text) 
#       parent_request_id = scripts.map do |script|
#         script.match(/main\(\"\w*\"\)/).to_s
#       end.reject!(&:empty?).last.scan(/\(([^\)]+)\)/).last.first.scan(/\w*/)[1]
#       puts "parent_request_id ==> #{parent_request_id}"
#     rescue => e
#       binding.pry
#       puts "Unable to get parent_request_id: #{e}" 
#     ensure
#       sleep 3.0 + rand
#     # end

#     # grid_array = []
#     # original_grid_block = [33.818300.to_f, 118.500300.to_f, 33.818800.to_f, 118.499800.to_f]
#     # grid_array << original_grid_block
#     # #.0005 at 47 degrees latitude ~ 0.05 km


#     # grid = original_grid_block
#     # until grid[2] >= 34.159200.to_f
#     #   until grid[3] <= 118.039200.to_f
#     #     block = []
#     #     block[0] = grid[0]
#     #     block[1] = grid[3].round(6)
#     #     block[2] = grid[2]
#     #     block[3] = (grid[3] - 0.000500.to_f).round(6)
#     #     grid_array << block
#     #     grid = block
#     #   end
#     #   grid[2] = (grid[2] + 0.000500).round(6)
#     #   grid[0] = (grid[0] + 0.000500).round(6)
#     #   grid[1] = original_grid_block[1]
#     #   grid[3] = original_grid_block[3]
#     # end

#     # grid_1 = [original_grid_block]


#     grid_test = [[37.746964676, 122.453784943, 37.7876744001, 122.402629852]]
#     grid_test.each do |bound|
#       # categories =  ['active','arts','auto','beautysvc','education','eventservices','financialservices','food','health','homeservices','nightlife','pets','hotelstravel','localflavor','localservices','massmedia','professional','publicservicesgovt','realestate','religiousorgs','restaurants','shopping']
#       # categories.each do |category|
#         url = "http://www.yelp.com/search/snippet?find_desc=#{category}&find_loc=&l=g%3A-#{bound[1]}%2C#{bound[0]}%2C-#{bound[3]}%2C#{bound[2]}&parent_request_id=#{parent_request_id}&request_origin=user"
#             puts "url #{url}"

#               search_results = RestClient.get(url, :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36" )

#               results = JSON.parse(search_results)
#               if !results["search_results"].include?('class="no-results"')
                
#                 doc = Nokogiri::HTML(results["search_results"])
#                 # next_url = results["seo_pagination"]["relNextUrl"]
#                 # if !next_url.empty?
#                 #   ParseBusinessesWorker.perform_async(next_url)
#                 # end

#                 doc.css('ul.search-results div.search-result').each do |element|
#                   name = element.css('.media-story .biz-name').text
#                   puts "****BUSINESS******"
#                   puts "name #{name}"

#                   img_node = element.css('.media-avatar img:first')
#                   image = img_node.xpath("@*[starts-with(name(), 'src')]").text
#                   puts "image #{image}"
#                   data_key = element.xpath("@*[starts-with(name(), 'data-key')]").text.to_i

#                   full_address_nodeset = element.css('.secondary-attributes address:first')
#                   if !full_address_nodeset.empty?
#                     #full_address_nodeset is a nokogiri nodeset with one node.
#                     full_address = full_address_nodeset.first.children
#                     street_address = full_address.first.text.strip 
#                     puts "#{street_address}"
#                     zipcode = full_address.text.split(' ')[-1].to_i
#                     if zipcode.is_a?(Integer)
#                       zipcode = zipcode
#                     end
#                     puts "zipcode = #{zipcode}"
#                     state = full_address.text.split(' ')[-2]
#                     puts "state #{state}"
                  
#                     city_name = city.gsub("_", " ")
#                     puts "city #{city_name}"

#                     # exists = Business.where(name: name, address: street_address)
#                     # if exists.size <= 0
#                     #   business = Business.create({
#                     #     name: name,
#                     #     address: street_address,
#                     #     zipcode: zipcode,
#                     #     city: city_name,
#                     #     state: state,
#                     #     image: image,
#                     #     category: Category.find_by(name: category)
#                     #   })
                    
#                       html_page.css('script').map(&:text)
                     
#                       map_results = results["search_map"]["markers"]
#                       loc = map_results[data_key.to_s] if map_results.has_key?(data_key.to_s)
#                       puts "loc #{loc}"
#                       # if loc.present?
#                       #   business.location = Location.new(loc['location'])
#                       #   business.save
#                       # end
#                     # end
#                   end
#                 end
#               else 
#                 puts "no businesses"
#               end
        
#           end
#         end
#       end
#   end


# test = Test.new
# test.do








