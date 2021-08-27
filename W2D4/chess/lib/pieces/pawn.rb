require_relative 'piece'

class Pawn < Piece
    def initialize(color, board, pos)
        super
        @symbol = '♟'
        @initial_pos = pos.dup
    end
    
    def at_start_row?

    end
    
    def valid_moves
        v, h = @pos
        valid_moves = []
        if at_start_row?
            valid_moves << [v + (forward * 2), h]
        else
            valid_moves << [v + forward, h] 
        end

        front_left  = [v + forward, h+1]
        valid_moves << front_left if @board.opposing_piece?(self, front_left)

        front_right = [v + forward, h-1]
        valid_moves << front_right if @board.opposing_piece?(self, front_right)

        valid_moves.select{ |m| Board::valid_pos?(m) }
    end

    def forward
        @color == :black ? 1 : -1
    end

    def at_start_row?
        @pos == @initial_pos
    end
end