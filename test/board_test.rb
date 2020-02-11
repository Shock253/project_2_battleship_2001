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

    assert_equal false, @board.valid_placement?(@cruiser, ["X1", "Y2"])
    assert_equal false, @board.valid_placement?(@submarine, ["22", "33", "44"])

    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "C1"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A3", "A2", "A1"])
    assert_equal false, @board.valid_placement?(@submarine, ["C1", "B1"])

    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "B2", "C3"])
    assert_equal false, @board.valid_placement?(@submarine, ["C2", "D3"])

    assert_equal true, @board.valid_placement?(@cruiser, ["A2", "A3", "A4"])
    assert_equal true, @board.valid_placement?(@cruiser, ["B1", "C1", "D1"])
    assert_equal true, @board.valid_placement?(@submarine, ["A1", "A2"])

    @board.place(@cruiser, ["A1", "A2", "A3"])

    assert_equal false, @board.valid_placement?(@submarine, ["A1", "B1"])

  end

  def test_can_place_ship
    @board.place(@cruiser, ["A1", "A2", "A3"])

    cell_1 = @board.cells["A1"]
    cell_2 = @board.cells["A2"]
    cell_3 = @board.cells["A3"]

    assert_equal @cruiser, cell_1.ship
    assert_equal @cruiser, cell_2.ship
    assert_equal @cruiser, cell_3.ship
  end

  def test_can_render_board
    @board.place(@cruiser, ["A1", "A2", "A3"])

    rendered_board1 = "  1 2 3 4 \n"+
                      "A . . . . \n"+
                      "B . . . . \n"+
                      "C . . . . \n"+
                      "D . . . . \n"

    assert_equal rendered_board1, @board.render

    rendered_board2 = "  1 2 3 4 \n"+
                      "A S S S . \n"+
                      "B . . . . \n"+
                      "C . . . . \n"+
                      "D . . . . \n"

    assert_equal rendered_board2, @board.render(true)
  end

  def test_can_hit_board
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@submarine, ["C1", "D1"])

    @board.fire_on_coordinate("A1")
    @board.fire_on_coordinate("B4")
    @board.fire_on_coordinate("C1")
    @board.fire_on_coordinate("D1")

    expected_board1 = "  1 2 3 4 \n" +
                      "A H . . . \n" +
                      "B . . . M \n" +
                      "C X . . . \n" +
                      "D X . . . \n"

    expected_board2 = "  1 2 3 4 \n" +
                      "A H S S . \n" +
                      "B . . . M \n" +
                      "C X . . . \n" +
                      "D X . . . \n"

    assert_equal expected_board1, @board.render
    assert_equal expected_board2, @board.render(true)
  end
end
