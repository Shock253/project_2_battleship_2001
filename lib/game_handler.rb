require "./lib/board"
require "./lib/ship"

class GameHandler

  def initialize
    @user_board = Board.new
    @computer_board = Board.new

    @user_ships = []
    @computer_ships = []
  end


  def setup_game

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
        puts "Please enter a valid response\n\n"

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
