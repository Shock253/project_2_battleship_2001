require "./lib/game_handler"

game = GameHandler.new
game.computer_hide_ships
puts game.computer_board.render(true)
