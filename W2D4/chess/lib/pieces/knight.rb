require_relative 'piece'
require_relative 'stepable'

class Knight < Piece
    include Stepable

    def initialize(color, board, pos)
        super
        @symbol = '♞'
    end

    def move_diffs
        v, h = @pos
        {
            :left_left_up        => [v-1, h-1-1],    
            :up_up_left          => [v-1-1, h-1],

            :up_up_right         => [v-1-1, h+1],
            :right_right_up      => [v-1, h+1+1],  

            :right_right_down    => [v+1, h+1+1],        
            :down_down_right     => [v+1+1, h+1],    

            :down_down_left      => [v+1+1, h-1],    
            :left_left_down      => [v+1, h-1-1]    
        }
    end
end