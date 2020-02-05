require "minitest/autorun"
require "minitest/pride"
require "./lib/board"
require "./lib/cell"
require "./lib/ship"
require "pry"

class ClassTest < Minitest::Test
  def test_it_exists
    board = Board.new

    assert_instance_of Board, board
  end

  def test_has_cells
    board = Board.new

    assert_instance_of Hash, board.cells
    assert_equal 16, board.cells.size
    board.cells.each do |cell|
      assert_instance_of Cell, cell[1]
    end
  end

  def test_coordinate_validation
    board = Board.new

    assert_equal true, board.valid_coordinate?("A1")
    assert_equal true, board.valid_coordinate?("D4")
    assert_equal false, board.valid_coordinate?("A5")
    assert_equal false, board.valid_coordinate?("E1")
    assert_equal false, board.valid_coordinate?("A22")
  end
end
