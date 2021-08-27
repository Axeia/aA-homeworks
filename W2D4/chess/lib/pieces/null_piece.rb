require 'singleton'

class NullPiece < Piece
    include Singleton

    def initialize
        @symbol = ' '
        @color = :none
    end

    def symbol
        @symbol
    end

    def to_s
        ' '
    end
end