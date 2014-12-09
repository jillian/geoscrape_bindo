class Grid

# LA Grid --> 
# sw_latitude: 33.746964676
# sw_longitude: -118.453784943
# ne_latitude: 34.146964676
# ne_longitude: -118.039200000

  def build
    grid_array = []
    original_grid_block = [33.818300.to_f, 118.500300.to_f, 33.833800.to_f, 118.499800.to_f]
    grid_array << original_grid_block
    

   
    grid = original_grid_block
    until grid[2] >= 34.146964676.to_f
      until grid[3] <= 118.039200000.to_f
        block = []
        block[0] = grid[0]
        block[1] = grid[3].round(6)
        block[2] = grid[2]
        block[3] = (grid[3] - 0.020000.to_f).round(9)
        grid_array << block
        grid = block
      end
      grid[0] = grid[2]
      grid[2] = (grid[2] + 0.020000).round(9)
      grid[1] = original_grid_block[1]
      grid[3] = original_grid_block[3]
    end
  grid_array
  end
end


# san fran grid block
# -122.453784943 difference: .051155091
# -122.402629852
#  37.746964676  difference: .0407097241 distance between: 2.814 mi, 4.528km
#  37.7876744001  .02 diff => 1.432 mi, 2.304 km

# LA grid block
# -118.453784943
# -118.402629852
# 33.746964676
# 33.7876744001 