module Searchable
    def dfs(target = nil, &prc)
        raise "Need a proc or a target" if [target, prc].none?
        prc ||= Proc.new{ |node| node.value == target }

        return self if prc.call(self)

        children.each do |child| 
            result = child.dfs(&prc)
            return result unless result.nil?
        end
        
        nil
    end

    def bfs(target = nil, &prc)
        raise "Need a proc or target" if [target, prc].none?
        prc ||= Proc.new { |node| node.value == target }
        nodes = [self]

        until nodes.empty?
            node = nodes.shift
            return node if prc.call(node)
            nodes = nodes + node.children
        end

        nil
    end

    def count
        1 + children.map{ |child| child.count }.to_a.sum
    end
end

class PolyTreeNode
    include Searchable
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