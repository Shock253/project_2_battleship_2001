class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    (@ship == nil)
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    @fired_upon = true
    if !(@ship == nil)
      @ship.hit
    end
  end

  def render(show_ships = false)
    if @fired_upon && @ship && @ship.sunk?
      "X"
    elsif @fired_upon && @ship && !@ship.sunk?
      "H"
    elsif @fired_upon && !@ship
      "M"
    elsif !@fired_upon && @ship && show_ships
      "S"
    else
      "."
    end
  end

end
