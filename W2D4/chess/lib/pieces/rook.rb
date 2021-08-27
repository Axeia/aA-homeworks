require_relative 'slideable'

class Rook < Piece
    #Classes that include the module Slideable (Bishop/Rook/Queen) 
    # will need to implement a method #move_dirs, which #moves will use.
    include Slideable

    def initialize(color, board, pos)
        super
        @symbol = '♜'
    end

    def move_dirs
        [:vertical, :horizontal]
    end
end