require_relative 'piece'

class Pawn < Piece
    def initialize(color, board, pos)
        super
        @symbol = '♟'
        @initial_pos = pos.dup
    end
    
    def at_start_row?

    end
    
    def moves
        v, h = @pos
        valid_moves = []

        must_be_empty = [[v + forward, h]] 
        must_be_empty << [v + (forward * 2), h] if at_start_row?
        valid_moves += must_be_empty.select{ 
            |pos| Board::valid_pos?(pos) && @board[pos].empty? 
        }
        
        must_be_opponent = [
            [v + forward, h-1], # front left
            [v + forward, h+1], # front right
        ]
        valid_moves += must_be_opponent.select{ 
            |pos| Board::valid_pos?(pos) && @board.opposing_piece?(self, pos) 
        }

        valid_moves
    end

    def forward
        @color == :black ? 1 : -1
    end

    def at_start_row?
        @pos == @initial_pos
    end
end