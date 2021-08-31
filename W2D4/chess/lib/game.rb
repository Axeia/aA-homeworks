require_relative 'board'
require_relative 'display'
require_relative 'human_player'

class Game
    def initialize()
        @board = Board.new()
        @display = Display.new(@board)

        @player_white = HumanPlayer.new(:white, @display)
        @player_black = HumanPlayer.new(:black, @display)

        @board = Board.new()
        @current_player = @player_white
    end

    def swap_turn!
        @current_player = 
            @current_player == @player_white ? @player_black : @player_white
    end

    def play
        until won? #game.won
            @current_player.make_move
            # @board[[0,4]] = NullPiece.instance
            swap_turn!
        end

        winner = won?(:white) ? :white : :black
        puts "Congratulations #{winner}! You have won the game."
    end

    def won?(color = nil)
        white_king = @board.find_king(:white)
        return white_king != nil && white_king.instance_of?(King)\
        if color == :white

        black_king = @board.find_king(:black)
        return black_king != nil && black_king.instance_of?(King)\
        if color == :black

        !(@board.find_king(:white) && @board.find_king(:black))
    end
end

if __FILE__ == $0
    game = Game.new()
    game.play
    # board = Board.new()
    # display = Display.new(board)  
end