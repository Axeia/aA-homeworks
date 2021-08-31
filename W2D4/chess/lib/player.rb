class Player
    attr_reader :name

    def initialize(color, display)
        @color = color
        @display = display
    end

    def make_move
        #Should return an array with 2 positions. 
        # pos 1 = piece to move
        # pos 2 = destination
        return [[1,1], [3,1]]
    end
end