class Queue
    def initialize()
        @queue = []
    end

    def enqueue(el)
        @queue = [el] + @queue
    end

    def dequeue
        @queue.pop
    end

    def peek
        @queue[-1]
    end
end

video_card_buyers = Queue.new
video_card_buyers.enqueue("Jan")
video_card_buyers.enqueue("James")
video_card_buyers.enqueue("Janine")
video_card_buyers.enqueue("Janice")
video_card_buyers.enqueue("Jessica")

# First in, first out
p video_card_buyers.dequeue #expect Jan, he was the first to arrive
p video_card_buyers.dequeue #expect James, he was the second to arrive
p video_card_buyers.dequeue #expect Janine, she was the third to arrive
p video_card_buyers.dequeue #expect Janice, she was the fourth to arrive
p video_card_buyers.peek #Expect Jessica, she's still waiting