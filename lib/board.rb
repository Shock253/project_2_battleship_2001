class Board
  attr_reader :cells

  def initialize
    @cells = Hash.new
    letters = "A".."D"

    letters.to_a.each do |letter|
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
end
