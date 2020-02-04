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
end
