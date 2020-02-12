require "./lib/ship"
require "./lib/cell"
require "./lib/board"

class GameHandler
  attr_reader :computer_board, :user_board

  def initialize
    @computer_board = Board.new
    @user_board = Board.new
    @computer_cruiser = Ship.new("Cruiser", 3)
    @computer_submarine = Ship.new("Submarine", 2)
    @user_cruiser = Ship.new("Cruiser", 3)
    @user_submarine = Ship.new("Submarine", 2)
    @computer_ships = [@computer_cruiser, @computer_submarine]
    @user_ships = [@user_cruiser, @user_submarine]
  end

  def setup_game
    @computer_board = Board.new
    @user_board = Board.new
    @computer_cruiser = Ship.new("Cruiser", 3)
    @computer_submarine = Ship.new("Submarine", 2)
    @user_cruiser = Ship.new("User Cruiser", 3)
    @user_submarine = Ship.new("User Submarine", 2)
    @computer_ships = [@computer_cruiser, @computer_submarine]
    @user_ships = [@user_cruiser, @user_submarine]

    computer_hide_ships

    puts "I have laid out my ships on the grid."
    puts "You now need to lay out your two ships."
    puts "The Cruiser is three units long and the Submarine is two units long."

    user_place_ship(@user_ships[0])
    user_place_ship(@user_ships[1])

    puts @user_board.render(true)
    # have the user place their ships
  end

  def computer_hide_ships
    computer_place_ship(@computer_cruiser)
    computer_place_ship(@computer_submarine)
  end

  def computer_place_ship(computer_ship)
    coordinates = []
    until @computer_board.valid_placement?(computer_ship, coordinates) do
      first_random_coordinate = @computer_board.cells.values.sample.coordinate
      is_vertical = (Random.rand(2) == 1)

      coordinates = []
      computer_ship.length.times do |ship_section|
        if is_vertical
          coordinates << "#{first_random_coordinate[0]}#{first_random_coordinate[1].to_i + ship_section}"
        elsif !is_vertical
          coordinates << "#{(first_random_coordinate[0].ord + ship_section).chr}#{first_random_coordinate[1]}"
        end
      end
    end
    @computer_board.place(computer_ship, coordinates)
  end

  def user_place_ship(user_ship)
    puts @user_board.render(true)

    print "Enter the squares one by one for the #{user_ship.name} (#{user_ship.length} spaces) using this format LN (L = letter, N = number): \n> "

    user_placement_valid = false

    until user_placement_valid
      user_coordinates = gets.chomp.split

      user_placement_valid = @user_board.valid_placement?(user_ship, user_coordinates)

      if !user_placement_valid
        print "Those are invalid coordinates. Please try again: \n> "
      end
    end

    @user_board.place(user_ship, user_coordinates)
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

  def display_boards_in_turn
    puts "COMPUTER BOARD".center(40, "=")
    puts @computer_board.render
    puts "PLAYER BOARD".center(40, "=")
    puts @user_board.render(true)
  end

  def player_turn
    print "Enter the coordinate for your shot:\n> "

    input_validated = false
    user_chosen_coord = " "

    until input_validated
      user_chosen_coord = gets.chomp

      if !@computer_board.valid_coordinate?(user_chosen_coord)
        print "Please enter a valid coordinate:\n> "
      elsif @computer_board.cells[user_chosen_coord].fired_upon?
        print "This coordinate has already been fired upon, enter a new coordinate:\n> "
      end

      if @computer_board.valid_coordinate?(user_chosen_coord) && !@computer_board.cells[user_chosen_coord].fired_upon?
        input_validated = true
      end
    end
    @computer_board.fire_on_coordinate(user_chosen_coord)

    shot_status = @computer_board.cells[user_chosen_coord].render
    if shot_status == "H"
      puts "Your shot on #{user_chosen_coord} was a hit."
    elsif shot_status == "M"
      puts "Your shot on #{user_chosen_coord} was a miss."
    elsif shot_status == "X"
      puts "Your shot on #{user_chosen_coord} sunk my #{@computer_board.cells[user_chosen_coord].ship.name}."
    end
  end

  def computer_turn
    valid_shot = false
    computer_shot = ""
    until valid_shot
      random_letter = ("A".ord + Random.rand(0..3)).chr
      random_number = Random.rand(1..4)
      computer_shot = "#{random_letter}#{random_number}"

      is_valid_coord = @user_board.valid_coordinate?(computer_shot)
      is_coord_already_fired_upon = @user_board.cells[computer_shot].fired_upon?
      if is_valid_coord && !is_coord_already_fired_upon
        valid_shot = true
      end
    end

    @user_board.fire_on_coordinate(computer_shot)

    shot_status = @user_board.cells[computer_shot].render
    if shot_status == "H"
      puts "My shot on #{computer_shot} was a hit."
    elsif shot_status == "M"
      puts "My shot on #{computer_shot} was a miss."
    elsif shot_status == "X"
      puts "My shot on #{computer_shot} sunk your #{@user_board.cells[computer_shot].ship.name}."
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

end
