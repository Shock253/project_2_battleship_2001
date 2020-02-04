require "minitest/autorun"
require "minitest/pride"
require "./lib/cell"
require "./lib/ship"

class CellTest < Minitest::Test
  def test_it_exists
    cell = Cell.new("B4")

    assert_instance_of Cell, cell
  end

  def test_has_attributes
    cell = Cell.new("B4")

    assert_equal "B4", cell.coordinate
    assert_nil cell.ship
  end

  def test_cell_starts_empty
    cell = Cell.new("B4")

    assert_equal true, cell.empty?
  end

  def test_can_place_ship
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)

    cell.place_ship(cruiser)

    assert_equal cruiser, cell.ship
    assert_equal false, cell.empty?
  end
end

# pry(main)> cruiser = Ship.new("Cruiser", 3)
# # => #<Ship:0x00007f84f0891238...>
#
# pry(main)> cell.place_ship(cruiser)
#
# pry(main)> cell.ship
# # => #<Ship:0x00007f84f0891238...>
#
# pry(main)> cell.empty?
# # => false
