module Slideable
    def moves()
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
        slide_vertical(-1) + slide_vertical(1)
    end

    def slide_vertical(direction)
        slide(direction, 0)
    end

    def horizontal_moves
        slide_horizontal(-1) + slide_horizontal(1)
    end

    def slide_horizontal(direction)
        slide(0, direction)
    end

    def diagonal_moves 
        # slide(-1, -1, )
    end

    def slide(v_dir, h_dir)
        moves = []
        v, h = @pos

        while h >= 1 && h < 7
            h += h_dir
            v += v_dir
            new_pos = [v, h]
            if @board.empty?(new_pos)
                moves << new_pos
            elsif @board.opposing_piece?(self, new_pos)                
                moves << new_pos
                return moves
            else # own piece
                return moves
            end
        end

        moves
    end
end