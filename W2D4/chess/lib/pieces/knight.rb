require_relative 'piece'

class Knight < Piece
    def initialize(color, board, pos)
        super
        @symbol = '♞'
    end

    def valid_moves
        #up to eight possible moves
        v, h = @pos
        positions = {
            :left_left_up        => [v-1, h-1-1],    
            :up_up_left          => [v-1-1, h-1],

            :up_up_right         => [v-1-1, h+1],
            :right_right_up      => [v-1, h+1+1],  

            :right_right_down    => [v+1, h+1+1],        
            :down_down_right     => [v+1+1, h+1],    

            :down_down_left      => [v+1+1, h-1],    
            :left_left_down      => [v+1, h-1-1]    
        }

        valid_positions = []
        valid_positions = positions.select do |k, val| 
            Board::valid_pos?(val) 
        end
        valid_positions = valid_positions.values
        valid_positions.select{ 
            |p| @board.empty?(p) || @board.opposing_piece?(self, p) 
        }
    end
end