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

        puts "playing game\n\n"
      end
    end
  end

end
