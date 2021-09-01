class Piece
    attr_reader :color, :symbol, :pos

    def initialize(color, board, pos)
        @color = color
        @board = board 
        @pos   = pos
        @symbol = 'X'

        board.add_piece(self, pos)
    end

    def to_s
        return symbol.black if color == :black
        return symbol.white if color == :white
    end

    def empty?
        self.instance_of?(NullPiece)
    end

    def moves
        []
    end

    def valid_moves
        moves.reject{ |end_pos| move_into_check?(end_pos) }
    end

    def same_side?(piece)
        !(color == :none || piece.color == :none) && self.color == piece.color        
    end

    def pos=(val)
        @pos = val
    end

    #private
    def move_into_check?(end_pos)
        dup_board = @board.dup
        dup_piece = dup_board[@pos]
        dup_board.move_piece!(dup_piece.pos, end_pos)
        dup_board.in_check?(dup_piece.color)
    end
end