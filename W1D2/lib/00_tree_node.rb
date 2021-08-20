class PolyTreeNode
    attr_reader :children, :value, :parent

    def initialize(value)
        @value = value
        @children = []
        @parent = nil
    end
end