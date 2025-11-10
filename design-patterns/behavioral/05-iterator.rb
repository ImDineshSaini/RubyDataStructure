# ========================================
# ITERATOR PATTERN
# ========================================
# Provides a way to access elements of an aggregate object sequentially
# without exposing its underlying representation.

puts "=" * 50
puts "ITERATOR PATTERN"
puts "=" * 50

# ========================================
# 1. PROBLEM WITHOUT ITERATOR
# ========================================

puts "\n1. Problem - Exposing Internal Structure:"

# BAD: Exposes internal array structure
class BookShelfBad
  attr_reader :books

  def initialize
    @books = []
  end

  def add_book(book)
    @books << book
  end
end

shelf = BookShelfBad.new
shelf.add_book("Ruby Programming")
shelf.add_book("Design Patterns")

# Client directly accesses internal structure
shelf.books.each { |book| puts book }

puts "\nProblem: Client knows about internal array structure"

# ========================================
# 2. ITERATOR PATTERN SOLUTION
# ========================================

puts "\n2. Iterator Pattern:"

# Iterator interface
class Iterator
  def has_next?
    raise NotImplementedError
  end

  def next
    raise NotImplementedError
  end

  def reset
    raise NotImplementedError
  end
end

# Aggregate interface
class Aggregate
  def create_iterator
    raise NotImplementedError
  end
end

# Concrete iterator
class BookIterator < Iterator
  def initialize(books)
    @books = books
    @index = 0
  end

  def has_next?
    @index < @books.length
  end

  def next
    return nil unless has_next?
    book = @books[@index]
    @index += 1
    book
  end

  def reset
    @index = 0
  end
end

# Concrete aggregate
class BookShelf < Aggregate
  def initialize
    @books = []
  end

  def add_book(book)
    @books << book
  end

  def create_iterator
    BookIterator.new(@books)
  end

  def size
    @books.length
  end
end

puts "Using iterator pattern:"
shelf = BookShelf.new
shelf.add_book("Ruby Programming")
shelf.add_book("Design Patterns")
shelf.add_book("Clean Code")

iterator = shelf.create_iterator
while iterator.has_next?
  puts "📖 #{iterator.next}"
end

# ========================================
# 3. RUBY'S ENUMERABLE MODULE
# ========================================

puts "\n3. Ruby's Enumerable Module:"

class CustomCollection
  include Enumerable

  def initialize
    @items = []
  end

  def add(item)
    @items << item
  end

  # Only need to implement 'each' to get all Enumerable methods!
  def each(&block)
    @items.each(&block)
  end
end

collection = CustomCollection.new
collection.add(10)
collection.add(20)
collection.add(30)
collection.add(40)
collection.add(50)

puts "Using Enumerable methods:"
puts "All items: #{collection.to_a}"
puts "Select > 25: #{collection.select { |x| x > 25 }}"
puts "Map (x*2): #{collection.map { |x| x * 2 }}"
puts "Sum: #{collection.sum}"
puts "Any > 40? #{collection.any? { |x| x > 40 }}"

# ========================================
# 4. BIDIRECTIONAL ITERATOR
# ========================================

puts "\n4. Bidirectional Iterator:"

class BiIterator
  def initialize(items)
    @items = items
    @index = 0
  end

  def has_next?
    @index < @items.length
  end

  def next
    return nil unless has_next?
    item = @items[@index]
    @index += 1
    item
  end

  def has_previous?
    @index > 0
  end

  def previous
    return nil unless has_previous?
    @index -= 1
    @items[@index]
  end

  def reset
    @index = 0
  end

  def reset_to_end
    @index = @items.length
  end
end

items = ["A", "B", "C", "D", "E"]
iterator = BiIterator.new(items)

puts "Forward iteration:"
while iterator.has_next?
  print "#{iterator.next} "
end
puts

puts "\nBackward iteration:"
while iterator.has_previous?
  print "#{iterator.previous} "
end
puts

# ========================================
# 5. TREE ITERATOR (DFS AND BFS)
# ========================================

puts "\n5. Tree Iterator:"

class TreeNode
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class DFSIterator
  def initialize(root)
    @stack = root ? [root] : []
  end

  def has_next?
    !@stack.empty?
  end

  def next
    return nil unless has_next?

    node = @stack.pop
    @stack.push(node.right) if node.right
    @stack.push(node.left) if node.left

    node.value
  end
end

class BFSIterator
  def initialize(root)
    @queue = root ? [root] : []
  end

  def has_next?
    !@queue.empty?
  end

  def next
    return nil unless has_next?

    node = @queue.shift
    @queue.push(node.left) if node.left
    @queue.push(node.right) if node.right

    node.value
  end
end

# Build tree:
#       1
#      / \
#     2   3
#    / \   \
#   4   5   6
root = TreeNode.new(1)
root.left = TreeNode.new(2)
root.right = TreeNode.new(3)
root.left.left = TreeNode.new(4)
root.left.right = TreeNode.new(5)
root.right.right = TreeNode.new(6)

puts "DFS traversal:"
dfs = DFSIterator.new(root)
values = []
values << dfs.next while dfs.has_next?
puts values.join(" → ")

puts "\nBFS traversal:"
bfs = BFSIterator.new(root)
values = []
values << bfs.next while bfs.has_next?
puts values.join(" → ")

# ========================================
# 6. LAZY ITERATOR
# ========================================

puts "\n6. Lazy Iterator:"

class FibonacciIterator
  def initialize(limit)
    @limit = limit
    @a = 0
    @b = 1
    @count = 0
  end

  def has_next?
    @count < @limit
  end

  def next
    return nil unless has_next?

    current = @a
    @a, @b = @b, @a + @b
    @count += 1
    current
  end

  def reset
    @a = 0
    @b = 1
    @count = 0
  end
end

puts "First 10 Fibonacci numbers:"
fib = FibonacciIterator.new(10)
fibonacci_numbers = []
fibonacci_numbers << fib.next while fib.has_next?
puts fibonacci_numbers.join(", ")

# ========================================
# 7. FILTERING ITERATOR
# ========================================

puts "\n7. Filtering Iterator:"

class FilterIterator
  def initialize(iterator, &filter)
    @iterator = iterator
    @filter = filter
  end

  def has_next?
    # Look ahead to find next matching item
    while @iterator.has_next?
      @next_item = @iterator.next
      return true if @filter.call(@next_item)
    end
    false
  end

  def next
    @next_item
  end
end

numbers = (1..20).to_a
base_iterator = BookIterator.new(numbers)
even_iterator = FilterIterator.new(base_iterator) { |n| n.even? }

puts "Even numbers from 1-20:"
evens = []
evens << even_iterator.next while even_iterator.has_next?
puts evens.join(", ")

# ========================================
# 8. SNAPSHOT ITERATOR
# ========================================

puts "\n8. Snapshot Iterator (Fail-Safe):"

class SnapshotIterator
  def initialize(items)
    @items = items.dup  # Create snapshot
    @index = 0
  end

  def has_next?
    @index < @items.length
  end

  def next
    return nil unless has_next?
    item = @items[@index]
    @index += 1
    item
  end
end

class SafeCollection
  def initialize
    @items = []
  end

  def add(item)
    @items << item
  end

  def iterator
    SnapshotIterator.new(@items)
  end
end

collection = SafeCollection.new
[1, 2, 3, 4, 5].each { |n| collection.add(n) }

iterator = collection.iterator
puts "Iterating with concurrent modification:"
count = 0
while iterator.has_next?
  value = iterator.next
  puts "  #{value}"
  collection.add(value * 10) if count == 2  # Modify during iteration
  count += 1
end
puts "Iterator not affected by concurrent modification!"

# ========================================
# 9. COMPOSITE ITERATOR
# ========================================

puts "\n9. Composite Iterator:"

class CompositeIterator
  def initialize(*iterators)
    @iterators = iterators
    @current_index = 0
  end

  def has_next?
    return false if @current_index >= @iterators.length

    if @iterators[@current_index].has_next?
      true
    elsif @current_index < @iterators.length - 1
      @current_index += 1
      has_next?
    else
      false
    end
  end

  def next
    return nil unless has_next?
    @iterators[@current_index].next
  end
end

it1 = BookIterator.new([1, 2, 3])
it2 = BookIterator.new([4, 5, 6])
it3 = BookIterator.new([7, 8, 9])

composite = CompositeIterator.new(it1, it2, it3)

puts "Composite iterator (3 collections):"
values = []
values << composite.next while composite.has_next?
puts values.join(", ")

# ========================================
# 10. EXTERNAL VS INTERNAL ITERATION
# ========================================

puts "\n10. External vs Internal Iteration:"

class NumberRange
  def initialize(start, finish)
    @start = start
    @finish = finish
  end

  # External iteration
  def external_iterator
    RangeIterator.new(@start, @finish)
  end

  # Internal iteration
  def each
    current = @start
    while current <= @finish
      yield current
      current += 1
    end
  end
end

class RangeIterator
  def initialize(start, finish)
    @current = start
    @finish = finish
  end

  def has_next?
    @current <= @finish
  end

  def next
    return nil unless has_next?
    value = @current
    @current += 1
    value
  end
end

range = NumberRange.new(1, 5)

puts "External iteration (client controls):"
it = range.external_iterator
while it.has_next?
  puts "  #{it.next}"
end

puts "\nInternal iteration (collection controls):"
range.each do |n|
  puts "  #{n}"
end

# ========================================
# 11. PRACTICAL: FILE READER ITERATOR
# ========================================

puts "\n11. Practical: Line-by-Line File Iterator:"

class FileLineIterator
  def initialize(content)
    @lines = content.split("\n")
    @index = 0
  end

  def has_next?
    @index < @lines.length
  end

  def next
    return nil unless has_next?
    line = @lines[@index]
    @index += 1
    line
  end

  def reset
    @index = 0
  end
end

# Simulate file content
file_content = <<~TEXT
  Line 1: First line
  Line 2: Second line
  Line 3: Third line
  Line 4: Fourth line
TEXT

puts "Reading file line by line:"
iterator = FileLineIterator.new(file_content)
line_num = 1
while iterator.has_next?
  puts "  #{line_num}: #{iterator.next}"
  line_num += 1
end

# ========================================
# 12. PRACTICAL: DATABASE RESULT ITERATOR
# ========================================

puts "\n12. Practical: Database Result Iterator:"

class QueryResult
  def initialize(rows)
    @rows = rows
    @index = 0
    @batch_size = 100
  end

  def has_next?
    @index < @rows.length
  end

  def next
    return nil unless has_next?
    row = @rows[@index]
    @index += 1
    row
  end

  # Batch iteration
  def next_batch(size = @batch_size)
    batch = []
    size.times do
      break unless has_next?
      batch << self.next
    end
    batch
  end

  def reset
    @index = 0
  end
end

# Simulate database rows
rows = (1..250).map { |i| { id: i, name: "User#{i}", email: "user#{i}@example.com" } }

puts "Processing database results in batches:"
result_set = QueryResult.new(rows)

batch_num = 1
while result_set.has_next?
  batch = result_set.next_batch(50)
  puts "  Batch #{batch_num}: #{batch.size} records (IDs: #{batch.first[:id]}-#{batch.last[:id]})"
  batch_num += 1
end

# ========================================
# 13. PRACTICAL: PAGINATION ITERATOR
# ========================================

puts "\n13. Practical: Pagination Iterator:"

class PaginationIterator
  def initialize(items, page_size = 10)
    @items = items
    @page_size = page_size
    @current_page = 0
    @total_pages = (@items.length.to_f / @page_size).ceil
  end

  def has_next_page?
    @current_page < @total_pages
  end

  def next_page
    return [] unless has_next_page?

    start_index = @current_page * @page_size
    end_index = [start_index + @page_size - 1, @items.length - 1].min

    @current_page += 1
    @items[start_index..end_index]
  end

  def previous_page
    return [] if @current_page <= 1

    @current_page -= 1
    start_index = (@current_page - 1) * @page_size
    end_index = [start_index + @page_size - 1, @items.length - 1].min

    @items[start_index..end_index]
  end

  def page(number)
    return [] if number < 1 || number > @total_pages

    start_index = (number - 1) * @page_size
    end_index = [start_index + @page_size - 1, @items.length - 1].min

    @items[start_index..end_index]
  end

  def total_pages
    @total_pages
  end

  def current_page
    @current_page
  end
end

items = (1..47).to_a
paginator = PaginationIterator.new(items, 10)

puts "Total items: #{items.length}"
puts "Page size: 10"
puts "Total pages: #{paginator.total_pages}"

puts "\nPage 1:"
puts paginator.next_page.inspect

puts "\nPage 2:"
puts paginator.next_page.inspect

puts "\nJump to page 5:"
puts paginator.page(5).inspect

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "ITERATOR PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Provide sequential access to elements"
puts "• Don't expose underlying representation"
puts "• Support multiple traversals"
puts "• Provide uniform interface for different aggregates"
puts "\nWHEN TO USE:"
puts "• Access aggregate contents without exposing internals"
puts "• Support multiple traversals of aggregates"
puts "• Provide uniform interface for different structures"
puts "• Need to iterate over composite structures"
puts "\nCOMPONENTS:"
puts "• Iterator: Interface for accessing elements"
puts "• Concrete Iterator: Implements iteration algorithm"
puts "• Aggregate: Interface for creating iterator"
puts "• Concrete Aggregate: Returns concrete iterator"
puts "\nTYPES OF ITERATORS:"
puts "• Forward Iterator: One direction only"
puts "• Bidirectional Iterator: Forward and backward"
puts "• Random Access Iterator: Jump to any position"
puts "• Filtering Iterator: Only matching elements"
puts "• Snapshot Iterator: Fail-safe, uses copy"
puts "• Lazy Iterator: Generate on demand"
puts "• Composite Iterator: Multiple collections"
puts "\nEXTERNAL VS INTERNAL:"
puts "• External: Client controls iteration (has_next?, next)"
puts "• Internal: Collection controls (each with block)"
puts "• External: More flexible, pauseable"
puts "• Internal: More convenient, Ruby style"
puts "\nBENEFITS:"
puts "✓ Single Responsibility Principle"
puts "✓ Hides internal structure"
puts "✓ Multiple iterators on same collection"
puts "✓ Supports different traversal algorithms"
puts "✓ Open/Closed Principle (new iterators without changing aggregate)"
puts "\nDRAWBACKS:"
puts "✗ Overkill for simple collections"
puts "✗ Less efficient than direct access"
puts "✗ May be complex for nested structures"
puts "\nRUBY SPECIFICS:"
puts "• Use Enumerable module for internal iteration"
puts "• Only need to implement 'each' method"
puts "• Get map, select, reduce, etc. for free"
puts "• Lazy enumerators for infinite sequences"
puts "• Use yield for block-based iteration"
puts "\nREAL-WORLD EXAMPLES:"
puts "• File readers (line by line)"
puts "• Database result sets (row by row)"
puts "• Tree traversal (DFS, BFS)"
puts "• Pagination"
puts "• Directory traversal"
puts "• Social media feeds"
puts "=" * 50
