require "minitest/autorun"
require "minitest/pride"
require "./lib/board"
require "./lib/cell"
require "./lib/ship"

class ClassTest < Minitest::Test

  def setup

    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @titanic = Ship.new("Titanic", 3)
    @titanic.hit
    @titanic.hit
    @titanic.hit

  end

  def test_it_exists

    assert_instance_of Board, @board
  end

  def test_has_cells

    assert_instance_of Hash, @board.cells
    assert_equal 16, @board.cells.size
    @board.cells.each do |cell|
      assert_instance_of Cell, cell[1]
    end
  end

  def test_coordinate_validation

    assert_equal true, @board.valid_coordinate?("A1")
    assert_equal true, @board.valid_coordinate?("D4")
    assert_equal false, @board.valid_coordinate?("A5")
    assert_equal false, @board.valid_coordinate?("E1")
    assert_equal false, @board.valid_coordinate?("A22")
  end

  def test_valid_placement

    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2"])
    assert_equal false, @board.valid_placement?(@submarine, ["A2", "A3", "A4"])

    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "C1"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A3", "A2", "A1"])
    assert_equal false, @board.valid_placement?(@submarine, ["C1", "B1"])

  end

end
#
# pry(main)> board.valid_placement?(cruiser, ["A1", "A2", "A4"])
# # => false
#
# pry(main)> board.valid_placement?(submarine, ["A1", "C1"])
# # => false
#
# pry(main)> board.valid_placement?(cruiser, ["A3", "A2", "A1"])
# # => false
#
# pry(main)> board.valid_placement?(submarine, ["C1", "B1"])
# # => false
