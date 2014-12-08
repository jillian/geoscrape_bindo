class Grid
  def build
    grid_array = []
    original_grid_block = [33.818300.to_f, 118.500300.to_f, 33.818800.to_f, 118.499800.to_f]
    grid_array << original_grid_block
    #.0005 at 47 degrees latitude ~ 0.5 km. Making .5 km^2 grids

   
    grid = original_grid_block
    until grid[2] >= 34.159200.to_f
      until grid[3] <= 118.039200.to_f
        block = []
        block[0] = grid[0]
        block[1] = grid[3].round(6)
        block[2] = grid[2]
        block[3] = (grid[3] - 0.000500.to_f).round(6)
        grid_array << block
        grid = block
      end
      grid[2] = (grid[2] + 0.000500).round(6)
      grid[0] = (grid[0] + 0.000500).round(6)
      grid[1] = original_grid_block[1]
      grid[3] = original_grid_block[3]
    end
  grid_array
  end
end