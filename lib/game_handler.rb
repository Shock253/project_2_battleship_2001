require "./lib/ship"
require "./lib/cell"
require "./lib/board"

class GameHandler
  # because this is a class, you need a runner file (basically a limited test file)
  # whose only function is to run the methods within the class

  # we initialize with two Board instances, so we have to require Board
  # we initialize with two empty arrays, which will be populated in the setup_game method

  def initialize
    @computer_board = Board.new
    @user_board = Board.new
    @computer_cruiser = Ship.new("Computer Cruiser", 3)
    @computer_submarine = Ship.new("Computer Submarine", 2)
    @user_cruiser = Ship.new("User Cruiser", 3)
    @user_submarine = Ship.new("User Submarine", 2)
    @computer_ships = []
    @user_ships = []

  end

  def setup_game

    computer_place_ships

    puts """
    I have laid out my ships on the grid.
    You now need to lay out your two ships.
    The Cruiser is three units long and the Submarine is two units long.
    """

    puts @user_board.render

    coordinates = []

    puts place_cruiser(@user_cruiser, coordinates)
    puts place_submarine(@user_submarine, coordinates)
  end

  def computer_place_ships
    computer_place_cruiser(@computer_cruiser)
    computer_place_submarine(@computer_submarine)
  end

  def computer_place_cruiser(computer_cruiser)
    coordinates = ["A1", "A1", "A1"]
    until coordinates.all? { |coordinate| @computer_board.valid_coordinate?(coordinate) && @computer_board.valid_placement?(computer_cruiser, coordinates) } do
      first_random_coordinate = @computer_board.cells.values.sample.coordinate

      coordinates = [first_random_coordinate, "#{first_random_coordinate[0]}" ++ "#{first_random_coordinate[1].to_i + 1}", "#{first_random_coordinate[0]}" ++ "#{first_random_coordinate[1].to_i + 2}"]
    end
    @computer_board.place(computer_cruiser, coordinates)
  end

  def computer_place_submarine(computer_submarine)
    coordinates = ["A1", "A1", "A1"]
    until coordinates.all? { |coordinate| @computer_board.valid_coordinate?(coordinate) && @computer_board.valid_placement?(computer_submarine, coordinates) } do
      first_random_coordinate = @computer_board.cells.values.sample.coordinate
      coordinates = [first_random_coordinate, "#{first_random_coordinate[0]}" ++ "#{first_random_coordinate[1].to_i + 1}"]
    end
    coordinates
    # @computer_board.place(computer_submarine, coordinates)
  end

  def place_cruiser(user_cruiser, coordinates)
    puts "First, enter the squares one by one for the Cruiser (3 spaces) using this format LN (L = letter, N = number):"

    puts "Enter first coordinate:"
    first_cruiser_coordinate = gets.chomp
    puts "Enter second coordinate:"
    second_cruiser_coordinate = gets.chomp
    puts "Enter third coordinate:"
    third_cruiser_coordinate = gets.chomp

    coordinates = [first_cruiser_coordinate, second_cruiser_coordinate, third_cruiser_coordinate]

    until coordinates.all? { |coordinate| @user_board.valid_coordinate?(coordinate) && @user_board.valid_placement?(@user_cruiser, coordinates) } do
      puts "Those are invalid coordinates. Please try again:"
      puts "Enter first coordinate:"
      first_cruiser_coordinate = gets.chomp
      puts "Enter second coordinate:"
      second_cruiser_coordinate = gets.chomp
      puts "Enter third coordinate:"
      third_cruiser_coordinate = gets.chomp

      coordinates = [first_cruiser_coordinate, second_cruiser_coordinate, third_cruiser_coordinate]
    end

    @user_board.place(user_cruiser, coordinates)
    @user_board.render(user_cruiser)
  end

  def place_submarine(user_submarine, coordinates)
    puts "First, enter the squares one by one for the Submarine (2 spaces) using this format LN (L = letter, N = number):"

    puts "Enter first coordinate:"
    first_submarine_coordinate = gets.chomp
    puts "Enter second coordinate:"
    second_submarine_coordinate = gets.chomp

    coordinates = [first_submarine_coordinate, second_submarine_coordinate]

    until coordinates.all? { |coordinate| @user_board.valid_coordinate?(coordinate) && @user_board.valid_placement?(@user_submarine, coordinates) } do
      puts "Those are invalid coordinates. Please try again:"
      puts "Enter first coordinate:"
      first_submarine_coordinate = gets.chomp
      puts "Enter second coordinate:"
      second_submarine_coordinate = gets.chomp

      coordinates = [first_submarine_coordinate, second_submarine_coordinate]
    end

    @user_board.place(user_submarine, coordinates)
    @user_board.render(user_submarine)

  end

  def debug_win_conditions
    @computer_ships = [
      Ship.new("Cruiser", 3),
      Ship.new("Submarine", 2)
    ]

    3.times do
      @computer_ships[0].hit
    end

    2.times do
      @computer_ships[1].hit
    end

    @user_ships = [
      Ship.new("Cruiser", 3),
      Ship.new("Submarine", 2)
    ]

    3.times do
      @user_ships[0].hit
    end

    2.times do
      @user_ships[1].hit
    end

  end

  def take_turn

  end

  def start_game
    quit = false
    until quit

      puts "Welcome to BATTLESHIP"
      puts "Enter p to play. Enter q to quit."
      response = gets.chomp.downcase

      if response != "q" && response != "p"
        puts "Please enter a valid response.\n\n"

      elsif response == "q"
        quit = true

      elsif response == "p"
        play_a_game_round
      end
    end
  end

<<<<<<< HEAD
  def play_a_game_round
    setup_game

    game_over = false
    until game_over

      take_turn

      if @computer_ships.all? {|ship| ship.sunk?}
        puts "You won!"
        game_over = true
      end

      if @user_ships.all? {|ship| ship.sunk?}
        puts "I won!"
        game_over = true
      end
    end
  end

=======
>>>>>>> Add Setup methods
end
