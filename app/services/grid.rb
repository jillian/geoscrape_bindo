require 'bigdecimal'

class Grid

# LA Grid --> 
# sw_latitude: 33.746964676
# sw_longitude: -118.453784943
# ne_latitude: 34.146964676
# ne_longitude: -118.039200000

  def build
    original_grid = [BigDecimal.new('33.746964676'), BigDecimal.new('118.453784943'), BigDecimal.new('33.7876744001'), BigDecimal.new('118.402629852')]
    grid_array = []
    first_block = [33.74, 118.45, 33.78, 118.40]

    grid_1 = first_block
    until grid_1[3] < 118.00
      row_block = []
      row_block[0] = original_grid[0].to_f
      row_block[1] = grid_1[3]
      row_block[2] = original_grid[2].to_f
      row_block[3] = grid_1[3] - 0.05
      row_block.map do |x|
        x.to_f
      end
      grid_1 = row_block
      grid_array << row_block 
    end
    # puts "row count - #{grid_array.count}"
    # puts "ROW ARRAY ==> "
    # puts "#{grid_array}"

    # build columns on top of arrays

    grid_array_2 = [grid_array[0], grid_array[1], grid_array[2], grid_array[3], grid_array[4], grid_array[5], grid_array[6],grid_array[7], grid_array[8]]
    grid_array_2.each do |x|
      grid_2 = x
      until grid_2[2] > 34.20
        column_block = []
        column_block[0] = grid_2[2]
        column_block[1] = grid_2[1]
        column_block[2] = grid_2[2] + 0.05
        column_block[3] = grid_2[3]
        # column_block.map do |x|
        #   x.to_f
        # end
        grid_2 = column_block
        grid_array << column_block
      end
    end
    # puts "*****************"
    # puts "******************"
    # puts "final grid array #{grid_array}"
    # puts "final count - #{grid_array.count}"
    # grid_array
  end


end