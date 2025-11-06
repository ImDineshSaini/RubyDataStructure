# ========================================
# BINARY SEARCH TREES (BST) IN RUBY
# ========================================
# A binary tree where left child < parent < right child
# Enables efficient searching, insertion, and deletion

puts "=" * 50
puts "BINARY SEARCH TREES"
puts "=" * 50

# ========================================
# 1. BST NODE AND BASIC STRUCTURE
# ========================================

class BSTNode
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class BinarySearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  # ========================================
  # INSERTION
  # ========================================

  def insert(value)
    @root = insert_recursive(@root, value)
  end

  private def insert_recursive(node, value)
    return BSTNode.new(value) if node.nil?

    if value < node.value
      node.left = insert_recursive(node.left, value)
    elsif value > node.value
      node.right = insert_recursive(node.right, value)
    end
    # If equal, don't insert (no duplicates)

    node
  end

  # Iterative insertion
  def insert_iterative(value)
    new_node = BSTNode.new(value)

    if @root.nil?
      @root = new_node
      return
    end

    current = @root
    loop do
      if value < current.value
        if current.left.nil?
          current.left = new_node
          break
        end
        current = current.left
      elsif value > current.value
        if current.right.nil?
          current.right = new_node
          break
        end
        current = current.right
      else
        break  # Duplicate, don't insert
      end
    end
  end

  # ========================================
  # SEARCH
  # ========================================

  def search(value)
    search_recursive(@root, value)
  end

  private def search_recursive(node, value)
    return false if node.nil?
    return true if node.value == value

    if value < node.value
      search_recursive(node.left, value)
    else
      search_recursive(node.right, value)
    end
  end

  def search_iterative(value)
    current = @root

    while current
      return true if current.value == value

      current = value < current.value ? current.left : current.right
    end

    false
  end

  # ========================================
  # DELETION
  # ========================================

  def delete(value)
    @root = delete_recursive(@root, value)
  end

  private def delete_recursive(node, value)
    return nil if node.nil?

    if value < node.value
      node.left = delete_recursive(node.left, value)
    elsif value > node.value
      node.right = delete_recursive(node.right, value)
    else
      # Node to be deleted found

      # Case 1: No children (leaf node)
      return nil if node.left.nil? && node.right.nil?

      # Case 2: One child
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      # Case 3: Two children
      # Find inorder successor (smallest in right subtree)
      min_node = find_min(node.right)
      node.value = min_node.value
      node.right = delete_recursive(node.right, min_node.value)
    end

    node
  end

  private def find_min(node)
    current = node
    current = current.left while current.left
    current
  end

  private def find_max(node)
    current = node
    current = current.right while current.right
    current
  end

  # ========================================
  # TRAVERSALS
  # ========================================

  def inorder(node = @root, result = [])
    return result if node.nil?

    inorder(node.left, result)
    result << node.value
    inorder(node.right, result)
    result
  end

  def preorder(node = @root, result = [])
    return result if node.nil?

    result << node.value
    preorder(node.left, result)
    preorder(node.right, result)
    result
  end

  def postorder(node = @root, result = [])
    return result if node.nil?

    postorder(node.left, result)
    postorder(node.right, result)
    result << node.value
    result
  end

  # ========================================
  # PROPERTIES
  # ========================================

  def height(node = @root)
    return -1 if node.nil?

    [height(node.left), height(node.right)].max + 1
  end

  def size(node = @root)
    return 0 if node.nil?

    1 + size(node.left) + size(node.right)
  end

  def is_valid_bst?(node = @root, min = -Float::INFINITY, max = Float::INFINITY)
    return true if node.nil?
    return false if node.value <= min || node.value >= max

    is_valid_bst?(node.left, min, node.value) &&
      is_valid_bst?(node.right, node.value, max)
  end

  # ========================================
  # ADDITIONAL OPERATIONS
  # ========================================

  def find_kth_smallest(k)
    count = [0]
    result = [nil]
    find_kth_smallest_helper(@root, k, count, result)
    result[0]
  end

  private def find_kth_smallest_helper(node, k, count, result)
    return if node.nil? || count[0] >= k

    find_kth_smallest_helper(node.left, k, count, result)

    count[0] += 1
    if count[0] == k
      result[0] = node.value
      return
    end

    find_kth_smallest_helper(node.right, k, count, result)
  end

  def range_query(low, high)
    result = []
    range_query_helper(@root, low, high, result)
    result
  end

  private def range_query_helper(node, low, high, result)
    return if node.nil?

    range_query_helper(node.left, low, high, result) if node.value > low
    result << node.value if node.value >= low && node.value <= high
    range_query_helper(node.right, low, high, result) if node.value < high
  end

  def lowest_common_ancestor(value1, value2)
    lca_helper(@root, value1, value2)&.value
  end

  private def lca_helper(node, value1, value2)
    return nil if node.nil?

    if value1 < node.value && value2 < node.value
      lca_helper(node.left, value1, value2)
    elsif value1 > node.value && value2 > node.value
      lca_helper(node.right, value1, value2)
    else
      node
    end
  end

  # ========================================
  # DISPLAY
  # ========================================

  def display
    display_helper(@root, "", true)
  end

  private def display_helper(node, prefix, is_tail)
    return if node.nil?

    puts "#{prefix}#{is_tail ? '└── ' : '├── '}#{node.value}"

    children = [node.left, node.right].compact
    children.each_with_index do |child, index|
      extension = is_tail ? '    ' : '│   '
      display_helper(child, prefix + extension, index == children.length - 1)
    end
  end
end

# ========================================
# 2. TESTING BST OPERATIONS
# ========================================

puts "\n2. BST Operations:"

bst = BinarySearchTree.new

# Insert elements
[50, 30, 70, 20, 40, 60, 80].each { |val| bst.insert(val) }

puts "Tree structure:"
bst.display

puts "\nTraversals:"
puts "Inorder (sorted):   #{bst.inorder}"
puts "Preorder:           #{bst.preorder}"
puts "Postorder:          #{bst.postorder}"

puts "\nProperties:"
puts "Height: #{bst.height}"
puts "Size: #{bst.size}"
puts "Is valid BST? #{bst.is_valid_bst?}"

puts "\nSearch operations:"
puts "Search 40: #{bst.search(40)}"
puts "Search 45: #{bst.search(45)}"

puts "\nKth smallest:"
puts "3rd smallest: #{bst.find_kth_smallest(3)}"

puts "\nRange query [35, 65]:"
puts bst.range_query(35, 65).inspect

puts "\nLowest Common Ancestor:"
puts "LCA(20, 40) = #{bst.lowest_common_ancestor(20, 40)}"
puts "LCA(60, 80) = #{bst.lowest_common_ancestor(60, 80)}"

puts "\nDeletion:"
bst.delete(20)
puts "After deleting 20: #{bst.inorder}"

bst.delete(30)
puts "After deleting 30: #{bst.inorder}"

bst.delete(50)
puts "After deleting 50: #{bst.inorder}"

# ========================================
# 3. BALANCED BST CHECK
# ========================================

def is_balanced?(node)
  check_height(node) != -1
end

def check_height(node)
  return 0 if node.nil?

  left_height = check_height(node.left)
  return -1 if left_height == -1

  right_height = check_height(node.right)
  return -1 if right_height == -1

  return -1 if (left_height - right_height).abs > 1

  [left_height, right_height].max + 1
end

puts "\n3. Balance Check:"
puts "Is balanced? #{is_balanced?(bst.root)}"

# ========================================
# 4. CONVERT SORTED ARRAY TO BST
# ========================================

def sorted_array_to_bst(arr)
  return nil if arr.empty?

  mid = arr.length / 2
  node = BSTNode.new(arr[mid])

  node.left = sorted_array_to_bst(arr[0...mid])
  node.right = sorted_array_to_bst(arr[(mid + 1)..-1])

  node
end

puts "\n4. Convert Sorted Array to Balanced BST:"
sorted_arr = [1, 2, 3, 4, 5, 6, 7]
balanced_bst = BinarySearchTree.new
balanced_bst.root = sorted_array_to_bst(sorted_arr)

puts "Balanced BST from #{sorted_arr}:"
balanced_bst.display
puts "Height: #{balanced_bst.height}"
puts "Is balanced? #{is_balanced?(balanced_bst.root)}"

# ========================================
# 5. PRACTICAL APPLICATIONS
# ========================================

puts "\n5. Practical Applications:"

# Application 1: Dictionary/Autocomplete
class Dictionary
  def initialize
    @bst = BinarySearchTree.new
  end

  def add_word(word)
    @bst.insert(word)
  end

  def search_word(word)
    @bst.search(word)
  end

  def words_in_range(start_word, end_word)
    @bst.range_query(start_word, end_word)
  end
end

dict = Dictionary.new
%w[apple banana cherry date elderberry fig grape].each { |word| dict.add_word(word) }
puts "Words from 'cherry' to 'grape': #{dict.words_in_range('cherry', 'grape')}"

# Application 2: Student Records
class StudentRecord
  attr_accessor :id, :name, :grade

  def initialize(id, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def <=>(other)
    @id <=> other.id
  end

  def to_s
    "Student[#{@id}: #{@name}, Grade: #{@grade}]"
  end
end

# Custom BST for objects
class StudentBST < BinarySearchTree
  def insert_student(student)
    @root = insert_student_helper(@root, student)
  end

  private def insert_student_helper(node, student)
    return BSTNode.new(student) if node.nil?

    if student.id < node.value.id
      node.left = insert_student_helper(node.left, student)
    elsif student.id > node.value.id
      node.right = insert_student_helper(node.right, student)
    end

    node
  end

  def find_student(id)
    find_student_helper(@root, id)
  end

  private def find_student_helper(node, id)
    return nil if node.nil?
    return node.value if node.value.id == id

    if id < node.value.id
      find_student_helper(node.left, id)
    else
      find_student_helper(node.right, id)
    end
  end
end

student_bst = StudentBST.new
student_bst.insert_student(StudentRecord.new(50, "Alice", 85))
student_bst.insert_student(StudentRecord.new(30, "Bob", 90))
student_bst.insert_student(StudentRecord.new(70, "Charlie", 78))

found = student_bst.find_student(30)
puts "\nFound student: #{found}"

# ========================================
# TIME COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY ANALYSIS"
puts "=" * 50
puts "Average Case (Balanced):"
puts "  Search:             O(log n)"
puts "  Insert:             O(log n)"
puts "  Delete:             O(log n)"
puts "  Find Min/Max:       O(log n)"
puts "  Inorder Traversal:  O(n)"
puts "\nWorst Case (Skewed):"
puts "  Search:             O(n)"
puts "  Insert:             O(n)"
puts "  Delete:             O(n)"
puts "\nSpace Complexity:"
puts "  Storage:            O(n)"
puts "  Recursion Stack:    O(h) where h is height"
puts "=" * 50

# ========================================
# PRACTICE PROBLEMS
# ========================================

puts "\nPRACTICE PROBLEMS:"
puts "1. Find kth largest element in BST"
puts "2. Check if two BSTs are identical"
puts "3. Find inorder successor/predecessor"
puts "4. Convert BST to sorted doubly linked list"
puts "5. Find distance between two nodes"
puts "6. Serialize and deserialize BST"
puts "7. Find mode (most frequent) in BST"
puts "8. Trim BST within given range"
puts "9. Count nodes in given range"
puts "10. Build BST from preorder traversal"
