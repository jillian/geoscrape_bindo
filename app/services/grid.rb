class Grid

# choose any grid size/location and parser should work
geo_area_bounds = [sw_lat: 33.74, sw_lng: 118.45, ne_lat: 34.20, ne_lng: 118.00] 

  def build(geo_area_bounds)
    #build rows 

    original_grid = [
      geo_area_bounds[:sw_lat], 
      geo_area_bounds[:sw_lng], 
      (geo_area_bounds[:sw_lat] + 0.04), 
      (geo_area_bounds[:sw_lng] - 0.05)
    ]
    grid_array = []

    grid = original_grid
    until grid[3] < geo_area_bounds[:ne_lng]
      row_block = []
      row_block[0] = original_grid[0].to_f
      row_block[1] = grid[3]
      row_block[2] = original_grid[2].to_f
      row_block[3] = grid[3] - 0.05
      row_block.map do |x|
        x.to_f
      end
      grid = row_block
      grid_array << row_block 
    end

    # build columns on top of arrays:
    
    row_array = []
    grid_array.map do |y|
      row_array << y
    end

    row_array.map do |x|
      grid = x
      until grid[2] > geo_area_bounds[:ne_lat]
        column_block = []
        column_block[0] = grid[2]
        column_block[1] = grid[1]
        column_block[2] = grid[2] + 0.04
        column_block[3] = grid[3]
        # column_block.map do |x|
        #   x.to_f
        # end
        grid = column_block
        grid_array << column_block
      end
    end
  end


end