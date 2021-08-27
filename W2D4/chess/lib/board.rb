require_relative 'pieces/piece'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/null_piece'
require 'colorize'

class Board
    class NoPieceAtPosError < StandardError; end
    class InvalidEndPosError < StandardError; end
    class InvalidPosError < StandardError; end

    def initialize
        @rows = Array.new(8){ Array.new(8) }
        set_up_board
    end

    def set_up_board
        clear_board
        set_up_pawns
        set_up_backline(0, :black)
        set_up_backline(7, :white)
    end

    def [](pos)
        raise InvalidPosError.new("Invalid position (#{pos.join(',')})")\
        unless Board::valid_pos?(pos)

        v, h = pos
        @rows[v][h]
    end

    def []=(pos, piece)        
        raise InvalidPosError.new("Invalid position (#{pos.join(',')})")\
        unless valid_pos?(pos)

        v, h = pos
        @rows[v][h] = piece
    end

    def self.valid_pos?(pos)
        v, h = pos
        v.between?(0,7) && h.between?(0,7)
    end

    def empty?(pos)
        self.[](pos).instance_of?(NullPiece)
    end

    def move_piece(start_pos, end_pos)
        start_v, start_h = start_pos
        end_v, end_h     = end_pos
        
        piece = piece(start_pos) #.dup? # May throw NoPieceAtPosError

        raise InvalidEndPosError "Cannot move piece #{piece.class.name} to "\
        "#{end_pos.join('n')}"\
        unless piece.move_into_check?(end_pos)

        # No errors - go ahead!
        @rows[start_v][start_h] = NullPiece.instance
        @rows[end_v][end_h] = piece
        piece.pos = end_pos
    end

    def piece(pos)
        v, h = pos
        piece = @rows[v][h]
        
        raise NoPieceAtPosError "No piece found at pos #{pos.join(',')}}"\
        unless piece.is_a?(Piece)

        piece
    end

    def render
        output = ''
        
        @rows.each.with_index do |row, i|
            output += (i + 1).to_s + ' '
            row.each.with_index do |piece, j|
                field = ''
                if piece == nil
                    field = '    '
                else
                    field = ' ' + piece.to_s + '  '
                end
                field = field.on_red if (i + j) % 2 == 0
                output += field
            end
            output += "\n"
        end

        output += '   ' + ('a'..'h').to_a.join('   ') + "\n"
        output
    end

    def opposing_piece?(piece, pos)
        other_piece = self.[](pos)
        !piece.same_side?(other_piece)
    end

    private 

    def clear_board
        (0..7).each{ |v| (0..7).each{ |h| @rows[v][h] = NullPiece.instance } } 
    end

    def set_up_pawns
        (0..7).to_a.each{ |h| @rows[1][h] = Pawn.new(:black, self, [1, h]) }
        (0..7).to_a.each{ |h| @rows[6][h] = Pawn.new(:white, self, [1, h]) }
    end

    def set_up_backline(line, color)
        @rows[line][0] = Rook.new(color, self, [line, 0])
        @rows[line][7] = Rook.new(color, self, [line, 7])
    end
end

if __FILE__ == $0
    board = Board.new
    # p board.piece([3,3]) # Expect NoPieceAtPosError
    # p board.piece([1,1]).to_s # Expect to execute without error
    # p board.move_piece([1,1], [4,4]) #Expect to have moved the piece 
    # p board.piece([0,0]) # Should throw NoPieceAtPosError after above line
    # p board.piece([4,4]) # Should be the same piece as the first printed line
    board.move_piece([0,0],[3,1])
    puts board.render
    rook = board[[3,1]]
    p rook.slide_horizontal(1)
    p rook.slide_horizontal(-1)
    p rook.horizontal_moves
    p rook.slide_vertical(1)
    p rook.slide_vertical(-1)
    p rook.vertical_moves
    p rook.moves
    p rook.same_side?(board[[6,1]])
    # p rook.moves
end
