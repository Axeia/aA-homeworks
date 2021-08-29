module Stepable
    def move_diffs
        
    end

    def moves 
        valid_positions = []
        valid_positions = move_diffs.select do |k, val| 
            Board::valid_pos?(val) 
        end
        valid_positions = valid_positions.values
        valid_positions.select{ 
            |p| @board.empty?(p) || @board.opposing_piece?(self, p) 
        }
    end
end