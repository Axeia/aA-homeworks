require_relative 'piece'

class King < Piece
    def initialize(color, board, pos)
        super
        @symbol = '♚'
    end

    def valid_moves
        #up to eight possible moves
        v, h = @pos
        positions = {
            :top_left       => [v-1, h-1],    
            :top            => [v-1, h],
            :top_right      => [v-1, h+1],

            :left           => [v, h-1],
            :right          => [v, h+1],  

            :bottom_left    => [v+1, h-1],        
            :bottom         => [v+1, h],    
            :bottom_right   => [v+1, h+1]
        }

        valid_positions = []
        valid_positions = positions.select{ |k, val| Board::valid_pos?(val) }\
        .values
        valid_positions.select{ 
            |p| @board.empty?(p) || @board.opposing_piece?(self, p) 
        }
    end
end