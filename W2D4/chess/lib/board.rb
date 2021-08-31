require_relative 'pieces/piece'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/null_piece'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/knight'
require_relative 'pieces/king'
require_relative 'pieces/null_piece'
require 'colorize'

class Board
    class NoPieceAtPosError < StandardError; end
    class InvalidEndPosError < StandardError; end
    class InvalidPosError < StandardError; end
    class IlligalMoveForPieceError < StandardError; end

    attr_reader :rows

    def initialize(set_things_up = true)
        @rows = Array.new(8){ Array.new(8) { NullPiece.instance } }
        set_up_board if set_things_up
    end

    def set_up_board
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
        unless Board::valid_pos?(pos)

        v, h = pos
        @rows[v][h] = piece
    end

    def add_piece(piece, pos)
        self[pos] = piece
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

        raise InvalidEndPosError.new(
            "Cannot move piece #{piece.class.name} from #{start_pos.join(',')}"\
            " to #{end_pos.join(',')}"
        ) unless piece.move_into_check?(end_pos)

        # No errors - go ahead!
        @rows[start_v][start_h] = NullPiece.instance
        @rows[end_v][end_h] = piece
        piece.pos = end_pos
    end
    
    #Only really to be called by Piece#move_into_check
    def move_piece!(start_pos, end_pos)
        piece = piece(start_pos)

        raise IlligalMoveForPieceError.new(
            "Hold on there, a #{piece.class.name} cannot move like that."
        ) unless piece.moves.include?(end_pos)

        self[end_pos] = piece
        self[start_pos] = NullPiece.instance
        piece.pos = end_pos
        nil
    end
    
    def move_piece_str(str)
        str_moves = str.split(', ')
        from = str_to_array_pos(str_moves[0])
        to   = str_to_array_pos(str_moves[1])
        move_piece!(from, to)
    end

    def str_to_array_pos(str)
        letter, number = str.split('')
        
        l2i = { 'a'=>0, 'b'=>1, 'c'=>2, 'd'=>3, 'e'=>4, 'f'=>5, 'g'=>6, 'h'=>7 }
        n2i = { '8'=>0, '7'=>1, '6'=>2, '5'=>3, '4'=>4, '3'=>5, '2'=>6, '1'=>7 }
        [n2i[number], l2i[letter]]
    end


    def piece(pos)
        v, h = pos
        piece = @rows[v][h]
        
        raise NoPieceAtPosError "No piece found at pos #{pos.join(',')}}"\
        unless piece.is_a?(Piece)

        piece
    end

    def render(piece = nil)
        output = ''
        highlighted_squares = piece.moves
        
        @rows.each.with_index do |row, i|
            output += (i + 1).to_s + ' '
            row.each.with_index do |piece, j|
                field = ''
                if piece == nil
                    field = '    '
                else
                    field = ' ' + piece.to_s + '  '
                end

                if highlighted_squares.include?([i,j])
                    if (i + j) % 2 == 0 
                        field = field.on_light_magenta
                    else
                        field = field.on_magenta
                    end
                else
                    field = field.on_red if (i + j) % 2 == 0 
                end
                output += field
            end
            output += "\n"
        end

        output += '   ' + ('a'..'h').to_a.join('   ') + "\n"
        output
    end

    def opposing_piece?(piece, pos)
        other_piece = self.[](pos)
        return false if other_piece.instance_of?(NullPiece)
        !piece.same_side?(other_piece)
    end

    def pieces(color = nil)
        if color != nil
            rows.flatten.select{ |piece| !piece.empty? && piece.color == color }
        else
            rows.flatten.select{ |piece| !piece.empty? }
        end
    end

    def find_king(color)
        pieces(color).find{ |possible_king| possible_king.instance_of?(King) }
    end

    def in_check?(color)
        king = find_king(color)
        opposite_color = color == :white ? :black : :white
        in_check = pieces(opposite_color).any? do |piece|
            piece.moves.include?(king.pos)
        end
        in_check
    end

    def checkmate?(color)
        return pieces(color).all?{ |p| p.valid_moves.empty? }\
        if in_check?(color)
        
        false
    end

    def dup
        #Re-creates everything using .new so nothing is shared but actually
        #duplicated.
        dup_board = Board.new(false) #Clear board, all NullPiece's
        pieces.each{ |p| p.class.new(p.color, dup_board, p.pos.dup) }
        dup_board
    end

    def simple_render
        output = ""
        @rows.each do |col|
            col.each do |piece|
                output += ' ' + piece.to_s + '  '
            end
            output += "\n"
        end
        puts output
    end

    private 

    def set_up_pawns
        (0..7).to_a.each{ |h| @rows[1][h] = Pawn.new(:black, self, [1, h]) }
        (0..7).to_a.each{ |h| @rows[6][h] = Pawn.new(:white, self, [6, h]) }
    end

    def set_up_backline(line, color)
        row = @rows[line]
        row[0] = Rook.new(color, self, [line, 0])
        row[7] = Rook.new(color, self, [line, 7])

        row[1] = Knight.new(color, self, [line, 1])
        row[6] = Knight.new(color, self, [line, 6])

        row[2] = Bishop.new(color, self, [line, 2])
        row[5] = Bishop.new(color, self, [line, 5])        
        
        row[3] = Queen.new(color, self, [line, 3])
        row[4] = King.new(color, self, [line, 4])
    end
end