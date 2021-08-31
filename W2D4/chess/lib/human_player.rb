require_relative 'player'

class HumanPlayer < Player
    attr_reader :name

    def initialize(color, display)
        super(color, display)
    end

    def make_move
        # ask_for_pos 
        puts "Player #{@color}'s turn"
        gets
        return [[1,1], [3,1]]
    end
end