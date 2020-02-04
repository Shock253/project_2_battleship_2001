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
end
