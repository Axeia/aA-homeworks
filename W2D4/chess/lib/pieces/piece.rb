class Piece
    attr_reader :color, :symbol

    def initialize(color, board, pos)
        @color = color
        @board = board 
        @pos   = pos
        @symbol = 'X'
    end

    def to_s
        return symbol.yellow if color == :black
        return symbol.light_green if color == :white
    end

    def empty?

    end

    def valid_moves

    end

    def same_side?(piece)
        color != :none && self.color == piece.color        
    end

    def pos=(val)
        @pos = val
    end

    #private
    def move_into_check?(end_pos)
        return true
    end
end