# ========================================
# QUEUES IN RUBY
# ========================================
# A queue is a FIFO (First In, First Out) data structure.
# Elements are added at the rear and removed from the front.

puts "=" * 50
puts "QUEUES IN RUBY"
puts "=" * 50

# ========================================
# 1. QUEUE USING ARRAY
# ========================================

class Queue
  def initialize
    @items = []
  end

  # Enqueue (add to rear) - O(1)
  def enqueue(item)
    @items.push(item)
  end

  # Dequeue (remove from front) - O(n) due to shift
  def dequeue
    @items.shift
  end

  # Peek at front - O(1)
  def front
    @items.first
  end

  # Check if empty - O(1)
  def empty?
    @items.empty?
  end

  # Get size - O(1)
  def size
    @items.length
  end

  # Display queue
  def display
    "Front [#{@items.join(', ')}] Rear"
  end
end

puts "\n1. Basic Queue Operations:"

queue = Queue.new
puts "Initial: #{queue.display}"

queue.enqueue(10)
queue.enqueue(20)
queue.enqueue(30)
puts "After enqueuing 10, 20, 30: #{queue.display}"

puts "Front element: #{queue.front}"
puts "Size: #{queue.size}"

dequeued = queue.dequeue
puts "Dequeued: #{dequeued}"
puts "After dequeue: #{queue.display}"

# ========================================
# 2. CIRCULAR QUEUE
# ========================================

class CircularQueue
  def initialize(capacity)
    @items = Array.new(capacity)
    @capacity = capacity
    @front = 0
    @rear = -1
    @size = 0
  end

  def enqueue(item)
    return false if full?

    @rear = (@rear + 1) % @capacity
    @items[@rear] = item
    @size += 1
    true
  end

  def dequeue
    return nil if empty?

    item = @items[@front]
    @items[@front] = nil
    @front = (@front + 1) % @capacity
    @size -= 1
    item
  end

  def front
    empty? ? nil : @items[@front]
  end

  def rear
    empty? ? nil : @items[@rear]
  end

  def empty?
    @size == 0
  end

  def full?
    @size == @capacity
  end

  def size
    @size
  end

  def display
    return "Empty queue" if empty?

    result = []
    idx = @front
    @size.times do
      result << @items[idx]
      idx = (idx + 1) % @capacity
    end
    "Front [#{result.join(', ')}] Rear"
  end
end

puts "\n2. Circular Queue:"

circular = CircularQueue.new(5)
[1, 2, 3, 4, 5].each { |n| circular.enqueue(n) }
puts "Full queue: #{circular.display}"
puts "Is full? #{circular.full?}"

circular.dequeue
circular.dequeue
puts "After 2 dequeues: #{circular.display}"

circular.enqueue(6)
circular.enqueue(7)
puts "After enqueuing 6, 7: #{circular.display}"

# ========================================
# 3. QUEUE USING LINKED LIST
# ========================================

class Node
  attr_accessor :data, :next

  def initialize(data)
    @data = data
    @next = nil
  end
end

class LinkedQueue
  def initialize
    @front = nil
    @rear = nil
    @size = 0
  end

  def enqueue(data)
    new_node = Node.new(data)

    if @rear.nil?
      @front = @rear = new_node
    else
      @rear.next = new_node
      @rear = new_node
    end

    @size += 1
  end

  def dequeue
    return nil if @front.nil?

    data = @front.data
    @front = @front.next
    @rear = nil if @front.nil?
    @size -= 1
    data
  end

  def front
    @front&.data
  end

  def empty?
    @front.nil?
  end

  def size
    @size
  end

  def display
    return "Empty queue" if @front.nil?

    result = []
    current = @front
    while current
      result << current.data
      current = current.next
    end
    "Front [#{result.join(', ')}] Rear"
  end
end

puts "\n3. Queue Using Linked List:"

linked_queue = LinkedQueue.new
%w[A B C D].each { |item| linked_queue.enqueue(item) }
puts "Queue: #{linked_queue.display}"

puts "Dequeued: #{linked_queue.dequeue}"
puts "After dequeue: #{linked_queue.display}"

# ========================================
# 4. PRIORITY QUEUE
# ========================================

class PriorityQueue
  def initialize
    @items = []
  end

  def enqueue(item, priority)
    @items << { item: item, priority: priority }
    @items.sort_by! { |x| -x[:priority] }  # Higher priority first
  end

  def dequeue
    @items.shift&.dig(:item)
  end

  def front
    @items.first&.dig(:item)
  end

  def empty?
    @items.empty?
  end

  def size
    @items.length
  end

  def display
    return "Empty queue" if @items.empty?

    items_str = @items.map { |x| "#{x[:item]}(#{x[:priority]})" }.join(', ')
    "Front [#{items_str}] Rear"
  end
end

puts "\n4. Priority Queue:"

pq = PriorityQueue.new
pq.enqueue("Low priority task", 1)
pq.enqueue("High priority task", 10)
pq.enqueue("Medium priority task", 5)
pq.enqueue("Critical task", 20)

puts "Priority queue: #{pq.display}"

puts "\nProcessing by priority:"
until pq.empty?
  puts "Processing: #{pq.dequeue}"
end

# ========================================
# 5. DEQUE (DOUBLE-ENDED QUEUE)
# ========================================

class Deque
  def initialize
    @items = []
  end

  def add_front(item)
    @items.unshift(item)
  end

  def add_rear(item)
    @items.push(item)
  end

  def remove_front
    @items.shift
  end

  def remove_rear
    @items.pop
  end

  def front
    @items.first
  end

  def rear
    @items.last
  end

  def empty?
    @items.empty?
  end

  def size
    @items.length
  end

  def display
    "Front [#{@items.join(', ')}] Rear"
  end
end

puts "\n5. Deque (Double-Ended Queue):"

deque = Deque.new
deque.add_rear(1)
deque.add_rear(2)
deque.add_front(0)
puts "Deque: #{deque.display}"

puts "Remove from front: #{deque.remove_front}"
puts "Remove from rear: #{deque.remove_rear}"
puts "After removals: #{deque.display}"

# ========================================
# 6. PRACTICAL APPLICATIONS
# ========================================

puts "\n6. Practical Applications:"

# Application 1: BFS (Breadth-First Search)
def bfs(graph, start)
  visited = []
  queue = Queue.new
  queue.enqueue(start)

  while !queue.empty?
    node = queue.dequeue
    next if visited.include?(node)

    visited << node
    puts "  Visited: #{node}"

    graph[node]&.each do |neighbor|
      queue.enqueue(neighbor) unless visited.include?(neighbor)
    end
  end

  visited
end

graph = {
  'A' => ['B', 'C'],
  'B' => ['A', 'D', 'E'],
  'C' => ['A', 'F'],
  'D' => ['B'],
  'E' => ['B', 'F'],
  'F' => ['C', 'E']
}

puts "BFS traversal starting from A:"
bfs(graph, 'A')

# Application 2: Task Scheduler
class TaskScheduler
  def initialize
    @queue = Queue.new
  end

  def add_task(task)
    @queue.enqueue(task)
    puts "Added task: #{task}"
  end

  def process_tasks
    puts "\nProcessing tasks:"
    until @queue.empty?
      task = @queue.dequeue
      puts "  Executing: #{task}"
      sleep(0.1)  # Simulate work
    end
    puts "All tasks completed!"
  end
end

puts "\nTask Scheduler:"
scheduler = TaskScheduler.new
scheduler.add_task("Send email")
scheduler.add_task("Generate report")
scheduler.add_task("Update database")
scheduler.process_tasks

# Application 3: Print Queue
class PrintQueue
  def initialize
    @queue = PriorityQueue.new
  end

  def add_job(document, priority)
    @queue.enqueue(document, priority)
    puts "Added to print queue: #{document} (priority: #{priority})"
  end

  def print_next
    job = @queue.dequeue
    if job
      puts "  Printing: #{job}"
    else
      puts "  Print queue is empty"
    end
  end

  def print_all
    puts "\nPrinting all jobs:"
    until @queue.empty?
      print_next
    end
  end
end

puts "\nPrint Queue:"
printer = PrintQueue.new
printer.add_job("Report.pdf", 5)
printer.add_job("Invoice.pdf", 10)
printer.add_job("Memo.pdf", 3)
printer.add_job("Contract.pdf", 15)
printer.print_all

# Application 4: Hot Potato Game
def hot_potato(names, num)
  queue = Queue.new
  names.each { |name| queue.enqueue(name) }

  while queue.size > 1
    num.times do
      queue.enqueue(queue.dequeue)
    end

    eliminated = queue.dequeue
    puts "  #{eliminated} is eliminated"
  end

  queue.dequeue
end

puts "\nHot Potato Game:"
players = %w[Alice Bob Charlie David Eve]
puts "Players: #{players.join(', ')}"
winner = hot_potato(players, 3)
puts "Winner: #{winner}!"

# Application 5: Level-order tree traversal
class TreeNode
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

def level_order_traversal(root)
  return [] if root.nil?

  result = []
  queue = Queue.new
  queue.enqueue(root)

  while !queue.empty?
    node = queue.dequeue
    result << node.value

    queue.enqueue(node.left) if node.left
    queue.enqueue(node.right) if node.right
  end

  result
end

puts "\nLevel-order tree traversal:"
root = TreeNode.new(1)
root.left = TreeNode.new(2)
root.right = TreeNode.new(3)
root.left.left = TreeNode.new(4)
root.left.right = TreeNode.new(5)
root.right.right = TreeNode.new(6)

puts "Tree:"
puts "       1"
puts "      / \\"
puts "     2   3"
puts "    / \\   \\"
puts "   4   5   6"
puts "Level-order: #{level_order_traversal(root)}"

# ========================================
# TIME COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY ANALYSIS"
puts "=" * 50
puts "Array-based Queue:"
puts "  Enqueue:            O(1)"
puts "  Dequeue:            O(n) - shift is expensive"
puts "  Front:              O(1)"
puts "  Space:              O(n)"
puts "\nLinked List Queue:"
puts "  Enqueue:            O(1)"
puts "  Dequeue:            O(1)"
puts "  Front:              O(1)"
puts "  Space:              O(n)"
puts "\nCircular Queue:"
puts "  Enqueue:            O(1)"
puts "  Dequeue:            O(1)"
puts "  Front:              O(1)"
puts "  Space:              O(n) - fixed size"
puts "=" * 50

# ========================================
# PRACTICE PROBLEMS
# ========================================

puts "\nPRACTICE PROBLEMS:"
puts "1. Implement queue using stacks"
puts "2. Implement stack using queues"
puts "3. Generate binary numbers from 1 to n"
puts "4. First non-repeating character in a stream"
puts "5. Reverse first k elements of queue"
puts "6. Interleave first half of queue with second half"
puts "7. Check if queue can be sorted using another queue"
puts "8. Implement circular tour (petrol pump problem)"
puts "9. Sliding window maximum"
puts "10. Design hit counter using queue"
