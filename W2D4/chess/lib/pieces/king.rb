require_relative 'piece'
require_relative 'stepable'

class King < Piece
    include Stepable

    def initialize(color, board, pos)
        super
        @symbol = '♚'
    end

    def move_diffs
        v, h = @pos
        {
            :top_left       => [v-1, h-1],    
            :top            => [v-1, h],
            :top_right      => [v-1, h+1],

            :left           => [v, h-1],
            :right          => [v, h+1],  

            :bottom_left    => [v+1, h-1],        
            :bottom         => [v+1, h],    
            :bottom_right   => [v+1, h+1]
        }
    end
end