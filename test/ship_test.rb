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

    assert_equal "Cruiser", cruiser.name
    assert_equal 3, cruiser.length
    assert_equal 3, cruiser.health
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
  end

end

# pry(main)> cruiser.hit
#
# pry(main)> cruiser.health
# #=> 2
#
# pry(main)> cruiser.hit
#
# pry(main)> cruiser.health
# #=> 1
#
# pry(main)> cruiser.sunk?
# #=> false
#
# pry(main)> cruiser.hit
#
# pry(main)> cruiser.sunk?
# #=> true
