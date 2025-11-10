# ========================================
# LINKED LISTS IN RUBY
# ========================================
# A linked list is a linear data structure where elements are stored
# in nodes, and each node points to the next node.

puts "=" * 50
puts "LINKED LISTS IN RUBY"
puts "=" * 50

# ========================================
# 1. NODE CLASS
# ========================================

class Node
  attr_accessor :data, :next

  def initialize(data)
    @data = data
    @next = nil
  end
end

# ========================================
# 2. SINGLY LINKED LIST
# ========================================

class LinkedList
  attr_accessor :head

  def initialize
    @head = nil
  end

  # Insert at beginning - O(1)
  def prepend(data)
    new_node = Node.new(data)
    new_node.next = @head
    @head = new_node
  end

  # Insert at end - O(n)
  def append(data)
    new_node = Node.new(data)

    if @head.nil?
      @head = new_node
      return
    end

    current = @head
    current = current.next while current.next
    current.next = new_node
  end

  # Insert after a specific node - O(n)
  def insert_after(prev_data, data)
    current = @head

    while current && current.data != prev_data
      current = current.next
    end

    return if current.nil?

    new_node = Node.new(data)
    new_node.next = current.next
    current.next = new_node
  end

  # Delete a node - O(n)
  def delete(data)
    return if @head.nil?

    # If head needs to be deleted
    if @head.data == data
      @head = @head.next
      return
    end

    current = @head
    while current.next && current.next.data != data
      current = current.next
    end

    return if current.next.nil?

    current.next = current.next.next
  end

  # Search - O(n)
  def search(data)
    current = @head
    while current
      return true if current.data == data
      current = current.next
    end
    false
  end

  # Get size - O(n)
  def size
    count = 0
    current = @head
    while current
      count += 1
      current = current.next
    end
    count
  end

  # Display list
  def display
    return "Empty list" if @head.nil?

    result = []
    current = @head
    while current
      result << current.data
      current = current.next
    end
    result.join(" -> ")
  end

  # Reverse the linked list - O(n)
  def reverse
    prev = nil
    current = @head

    while current
      next_node = current.next
      current.next = prev
      prev = current
      current = next_node
    end

    @head = prev
  end

  # Find middle element - O(n)
  def find_middle
    return nil if @head.nil?

    slow = @head
    fast = @head

    while fast && fast.next
      slow = slow.next
      fast = fast.next.next
    end

    slow.data
  end

  # Detect cycle - O(n)
  def has_cycle?
    return false if @head.nil?

    slow = @head
    fast = @head

    while fast && fast.next
      slow = slow.next
      fast = fast.next.next
      return true if slow == fast
    end

    false
  end

  # Remove duplicates from sorted list - O(n)
  def remove_duplicates_sorted
    return if @head.nil?

    current = @head
    while current && current.next
      if current.data == current.next.data
        current.next = current.next.next
      else
        current = current.next
      end
    end
  end
end

# ========================================
# 3. TESTING SINGLY LINKED LIST
# ========================================

puts "\n3. Singly Linked List Operations:"

list = LinkedList.new
list.append(1)
list.append(2)
list.append(3)
puts "After appending 1, 2, 3: #{list.display}"

list.prepend(0)
puts "After prepending 0: #{list.display}"

list.insert_after(2, 2.5)
puts "After inserting 2.5 after 2: #{list.display}"

list.delete(2.5)
puts "After deleting 2.5: #{list.display}"

puts "Search for 2: #{list.search(2)}"
puts "Search for 99: #{list.search(99)}"
puts "Size: #{list.size}"
puts "Middle element: #{list.find_middle}"

list.reverse
puts "After reversing: #{list.display}"

# ========================================
# 4. DOUBLY LINKED LIST
# ========================================

class DoublyNode
  attr_accessor :data, :next, :prev

  def initialize(data)
    @data = data
    @next = nil
    @prev = nil
  end
end

class DoublyLinkedList
  attr_accessor :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  # Insert at beginning - O(1)
  def prepend(data)
    new_node = DoublyNode.new(data)

    if @head.nil?
      @head = new_node
      @tail = new_node
      return
    end

    new_node.next = @head
    @head.prev = new_node
    @head = new_node
  end

  # Insert at end - O(1)
  def append(data)
    new_node = DoublyNode.new(data)

    if @tail.nil?
      @head = new_node
      @tail = new_node
      return
    end

    @tail.next = new_node
    new_node.prev = @tail
    @tail = new_node
  end

  # Delete a node - O(n)
  def delete(data)
    return if @head.nil?

    current = @head

    while current
      if current.data == data
        # Update previous node
        if current.prev
          current.prev.next = current.next
        else
          @head = current.next
        end

        # Update next node
        if current.next
          current.next.prev = current.prev
        else
          @tail = current.prev
        end

        return
      end
      current = current.next
    end
  end

  # Display forward
  def display_forward
    return "Empty list" if @head.nil?

    result = []
    current = @head
    while current
      result << current.data
      current = current.next
    end
    result.join(" <-> ")
  end

  # Display backward
  def display_backward
    return "Empty list" if @tail.nil?

    result = []
    current = @tail
    while current
      result << current.data
      current = current.prev
    end
    result.join(" <-> ")
  end
end

# ========================================
# 5. TESTING DOUBLY LINKED LIST
# ========================================

puts "\n5. Doubly Linked List Operations:"

dll = DoublyLinkedList.new
dll.append(1)
dll.append(2)
dll.append(3)
puts "After appending 1, 2, 3: #{dll.display_forward}"

dll.prepend(0)
puts "After prepending 0: #{dll.display_forward}"
puts "Display backward: #{dll.display_backward}"

dll.delete(2)
puts "After deleting 2: #{dll.display_forward}"

# ========================================
# 6. CIRCULAR LINKED LIST
# ========================================

class CircularLinkedList
  attr_accessor :head

  def initialize
    @head = nil
  end

  def append(data)
    new_node = Node.new(data)

    if @head.nil?
      @head = new_node
      new_node.next = @head
      return
    end

    current = @head
    current = current.next while current.next != @head
    current.next = new_node
    new_node.next = @head
  end

  def display(limit = 10)
    return "Empty list" if @head.nil?

    result = []
    current = @head
    count = 0

    loop do
      result << current.data
      current = current.next
      count += 1
      break if current == @head || count >= limit
    end

    result.join(" -> ") + " -> [circular]"
  end
end

# ========================================
# 7. TESTING CIRCULAR LINKED LIST
# ========================================

puts "\n7. Circular Linked List Operations:"

cll = CircularLinkedList.new
cll.append(1)
cll.append(2)
cll.append(3)
puts "Circular list: #{cll.display}"

# ========================================
# 8. PRACTICAL PROBLEMS
# ========================================

puts "\n8. Practical Problems:"

# Problem 1: Merge two sorted linked lists
def merge_sorted_lists(l1, l2)
  dummy = Node.new(0)
  current = dummy

  while l1 && l2
    if l1.data <= l2.data
      current.next = l1
      l1 = l1.next
    else
      current.next = l2
      l2 = l2.next
    end
    current = current.next
  end

  current.next = l1 || l2
  dummy.next
end

# Create test lists
list1 = LinkedList.new
[1, 3, 5].each { |n| list1.append(n) }

list2 = LinkedList.new
[2, 4, 6].each { |n| list2.append(n) }

merged = merge_sorted_lists(list1.head, list2.head)
result = []
while merged
  result << merged.data
  merged = merged.next
end
puts "Merged sorted lists: #{result.join(' -> ')}"

# Problem 2: Remove nth node from end
def remove_nth_from_end(head, n)
  dummy = Node.new(0)
  dummy.next = head
  fast = slow = dummy

  # Move fast n+1 steps ahead
  (n + 1).times { fast = fast.next }

  # Move both until fast reaches end
  while fast
    fast = fast.next
    slow = slow.next
  end

  # Remove the node
  slow.next = slow.next.next
  dummy.next
end

list = LinkedList.new
[1, 2, 3, 4, 5].each { |n| list.append(n) }
puts "Original list: #{list.display}"

list.head = remove_nth_from_end(list.head, 2)
puts "After removing 2nd from end: #{list.display}"

# Problem 3: Palindrome check
def is_palindrome?(head)
  return true if head.nil? || head.next.nil?

  # Find middle
  slow = fast = head
  while fast && fast.next
    slow = slow.next
    fast = fast.next.next
  end

  # Reverse second half
  prev = nil
  while slow
    next_node = slow.next
    slow.next = prev
    prev = slow
    slow = next_node
  end

  # Compare
  left = head
  right = prev
  while right
    return false if left.data != right.data
    left = left.next
    right = right.next
  end

  true
end

palindrome_list = LinkedList.new
[1, 2, 3, 2, 1].each { |n| palindrome_list.append(n) }
puts "Is [1,2,3,2,1] palindrome? #{is_palindrome?(palindrome_list.head)}"

# ========================================
# TIME COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY ANALYSIS"
puts "=" * 50
puts "Access:               O(n)"
puts "Search:               O(n)"
puts "Insert at beginning:  O(1)"
puts "Insert at end:        O(n) for singly, O(1) for doubly"
puts "Delete:               O(n)"
puts "Space complexity:     O(n)"
puts "=" * 50

# ========================================
# PRACTICE PROBLEMS
# ========================================

puts "\nPRACTICE PROBLEMS:"
puts "1. Detect and remove cycle in linked list"
puts "2. Find intersection point of two linked lists"
puts "3. Sort a linked list using merge sort"
puts "4. Rotate linked list by k positions"
puts "5. Flatten a multilevel doubly linked list"
puts "6. Add two numbers represented by linked lists"
puts "7. Clone a linked list with random pointers"
puts "8. Reverse linked list in groups of k"
puts "9. Find the starting point of a cycle"
puts "10. Implement LRU cache using doubly linked list and hash"
