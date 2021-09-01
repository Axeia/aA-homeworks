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
            piece_pos, destination = [nil, nil] 
            begin 
                piece_pos, destination = @current_player.make_move
                
            rescue HumanPlayer::InputError => e                
                @display.cursor.selected = false
                @display.add_message(e.message)
                redo
            end
            @display.board.move_piece(
                @current_player.color, 
                piece_pos, 
                destination
            )
            piece_name = @board[piece_pos].class.name
            @display.clear_messages
            @display.add_message (
                @current_player.color.to_s.capitalize + " moved #{piece_name} "\
                "#{Board::chess_index(piece_pos)} "\
                "to #{Board::chess_index(destination)}."
            )

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