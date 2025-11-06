# ========================================
# HEAPS IN RUBY
# ========================================
# A heap is a complete binary tree that satisfies the heap property:
# - Max Heap: Parent >= Children
# - Min Heap: Parent <= Children
# Implemented using an array for efficiency

puts "=" * 50
puts "HEAPS IN RUBY"
puts "=" * 50

# ========================================
# 1. MIN HEAP IMPLEMENTATION
# ========================================

class MinHeap
  def initialize
    @heap = []
  end

  # Get parent, left child, right child indices
  def parent(i)
    (i - 1) / 2
  end

  def left_child(i)
    2 * i + 1
  end

  def right_child(i)
    2 * i + 2
  end

  # Insert element - O(log n)
  def insert(value)
    @heap.push(value)
    heapify_up(@heap.length - 1)
  end

  # Remove minimum - O(log n)
  def extract_min
    return nil if @heap.empty?

    min = @heap[0]
    @heap[0] = @heap.pop
    heapify_down(0) unless @heap.empty?

    min
  end

  # Get minimum without removing - O(1)
  def peek
    @heap[0]
  end

  # Check if empty - O(1)
  def empty?
    @heap.empty?
  end

  # Get size - O(1)
  def size
    @heap.length
  end

  # Heapify up (bubble up) - O(log n)
  private def heapify_up(index)
    while index > 0 && @heap[parent(index)] > @heap[index]
      @heap[index], @heap[parent(index)] = @heap[parent(index)], @heap[index]
      index = parent(index)
    end
  end

  # Heapify down (bubble down) - O(log n)
  private def heapify_down(index)
    min_index = index

    left = left_child(index)
    min_index = left if left < @heap.length && @heap[left] < @heap[min_index]

    right = right_child(index)
    min_index = right if right < @heap.length && @heap[right] < @heap[min_index]

    if min_index != index
      @heap[index], @heap[min_index] = @heap[min_index], @heap[index]
      heapify_down(min_index)
    end
  end

  def display
    "MinHeap: #{@heap}"
  end
end

puts "\n1. Min Heap Operations:"

min_heap = MinHeap.new
[5, 3, 7, 1, 9, 4].each { |n| min_heap.insert(n) }
puts "After insertions: #{min_heap.display}"

puts "Minimum: #{min_heap.peek}"
puts "Extract min: #{min_heap.extract_min}"
puts "After extraction: #{min_heap.display}"

# ========================================
# 2. MAX HEAP IMPLEMENTATION
# ========================================

class MaxHeap
  def initialize
    @heap = []
  end

  def parent(i)
    (i - 1) / 2
  end

  def left_child(i)
    2 * i + 1
  end

  def right_child(i)
    2 * i + 2
  end

  def insert(value)
    @heap.push(value)
    heapify_up(@heap.length - 1)
  end

  def extract_max
    return nil if @heap.empty?

    max = @heap[0]
    @heap[0] = @heap.pop
    heapify_down(0) unless @heap.empty?

    max
  end

  def peek
    @heap[0]
  end

  def empty?
    @heap.empty?
  end

  def size
    @heap.length
  end

  private def heapify_up(index)
    while index > 0 && @heap[parent(index)] < @heap[index]
      @heap[index], @heap[parent(index)] = @heap[parent(index)], @heap[index]
      index = parent(index)
    end
  end

  private def heapify_down(index)
    max_index = index

    left = left_child(index)
    max_index = left if left < @heap.length && @heap[left] > @heap[max_index]

    right = right_child(index)
    max_index = right if right < @heap.length && @heap[right] > @heap[max_index]

    if max_index != index
      @heap[index], @heap[max_index] = @heap[max_index], @heap[index]
      heapify_down(max_index)
    end
  end

  def display
    "MaxHeap: #{@heap}"
  end

  def to_a
    @heap.dup
  end
end

puts "\n2. Max Heap Operations:"

max_heap = MaxHeap.new
[5, 3, 7, 1, 9, 4].each { |n| max_heap.insert(n) }
puts "After insertions: #{max_heap.display}"

puts "Maximum: #{max_heap.peek}"
puts "Extract max: #{max_heap.extract_max}"
puts "After extraction: #{max_heap.display}"

# ========================================
# 3. HEAPIFY ARRAY (BUILD HEAP)
# ========================================

def heapify_array(arr)
  heap = MaxHeap.new
  # Start from last non-leaf node and heapify down
  arr.each { |val| heap.insert(val) }
  heap
end

puts "\n3. Build Heap from Array:"
arr = [4, 10, 3, 5, 1]
heap = heapify_array(arr)
puts "Heap from #{arr}: #{heap.display}"

# ========================================
# 4. HEAP SORT
# ========================================

def heap_sort(arr)
  heap = MaxHeap.new
  arr.each { |val| heap.insert(val) }

  sorted = []
  sorted.unshift(heap.extract_max) until heap.empty?
  sorted
end

puts "\n4. Heap Sort:"
unsorted = [64, 34, 25, 12, 22, 11, 90]
sorted = heap_sort(unsorted)
puts "Unsorted: #{unsorted}"
puts "Sorted: #{sorted}"

# ========================================
# 5. PRIORITY QUEUE
# ========================================

class PriorityQueue
  def initialize(max_heap = true)
    @heap = max_heap ? MaxHeap.new : MinHeap.new
    @max_heap = max_heap
  end

  def enqueue(item, priority)
    @heap.insert({ item: item, priority: priority })
  end

  def dequeue
    @heap.extract_max || @heap.extract_min
  end

  def peek
    @heap.peek
  end

  def empty?
    @heap.empty?
  end

  def size
    @heap.size
  end
end

# Custom priority queue with object comparison
class Task
  attr_reader :name, :priority

  def initialize(name, priority)
    @name = name
    @priority = priority
  end

  def <=>(other)
    @priority <=> other.priority
  end

  def to_s
    "Task(#{@name}, priority=#{@priority})"
  end
end

class TaskPriorityQueue
  def initialize
    @heap = []
  end

  def add_task(task)
    @heap.push(task)
    heapify_up(@heap.length - 1)
  end

  def get_next_task
    return nil if @heap.empty?

    task = @heap[0]
    @heap[0] = @heap.pop
    heapify_down(0) unless @heap.empty?

    task
  end

  private def parent(i)
    (i - 1) / 2
  end

  private def left_child(i)
    2 * i + 1
  end

  private def right_child(i)
    2 * i + 2
  end

  private def heapify_up(index)
    while index > 0 && @heap[parent(index)].priority < @heap[index].priority
      @heap[index], @heap[parent(index)] = @heap[parent(index)], @heap[index]
      index = parent(index)
    end
  end

  private def heapify_down(index)
    max_index = index

    left = left_child(index)
    if left < @heap.length && @heap[left].priority > @heap[max_index].priority
      max_index = left
    end

    right = right_child(index)
    if right < @heap.length && @heap[right].priority > @heap[max_index].priority
      max_index = right
    end

    if max_index != index
      @heap[index], @heap[max_index] = @heap[max_index], @heap[index]
      heapify_down(max_index)
    end
  end
end

puts "\n5. Priority Queue:"

task_queue = TaskPriorityQueue.new
task_queue.add_task(Task.new("Low priority task", 1))
task_queue.add_task(Task.new("High priority task", 10))
task_queue.add_task(Task.new("Medium priority task", 5))
task_queue.add_task(Task.new("Critical task", 20))

puts "Processing tasks by priority:"
4.times do
  task = task_queue.get_next_task
  puts "  #{task}"
end

# ========================================
# 6. FIND KTH LARGEST/SMALLEST
# ========================================

def find_kth_largest(arr, k)
  heap = MinHeap.new

  arr.each do |num|
    heap.insert(num)
    heap.extract_min if heap.size > k
  end

  heap.peek
end

def find_kth_smallest(arr, k)
  heap = MaxHeap.new

  arr.each do |num|
    heap.insert(num)
    heap.extract_max if heap.size > k
  end

  heap.peek
end

puts "\n6. Find Kth Element:"
arr = [3, 2, 1, 5, 6, 4]
puts "Array: #{arr}"
puts "3rd largest: #{find_kth_largest(arr, 3)}"
puts "3rd smallest: #{find_kth_smallest(arr, 3)}"

# ========================================
# 7. MEDIAN FINDER
# ========================================

class MedianFinder
  def initialize
    @max_heap = MaxHeap.new  # Stores smaller half
    @min_heap = MinHeap.new  # Stores larger half
  end

  def add_num(num)
    if @max_heap.empty? || num <= @max_heap.peek
      @max_heap.insert(num)
    else
      @min_heap.insert(num)
    end

    # Balance heaps
    if @max_heap.size > @min_heap.size + 1
      @min_heap.insert(@max_heap.extract_max)
    elsif @min_heap.size > @max_heap.size
      @max_heap.insert(@min_heap.extract_min)
    end
  end

  def find_median
    if @max_heap.size == @min_heap.size
      (@max_heap.peek + @min_heap.peek) / 2.0
    else
      @max_heap.peek.to_f
    end
  end
end

puts "\n7. Running Median:"
median_finder = MedianFinder.new
[1, 2, 3, 4, 5].each do |num|
  median_finder.add_num(num)
  puts "After adding #{num}, median: #{median_finder.find_median}"
end

# ========================================
# 8. MERGE K SORTED LISTS
# ========================================

def merge_k_sorted_lists(lists)
  heap = MinHeap.new
  result = []

  # Add first element from each list
  lists.each_with_index do |list, list_idx|
    heap.insert({ value: list[0], list_idx: list_idx, elem_idx: 0 }) unless list.empty?
  end

  until heap.empty?
    item = heap.extract_min
    result << item[:value]

    # Add next element from same list
    next_idx = item[:elem_idx] + 1
    if next_idx < lists[item[:list_idx]].length
      heap.insert({
        value: lists[item[:list_idx]][next_idx],
        list_idx: item[:list_idx],
        elem_idx: next_idx
      })
    end
  end

  result
end

puts "\n8. Merge K Sorted Lists:"
lists = [
  [1, 4, 7],
  [2, 5, 8],
  [3, 6, 9]
]
puts "Lists: #{lists.inspect}"
puts "Merged: #{merge_k_sorted_lists(lists)}"

# ========================================
# TIME COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY ANALYSIS"
puts "=" * 50
puts "Insert:               O(log n)"
puts "Extract Min/Max:      O(log n)"
puts "Peek:                 O(1)"
puts "Build Heap:           O(n)"
puts "Heap Sort:            O(n log n)"
puts "Find Kth Largest:     O(n log k)"
puts "Space Complexity:     O(n)"
puts "=" * 50

# ========================================
# PRACTICE PROBLEMS
# ========================================

puts "\nPRACTICE PROBLEMS:"
puts "1. Top K frequent elements"
puts "2. Merge K sorted arrays"
puts "3. Find median from data stream"
puts "4. Kth largest element in stream"
puts "5. Reorganize string (no two same adjacent)"
puts "6. Meeting rooms II (min meeting rooms needed)"
puts "7. Find K closest points to origin"
puts "8. Task scheduler with cooldown"
puts "9. Minimum cost to connect sticks"
puts "10. Sliding window maximum using heap"
