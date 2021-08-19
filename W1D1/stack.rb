  class Stack
    def initialize
      # create ivar to store stack here!
      @stack = []
    end

    def push(el)
      # adds an element to the stack
      @stack << el
    end

    def pop
      # removes one element from the stack
      @stack.pop
    end

    def peek
      # returns, but doesn't remove, the top element in the stack
      @stack[-1]
    end
  end

stack = Stack.new()
stack.push(5)
stack.push(4)
stack.push(3)
stack.push(2)
stack.push(1)

# LIFO check
p stack.peek #expect 1
p stack.pop #expect 1
p stack.pop #expect 2

