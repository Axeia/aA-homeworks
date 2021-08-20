class PolyTreeNode
    attr_accessor :value
    attr_reader :parent

    def initialize(value)
        @value = value
        @children = []
        @parent = nil
    end

    def children
        @children.dup
    end

    def parent=(node)
        return if @parent == node

        @parent._children.delete(self) if @parent
        @parent = node
        @parent._children << self unless @parent.nil?
    end

    def add_child(node)
        node.parent = self
    end

    def remove_child(node)
        node_value = 'nil'
        node_value = node.value unless node == nil

        raise PolyTreeNode::NodeIsNotChild, \
        "The given node with value: #{node_value} is not a child of this node "\
        "with value #{@value}"\
        if node != nil && !children.include?(node)

        node.parent = nil
    end

    protected
    def _children
        @children
    end
end
