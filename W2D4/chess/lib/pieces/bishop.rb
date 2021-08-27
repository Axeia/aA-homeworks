require_relative 'slideable'

class Bishop < Piece
    include Slideable

    def initialize(color, board, pos)
        super
        @symbol = '♝'
    end

    def move_dirs
        [:diagonal]
    end
end