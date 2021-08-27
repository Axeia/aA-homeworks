module Slideable
    def valid_moves
        possible_moves = []

        move_dirs.each do |move_dir|
            case move_dir
            when :vertical
                possible_moves += vertical_moves
            when :horizontal
                possible_moves += horizontal_moves
            when :diagonal
                possible_moves += diagonal_moves
            end
        end
        possible_moves
    end

    def vertical_moves 
        slide(-1, 0) + slide(1, 0)
    end

    def horizontal_moves
        slide(0, -1) + slide(0, 1)
    end

    def diagonal_moves 
        #top-left       top-right      bottom-left    bottom-right
        slide(-1, -1) + slide(-1, 1) + slide(1, -1) + slide(1, 1)
    end

    def slide(v_dir, h_dir)
        moves = []
        v, h = @pos

        while Board::valid_pos?([v + v_dir, h + h_dir])
            h += h_dir
            v += v_dir
            new_pos = [v, h]
            #Empty spaces are always fair game
            if @board.empty?(new_pos)
                p 'hai'
                moves << new_pos
            # Taking an opposing piece is a valid move
            elsif @board.opposing_piece?(self, new_pos)                
                moves << new_pos
                return moves
            # Within bounds, not empty and not opposing = own piece.
            else # own piece
                return moves
            end
        end

        moves
    end
end