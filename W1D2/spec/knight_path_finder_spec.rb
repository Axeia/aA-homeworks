require 'rspec'
require 'knight_path_finder'

describe "KnightPathFinder::valid_moves" do
    it "description" do
        #Very Top-left position can only move to the bottom and right
        expect(KnightPathFinder::valid_moves([0,0])).to eq ([[1,2], [2,1]]) 
        #Very Top-Right position can only move to the bottom and left
        expect(KnightPathFinder::valid_moves([0,7])).to eq ([[2,6], [1,5]]) 
        
        # Position near the middle should make all positions playable
        # Modelled after https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/pdrpnht/phpVuLl4W.png
        four_four_positions = [
                [2,3],   [2,5],
            [3,2],           [3,6],

            [5,2],           [5,6],
                [6,3],   [6,5]
        ]
        expect(KnightPathFinder::valid_moves([4,4]).sort).to eq (
            four_four_positions.sort
        ) 

        #Very bottom-left position can only move to the front and right        
        expect(KnightPathFinder::valid_moves([7,0])).to eq ([[5,1], [6,2]]) 
        #Very bottom-left position can only move to the front and right        
        expect(KnightPathFinder::valid_moves([7,0])).to eq ([[5,1], [6,2]]) 
    end
end

describe "KnightPathFinder#new_move_positions" do
    it "Finds positions that hadn't previously been found yet" do
        four_four_positions = [
                [2,3],   [2,5],
            [3,2],           [3,6],

            [5,2],           [5,6],
                [6,3],   [6,5]
        ]
        kpf = KnightPathFinder.new()
        #First .new_move_positions call should fill kpf#@considered_positions
        #That is however not available but it's the same as the return value
        #which we do test below.
        expect(kpf.new_move_positions([4,4])).to eq(
            KnightPathFinder::valid_moves([4,4])
        )

        #Second time calling it on the same location should yield no new results
        #as everything was in @considered_positions
        expect(kpf.new_move_positions([4,4])).to eq([])

        #Calling it on a position which would yield overlapping results
        #should filter those overlaps ([[3,2], [5,2]]) out.
        expect(kpf.new_move_positions([4,0])).to eq([[2,1], [6,1]])
    end
end

describe "KnightPathFinder#build_move_tree" do
    it "Should set @root_node to a PolyTreeNode instance with many children" do        
        kpf = KnightPathFinder.new()
        expect(kpf.PolyTreeNode).to be_a(PolyTreeNode)
        expect(kpf.children.empty?).to eq(false)
        expect(kpf.children[]).to be_a(PolyTreeNode)
        kpf.children.first.value.to eq([[KnightPathFinder::valid_moves([0,0])]])
    end
end

describe "KnightPathFinder#find_path" do
    it "Finds a path on the board for a knight" do
        kpf = KnightPathFinder.new()
        path = kpf.find_path([7,7])
        expect(path).to be_a(Array)
        expect(path.length).to be < 15
        expect(path.length).to be > 5
    end
end