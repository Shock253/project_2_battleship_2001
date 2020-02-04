require "minitest/autorun"
require "minitest/pride"
require "./lib/ship"

class ShipTest < Minitest::Test

  def test_it_exists
    cruiser = Ship.new("Cruiser", 3)

    assert_instance_of Ship, cruiser
  end

  def test_it_has_attributes
    cruiser = Ship.new("Cruiser", 3)
    ghost_ship = Ship.new("The Flying Dutchman", -2)

    assert_equal "Cruiser", cruiser.name
    assert_equal 3, cruiser.length
    assert_equal 3, cruiser.health
    assert_equal 0, ghost_ship.length
    assert_equal 0, ghost_ship.health
  end

  def test_for_sunk_method
    cruiser = Ship.new("Cruiser", 3)
    titanic = Ship.new("Titanic", 0)

    assert_equal false, cruiser.sunk?
    assert_equal true, titanic.sunk?
  end

  def test_ship_is_hit
    cruiser = Ship.new("Cruiser", 3)

    cruiser.hit
    assert_equal 2, cruiser.health

    cruiser.hit
    assert_equal 1, cruiser.health

    cruiser.hit
    assert_equal 0, cruiser.health
    assert_equal true, cruiser.sunk?

    titanic = Ship.new("Titanic", 0)

    titanic.hit
    assert_equal 0, titanic.health
  end
end
