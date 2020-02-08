require "./lib/cell"

class Board
  attr_reader :cells

  def initialize
    @cells = Hash.new
    @letters = "A".."D"

    @letters.to_a.each do |letter|
      4.times do |number|
        @cells.merge!("#{letter}#{number + 1}" => Cell.new("#{letter}#{number + 1}"))
      end
    end
  end

  def valid_coordinate?(coordinate)
    valid_letters = "A".."D"
    valid_numbers = 1..4
    number = coordinate[1].to_i
    valid_letters.include?(coordinate[0]) && valid_numbers.include?(number) && coordinate.length == 2
  end

  def valid_placement?(ship, ship_coordinates)
    if ship_coordinates.any? { |coordinate| @cells[coordinate].ship != nil }
      false
    elsif ship.length == ship_coordinates.size
      are_coordinates_valid = ship_coordinates.all? do |coordinate|
        valid_coordinate?(coordinate)
      end

      if !are_coordinates_valid
        return false
      end

      is_consecutive_letters = true
      is_consecutive_numbers = true

      ship_coordinates.each_with_index do |coordinate, position_in_array|
        if position_in_array != ship_coordinates.length - 1

          current_number = coordinate[1].to_i
          next_number = ship_coordinates[position_in_array + 1][1].to_i

          if current_number + 1 != next_number
            is_consecutive_numbers = false
          end
        end
      end


      ship_coordinates.each_with_index do |coordinate, position_in_array|
        if position_in_array != ship_coordinates.length - 1

          current_letter_ordinal_value = coordinate[0].ord
          next_letter_ordinal_value = ship_coordinates[position_in_array + 1][0].ord

          if current_letter_ordinal_value + 1 != next_letter_ordinal_value
            is_consecutive_letters = false
          end
        end
      end

      is_consecutive_numbers ^ is_consecutive_letters
      # (is_consecutive_numbers && !is_consecutive_letters) || (!is_consecutive_numbers && is_consecutive_letters)

    else
      false
    end
  end

  def place(ship, ship_coordinates)
    if valid_placement?(ship, ship_coordinates)
      ship_coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
    end
  end

  def render(show_ships = false)
    rendered_board =   "  1 2 3 4 \n"
    @letters.to_a.each do |letter|
      rendered_board << letter + " "
      4.times do |number|
        current_cell = @cells["#{letter}#{number + 1}"]
        rendered_board << current_cell.render(show_ships) + " "
      end
      rendered_board << "\n"
    end
    rendered_board
    #
    # rendered_board =  "  1 2 3 4 \n"+
    #                   "A S S S . \n"+
    #                   "B . . . . \n"+
    #                   "C . . . . \n"+
    #                   "D . . . . \n"

  end

  def fire_on_coordinate(target)
    @cells[target].fire_upon
  end

end
