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
        valid_moves = [[v + forward, h]]
        valid_moves << [v + (forward * 2), h] if at_start_row?

        positions = { 
            front_left:  [v + forward, h+1], 
            front_right: [v + forward, h-1] 
        }
        valid_moves += positions.select{ 
            |k, v| Board::valid_pos?(v) && @board.opposing_piece?(self, v)
        }.values

        valid_moves.select{ |m| Board::valid_pos?(m) }
    end

    def forward
        @color == :black ? 1 : -1
    end

    def at_start_row?
        @pos == @initial_pos
    end
end