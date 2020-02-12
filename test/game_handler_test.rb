require "minitest/autorun"
require "minitest/pride"
require "./lib/game_handler"
require "./lib/ship"

class GameHandlerTest < Minitest::Test

  def simulate_standard_input(*inputs, &block)
    io = StringIO.new
    inputs.flatten.each { |str| io.puts(str) }
    io.rewind

    actual_stdin, $stdin = $stdin, io
    yield
  ensure
    $stdin = actual_stdin
  end

  def setup
    @game = GameHandler.new
  end

  def test_can_access_boards
    assert_instance_of Board, @game.computer_board
    assert_instance_of Board, @game.user_board
  end

  def test_turn_can_display_board
    expected_fresh_boards = "=============COMPUTER BOARD=============\n" +
                            "  1 2 3 4 \n" +
                            "A . . . . \n" +
                            "B . . . . \n" +
                            "C . . . . \n" +
                            "D . . . . \n" +
                            "==============PLAYER BOARD==============\n" +
                            "  1 2 3 4 \n" +
                            "A . . . . \n" +
                            "B . . . . \n" +
                            "C . . . . \n" +
                            "D . . . . \n"

    assert_output expected_fresh_boards do
        @game.display_boards_in_turn
    end



    computer_cruiser = Ship.new("Computer Cruiser", 3)
    computer_submarine = Ship.new("Computer Submarine", 2)
    user_cruiser = Ship.new("Cruiser", 3)
    user_submarine = Ship.new("Submarine", 2)
    computer_ships = [computer_cruiser, computer_submarine]
    user_ships = [user_cruiser, user_submarine]

    @game.computer_board.place(computer_ships[0], ["A1", "A2", "A3"])
    @game.computer_board.place(computer_ships[1], ["C4", "D4"])

    @game.user_board.place(user_ships[0], ["A1", "B1", "C1"])
    @game.user_board.place(user_ships[1], ["C3", "C4"])

    @game.user_board.fire_on_coordinate("C1")
    @game.user_board.fire_on_coordinate("B2")
    @game.user_board.fire_on_coordinate("B3")
    @game.user_board.fire_on_coordinate("A3")

    @game.computer_board.fire_on_coordinate("A1")
    @game.computer_board.fire_on_coordinate("A2")
    @game.computer_board.fire_on_coordinate("A3")
    @game.computer_board.fire_on_coordinate("C2")


    expected_mid_game_board = "=============COMPUTER BOARD=============\n" +
                              "  1 2 3 4 \n" +
                              "A X X X . \n" +
                              "B . . . . \n" +
                              "C . M . . \n" +
                              "D . . . . \n" +
                              "==============PLAYER BOARD==============\n" +
                              "  1 2 3 4 \n" +
                              "A S . M . \n" +
                              "B S M M . \n" +
                              "C H . S S \n" +
                              "D . . . . \n"



    assert_output expected_mid_game_board do
      @game.display_boards_in_turn
    end
  end

  def test_player_can_shoot
    # skip
    # this tests the @game.player_turn method (which needs to be created)

    computer_cruiser = Ship.new("Computer Cruiser", 3)
    computer_submarine = Ship.new("Computer Submarine", 2)
    user_cruiser = Ship.new("Cruiser", 3)
    user_submarine = Ship.new("Submarine", 2)
    computer_ships = [computer_cruiser, computer_submarine]
    user_ships = [user_cruiser, user_submarine]

    @game.computer_board.place(computer_ships[0], ["A1", "A2", "A3"])
    @game.computer_board.place(computer_ships[1], ["C4", "D4"])

    @game.user_board.place(user_ships[0], ["A1", "B1", "C1"])
    @game.user_board.place(user_ships[1], ["C3", "C4"])

    @game.computer_board.fire_on_coordinate("C2")

    sample_input = ["E1", "D5", "C2", "A4"]

    expected_output = "Enter the coordinate for your shot:\n> " +
                      # User inputs stupid coord
                      "Please enter a valid coordinate:\n> " +
                      # User continues to baffle society
                      "Please enter a valid coordinate:\n> " +
                      # User manages to press the right keys on their keyboard
                      # yet still struggles with short term memory loss
                      "This coordinate has already been fired upon, enter a new coordinate:\n> "
                      # User finally pools their 3 brain cells together and enters a valid coord

    assert_output expected_output do
      simulate_standard_input sample_input do
        @game.player_turn
      end
    end

    assert_equal true, @game.computer_board.cells["A4"].fired_upon?
  end

end
