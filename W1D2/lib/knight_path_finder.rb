require_relative '00_tree_node.rb'

class KnightPathFinder
    @@chess_board_size = 8
    attr_accessor :root_node
    #Start by creating an instance variable, self.root_node that stores 
    #the knight's initial position in an instance of your PolyTreeNode class.
    def initialize(pos = [0,0])
        @pos = pos
        @considered_positions = [pos]
        build_move_tree
    end

    #Returns array with all travel points e.g. find_path[3,3] starts from the
    #root [0,0] and gets there by traveling to 2,1 first. So the return is 
    #[[0,0],[2,1],[3,3]]
    def find_path(pos)
        
    end
    #KnightPathFinder#build_move_tree to build the move tree, 
    #beginning with self.root_node Call this method in initialize;
    # You will traverse the move tree whenever #find_path is called. 
    def build_move_tree
        self.root_node = PolyTreeNode.new(@pos)
        # HashMap[root_pos] = new_move_positions()
        nodes = [root_node]
        until nodes.empty?
            current_node = nodes.shift #Take first one, FIFO!

            current_pos = current_node.value
            current_new_move_positions = new_move_positions(current_pos)
            current_new_move_positions.each do |moved_to_pos|
                moved_to_node = PolyTreeNode.new(moved_to_pos)
                # is a position you can move to from the current_node so it
                # is a child node
                current_node.add_child(moved_to_node) 
                nodes << moved_to_node #Tag it onto the end
            end
        end
    end

    # Before we start #build_move_tree, you'll want to be able to find new 
    # positions you can move to from a given position. Write a class method 
    # KnightPathFinder::valid_moves(pos). There are up to eight possible moves.
    # You'll also want to avoid repeating positions in the move tree. 
    # For instance, we don't want to infinitely explore moving betweeen the 
    # same two positions. Add an instance variable, @considered_positions
    # to keep track of the positions you have considered
    # initialize it to the array containing just the starting pos.
    def self.valid_moves(pos)
        #up to eight possible moves
        v, h = pos
        positions = {
            :left_left_up        => [v-1, h-1-1],    
            :up_up_left          => [v-1-1, h-1],

            :up_up_right         => [v-1-1, h+1],
            :right_right_up      => [v-1, h+1+1],  

            :right_right_down    => [v+1, h+1+1],        
            :down_down_right     => [v+1+1, h+1],    

            :down_down_left      => [v+1+1, h-1],    
            :left_left_down      => [v+1, h-1-1]    
        }

        valid_positions = []
        valid_positions = positions.select{ 
            |k, val| KnightPathFinder::pos_within_bounds?(val) 
        }.values
    end

    def self.pos_within_bounds?(pos)
        v, h = pos
        valid_v_h = (0...@@chess_board_size).to_a
        valid_v_h.include?(v) && valid_v_h.include?(h)
    end

    # Write an instance method #new_move_positions(pos); this should call the 
    # ::valid_moves class method, but filter out any positions that are already 
    # in @considered_positions. 
    # It should then add the remaining new positions to @considered_positions 
    # and return these new positions
    def new_move_positions(pos)
        valid_moves = KnightPathFinder::valid_moves(pos)
        new_moves = valid_moves - @considered_positions
        @considered_positions += new_moves
        new_moves
    end

end

kpf = KnightPathFinder.new()
p KnightPathFinder::valid_moves([0,0])