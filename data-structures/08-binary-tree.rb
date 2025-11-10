# ========================================
# BINARY TREES IN RUBY
# ========================================
# A binary tree is a hierarchical data structure where each node
# has at most two children (left and right).

puts "=" * 50
puts "BINARY TREES IN RUBY"
puts "=" * 50

# ========================================
# 1. TREE NODE CLASS
# ========================================

class TreeNode
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

# ========================================
# 2. BINARY TREE CLASS
# ========================================

class BinaryTree
  attr_accessor :root

  def initialize(value = nil)
    @root = value ? TreeNode.new(value) : nil
  end

  # ========================================
  # TREE TRAVERSALS
  # ========================================

  # Inorder: Left -> Root -> Right
  def inorder(node = @root, result = [])
    return result if node.nil?

    inorder(node.left, result)
    result << node.value
    inorder(node.right, result)
    result
  end

  # Preorder: Root -> Left -> Right
  def preorder(node = @root, result = [])
    return result if node.nil?

    result << node.value
    preorder(node.left, result)
    preorder(node.right, result)
    result
  end

  # Postorder: Left -> Right -> Root
  def postorder(node = @root, result = [])
    return result if node.nil?

    postorder(node.left, result)
    postorder(node.right, result)
    result << node.value
    result
  end

  # Level Order (Breadth-First)
  def level_order(node = @root)
    return [] if node.nil?

    result = []
    queue = [node]

    until queue.empty?
      current = queue.shift
      result << current.value

      queue << current.left if current.left
      queue << current.right if current.right
    end

    result
  end

  # ========================================
  # TREE PROPERTIES
  # ========================================

  # Height of tree
  def height(node = @root)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    [left_height, right_height].max + 1
  end

  # Count nodes
  def count_nodes(node = @root)
    return 0 if node.nil?

    1 + count_nodes(node.left) + count_nodes(node.right)
  end

  # Count leaf nodes
  def count_leaves(node = @root)
    return 0 if node.nil?
    return 1 if node.left.nil? && node.right.nil?

    count_leaves(node.left) + count_leaves(node.right)
  end

  # Check if tree is balanced
  def balanced?(node = @root)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    return false if (left_height - right_height).abs > 1

    balanced?(node.left) && balanced?(node.right)
  end

  # Check if tree is full (every node has 0 or 2 children)
  def full?(node = @root)
    return true if node.nil?
    return true if node.left.nil? && node.right.nil?
    return false if node.left.nil? || node.right.nil?

    full?(node.left) && full?(node.right)
  end

  # Check if tree is complete
  def complete?
    return true if @root.nil?

    queue = [[@root, 0]]
    prev_index = -1

    until queue.empty?
      node, index = queue.shift
      return false if index != prev_index + 1

      queue << [node.left, 2 * index + 1] if node.left
      queue << [node.right, 2 * index + 2] if node.right

      prev_index = index
    end

    true
  end

  # ========================================
  # SEARCH OPERATIONS
  # ========================================

  # Search for a value
  def search(value, node = @root)
    return false if node.nil?
    return true if node.value == value

    search(value, node.left) || search(value, node.right)
  end

  # Find path to a node
  def find_path(value, node = @root, path = [])
    return nil if node.nil?

    path << node.value

    return path if node.value == value

    left_path = find_path(value, node.left, path.dup)
    return left_path if left_path

    right_path = find_path(value, node.right, path.dup)
    return right_path if right_path

    nil
  end

  # ========================================
  # ADVANCED OPERATIONS
  # ========================================

  # Mirror/Invert tree
  def mirror(node = @root)
    return if node.nil?

    node.left, node.right = node.right, node.left
    mirror(node.left)
    mirror(node.right)
  end

  # Lowest Common Ancestor
  def lca(node, n1, n2)
    return nil if node.nil?
    return node if node.value == n1 || node.value == n2

    left_lca = lca(node.left, n1, n2)
    right_lca = lca(node.right, n1, n2)

    return node if left_lca && right_lca
    return left_lca || right_lca
  end

  # Maximum path sum
  def max_path_sum(node = @root)
    @max_sum = -Float::INFINITY
    max_path_sum_helper(node)
    @max_sum
  end

  private

  def max_path_sum_helper(node)
    return 0 if node.nil?

    left_sum = [max_path_sum_helper(node.left), 0].max
    right_sum = [max_path_sum_helper(node.right), 0].max

    current_sum = node.value + left_sum + right_sum
    @max_sum = [current_sum, @max_sum].max

    node.value + [left_sum, right_sum].max
  end
end

# ========================================
# 3. BUILDING AND TESTING BINARY TREE
# ========================================

puts "\n3. Building Binary Tree:"
puts "Creating tree:"
puts "       1"
puts "      / \\"
puts "     2   3"
puts "    / \\   \\"
puts "   4   5   6"

tree = BinaryTree.new(1)
tree.root.left = TreeNode.new(2)
tree.root.right = TreeNode.new(3)
tree.root.left.left = TreeNode.new(4)
tree.root.left.right = TreeNode.new(5)
tree.root.right.right = TreeNode.new(6)

puts "\nTraversals:"
puts "Inorder:     #{tree.inorder}"
puts "Preorder:    #{tree.preorder}"
puts "Postorder:   #{tree.postorder}"
puts "Level Order: #{tree.level_order}"

puts "\nTree Properties:"
puts "Height:       #{tree.height}"
puts "Node count:   #{tree.count_nodes}"
puts "Leaf count:   #{tree.count_leaves}"
puts "Is balanced?  #{tree.balanced?}"
puts "Is full?      #{tree.full?}"
puts "Is complete?  #{tree.complete?}"

puts "\nSearch Operations:"
puts "Search 5:     #{tree.search(5)}"
puts "Search 99:    #{tree.search(99)}"
puts "Path to 5:    #{tree.find_path(5)}"

# ========================================
# 4. ITERATIVE TRAVERSALS
# ========================================

class BinaryTree
  # Iterative Inorder
  def inorder_iterative
    return [] if @root.nil?

    result = []
    stack = []
    current = @root

    while current || !stack.empty?
      while current
        stack.push(current)
        current = current.left
      end

      current = stack.pop
      result << current.value
      current = current.right
    end

    result
  end

  # Iterative Preorder
  def preorder_iterative
    return [] if @root.nil?

    result = []
    stack = [@root]

    until stack.empty?
      current = stack.pop
      result << current.value

      stack.push(current.right) if current.right
      stack.push(current.left) if current.left
    end

    result
  end

  # Iterative Postorder
  def postorder_iterative
    return [] if @root.nil?

    result = []
    stack = [@root]

    until stack.empty?
      current = stack.pop
      result.unshift(current.value)

      stack.push(current.left) if current.left
      stack.push(current.right) if current.right
    end

    result
  end
end

puts "\n4. Iterative Traversals:"
puts "Inorder (iterative):  #{tree.inorder_iterative}"
puts "Preorder (iterative): #{tree.preorder_iterative}"
puts "Postorder (iterative): #{tree.postorder_iterative}"

# ========================================
# 5. PRACTICAL PROBLEMS
# ========================================

puts "\n5. Practical Problems:"

# Problem 1: Diameter of tree
def diameter(node)
  @diameter = 0

  def height_for_diameter(node)
    return 0 if node.nil?

    left = height_for_diameter(node.left)
    right = height_for_diameter(node.right)

    @diameter = [@diameter, left + right].max

    [left, right].max + 1
  end

  height_for_diameter(node)
  @diameter
end

puts "Diameter of tree: #{diameter(tree.root)}"

# Problem 2: Level order with levels separated
def level_order_with_levels(root)
  return [] if root.nil?

  result = []
  queue = [root]

  until queue.empty?
    level_size = queue.size
    level = []

    level_size.times do
      node = queue.shift
      level << node.value

      queue << node.left if node.left
      queue << node.right if node.right
    end

    result << level
  end

  result
end

puts "Level order by levels: #{level_order_with_levels(tree.root)}"

# Problem 3: Zigzag level order
def zigzag_level_order(root)
  return [] if root.nil?

  result = []
  queue = [root]
  left_to_right = true

  until queue.empty?
    level_size = queue.size
    level = []

    level_size.times do
      node = queue.shift
      level << node.value

      queue << node.left if node.left
      queue << node.right if node.right
    end

    level.reverse! unless left_to_right
    result << level
    left_to_right = !left_to_right
  end

  result
end

puts "Zigzag level order: #{zigzag_level_order(tree.root)}"

# Problem 4: Vertical order traversal
def vertical_order(root)
  return [] if root.nil?

  column_table = Hash.new { |h, k| h[k] = [] }
  queue = [[root, 0]]  # [node, column]

  until queue.empty?
    node, column = queue.shift
    column_table[column] << node.value

    queue << [node.left, column - 1] if node.left
    queue << [node.right, column + 1] if node.right
  end

  column_table.sort.map { |_, values| values }
end

puts "Vertical order: #{vertical_order(tree.root)}"

# Problem 5: Serialize and Deserialize
def serialize(root)
  return '#' if root.nil?

  "#{root.value},#{serialize(root.left)},#{serialize(root.right)}"
end

def deserialize(data)
  values = data.split(',')

  def build_tree(values)
    val = values.shift
    return nil if val == '#'

    node = TreeNode.new(val.to_i)
    node.left = build_tree(values)
    node.right = build_tree(values)
    node
  end

  build_tree(values)
end

serialized = serialize(tree.root)
puts "Serialized tree: #{serialized}"

deserialized = deserialize(serialized)
puts "Deserialized (inorder): #{BinaryTree.new.tap { |t| t.root = deserialized }.inorder}"

# Problem 6: Right side view
def right_side_view(root)
  return [] if root.nil?

  result = []
  queue = [root]

  until queue.empty?
    level_size = queue.size

    level_size.times do |i|
      node = queue.shift
      result << node.value if i == level_size - 1

      queue << node.left if node.left
      queue << node.right if node.right
    end
  end

  result
end

puts "Right side view: #{right_side_view(tree.root)}"

# Problem 7: Boundary traversal
def boundary_traversal(root)
  return [] if root.nil?

  result = [root.value]

  # Left boundary (excluding leaves)
  def left_boundary(node, result)
    return if node.nil? || (node.left.nil? && node.right.nil?)

    result << node.value
    if node.left
      left_boundary(node.left, result)
    else
      left_boundary(node.right, result)
    end
  end

  # Leaves
  def leaves(node, result)
    return if node.nil?

    if node.left.nil? && node.right.nil?
      result << node.value
      return
    end

    leaves(node.left, result)
    leaves(node.right, result)
  end

  # Right boundary (excluding leaves, in reverse)
  def right_boundary(node, result)
    return if node.nil? || (node.left.nil? && node.right.nil?)

    if node.right
      right_boundary(node.right, result)
    else
      right_boundary(node.left, result)
    end
    result << node.value
  end

  left_boundary(root.left, result)
  leaves(root.left, result)
  leaves(root.right, result)
  right_boundary(root.right, result)

  result
end

puts "Boundary traversal: #{boundary_traversal(tree.root)}"

# ========================================
# TIME COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY ANALYSIS"
puts "=" * 50
puts "Traversal (any):      O(n)"
puts "Search:               O(n)"
puts "Insert:               O(n)"
puts "Delete:               O(n)"
puts "Height:               O(n)"
puts "Space (recursive):    O(h) where h is height"
puts "Space (iterative):    O(w) where w is max width"
puts "=" * 50

# ========================================
# PRACTICE PROBLEMS
# ========================================

puts "\nPRACTICE PROBLEMS:"
puts "1. Find maximum width of binary tree"
puts "2. Check if tree is symmetric"
puts "3. Convert binary tree to doubly linked list"
puts "4. Find all paths with given sum"
puts "5. Construct tree from inorder and preorder"
puts "6. Find kth smallest element in BST"
puts "7. Flatten binary tree to linked list"
puts "8. Count good nodes in binary tree"
puts "9. Populate next right pointers"
puts "10. Check if tree is subtree of another"
