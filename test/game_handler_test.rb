require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
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



    computer_cruiser = Ship.new("Cruiser", 3)
    computer_submarine = Ship.new("Submarine", 2)
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
    computer_cruiser = Ship.new("Cruiser", 3)
    computer_submarine = Ship.new("Submarine", 2)
    user_cruiser = Ship.new("Cruiser", 3)
    user_submarine = Ship.new("Submarine", 2)
    computer_ships = [computer_cruiser, computer_submarine]
    user_ships = [user_cruiser, user_submarine]

    @game.computer_board.place(computer_ships[0], ["A1", "A2", "A3"])
    @game.computer_board.place(computer_ships[1], ["C4", "D4"])

    @game.user_board.place(user_ships[0], ["A1", "B1", "C1"])
    @game.user_board.place(user_ships[1], ["C3", "C4"])

    @game.computer_board.fire_on_coordinate("C2")

    sample_input = ["E1", "D5", "C2", "A3"]

    expected_output1 = "Enter the coordinate for your shot:\n> " +
                      "Please enter a valid coordinate:\n> " +
                      "Please enter a valid coordinate:\n> " +
                      "This coordinate has already been fired upon, enter a new coordinate:\n> " +
                      "Your shot on A3 was a hit.\n"

    assert_output expected_output1 do
      simulate_standard_input sample_input do
        @game.player_turn
      end
    end

    assert_equal true, @game.computer_board.cells["A3"].fired_upon?

    # hit
    expected_output2 = "Enter the coordinate for your shot:\n> " +
                        "Your shot on A2 was a hit.\n"

    sample_input2 = ["A2"]
    assert_output expected_output2 do
      simulate_standard_input sample_input2 do
        @game.player_turn
      end
    end

    # miss
    expected_output3 = "Enter the coordinate for your shot:\n> " +
                        "Your shot on B1 was a miss.\n"

    sample_input3 = ["B1"]
    assert_output expected_output3 do
      simulate_standard_input sample_input3 do
        @game.player_turn
      end
    end

    # sink
    expected_output4 = "Enter the coordinate for your shot:\n> " +
                        "Your shot on A1 sunk my Cruiser.\n"
    sample_input4 = ["A1"]
    assert_output expected_output4 do
      simulate_standard_input sample_input4 do
        @game.player_turn
      end
    end

  end

  def test_computer_can_take_turn

    computer_cruiser = Ship.new("Cruiser", 3)
    computer_submarine = Ship.new("Submarine", 2)
    user_cruiser = Ship.new("Cruiser", 3)
    user_submarine = Ship.new("Submarine", 2)
    computer_ships = [computer_cruiser, computer_submarine]
    user_ships = [user_cruiser, user_submarine]

    @game.computer_board.place(computer_ships[0], ["A1", "A2", "A3"])
    @game.computer_board.place(computer_ships[1], ["C4", "D4"])

    @game.user_board.place(user_ships[0], ["A1", "B1", "C1"])
    @game.user_board.place(user_ships[1], ["C3", "C4"])

    @game.user_board.fire_on_coordinate("C3")

    pseudo_rand_values = [2, 3, 0, 1]
    Random.stub(:rand, proc { pseudo_rand_values.shift } ) do
      capture_io do
        @game.computer_turn
      end
    end

    assert_equal true, @game.user_board.cells["A1"].fired_upon?

    # hit
    expected_output2 = "My shot on B1 was a hit.\n"

    sample_input2 = [1, 1]
    assert_output expected_output2 do
      Random.stub(:rand, proc { sample_input2.shift } ) do
        @game.computer_turn
      end
    end

    # miss
    expected_output3 = "My shot on D3 was a miss.\n"

    sample_input3 = [3, 3]
    assert_output expected_output3 do
      Random.stub(:rand, proc { sample_input3.shift } ) do
        @game.computer_turn
      end
    end

    # sunk
    expected_output4 = "My shot on C1 sunk your Cruiser.\n"

    sample_input4 = [2, 1]
    assert_output expected_output4 do
      Random.stub(:rand, proc { sample_input4.shift } ) do
        @game.computer_turn
      end
    end
  end

  def test_take_turn
    computer_choices = [0, 1]
    player_input = ["B1"]

    Random.stub(:rand, proc { computer_choices.shift } ) do
      simulate_standard_input(player_input) do
        capture_io do
          @game.take_turn
        end
      end
    end
    assert_equal true, @game.user_board.cells["A1"].fired_upon?
    assert_equal true, @game.computer_board.cells["B1"].fired_upon?
  end
end
