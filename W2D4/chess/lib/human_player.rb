require_relative 'player'

class HumanPlayer < Player
    attr_reader :name

    class InputError < StandardError; end
    class NullPieceSelectedError < InputError; end
    class WrongColorError < InputError; end
    class PieceHasNoMovesError < InputError; end
    class SamePosError < InputError; end
    class InvalidMoveError < InputError; end

    def initialize(color, display)
        super(color, display)
    end

    def make_move
        # Move cursor to players side of the board (just select their king)
        @display.cursor.cursor_pos = @display.board.find_king(@color).pos

        piece_pos   = nil
        destination = nil

        until piece_pos && destination
            @display.render

            if piece_pos
                check_for_nullpiece_error(piece_pos)
                check_for_wrong_color_error(piece_pos)
                check_for_no_possible_moves_error(piece_pos)

                puts "#{@color.capitalize}'s turn. "\
                "Destination for #{Board::chess_index(piece_pos)}?"
                cursor_input = @display.cursor.get_input
                destination = cursor_input if cursor_input != nil

                # display.reset! if destination
            else
                puts "#{@color.capitalize}'s turn. Select piece"
                cursor_input = @display.cursor.get_input
                piece_pos = cursor_input if cursor_input != nil

                # display.reset! if piece
            end
        end
        
        check_for_same_pos(piece_pos, destination)
        check_for_valid_destination(piece_pos, destination)

        return [piece_pos, destination]
    end

    def check_for_nullpiece_error(piece_pos)
        if @display.board[piece_pos].instance_of?(NullPiece)
            raise NullPieceSelectedError.new(
                "Sorry player #{@color}, you have to actually select a "\
                "piece. Not an empty field."
            )
        end
    end

    def check_for_wrong_color_error(piece_pos)
        unless @display.board[piece_pos].color == @color
            opponent_color = @color == :white ? :black : :white
            raise WrongColorError.new(
                "Sorry player #{color}, you're not allowed to play "\
                "with #{opponent_color}'s pieces"
            )
        end
    end

    def check_for_no_possible_moves_error(piece_pos)
        if @display.board[piece_pos].moves.empty?
            piece_name = @display.board[piece_pos].class.name
            raise PieceHasNoMovesError.new(
                "Sorry player #{@color}, your #{piece_name} at "\
                "#{Board::chess_index(piece_pos)} cannot move anywhere."\
                " Select another piece."
            )
        end
    end

    def check_for_same_pos(piece_pos, destination)
        if piece_pos == destination
            raise SamePosError.new(
                "Undoing selection."
            )
        end
    end

    def check_for_valid_destination(piece_pos, destination)
        piece = @display.board[piece_pos]
        unless piece.moves.include?(destination)
            raise InvalidMoveError.new(
                "Sorry player #{@color}, #{piece.class.name} "\
                "#{Board::chess_index(piece_pos)} is not allowed to move to "\
                "#{Board::chess_index(destination)}."
            )
        end
    end
end