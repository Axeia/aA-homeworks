require_relative 'slideable'

class Queen < Piece
    include Slideable

    def initialize(color, board, pos)
        super
        @symbol = '♛'
    end

    def move_dirs
        [:diagonal, :vertical, :horizontal]
    end
end