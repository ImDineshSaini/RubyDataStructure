# ========================================
# STACKS IN RUBY
# ========================================
# A stack is a LIFO (Last In, First Out) data structure.
# Elements are added and removed from the same end (top).

puts "=" * 50
puts "STACKS IN RUBY"
puts "=" * 50

# ========================================
# 1. STACK USING ARRAY
# ========================================

class Stack
  def initialize
    @items = []
  end

  # Push element - O(1)
  def push(item)
    @items.push(item)
  end

  # Pop element - O(1)
  def pop
    @items.pop
  end

  # Peek at top element - O(1)
  def peek
    @items.last
  end

  # Check if empty - O(1)
  def empty?
    @items.empty?
  end

  # Get size - O(1)
  def size
    @items.length
  end

  # Clear stack - O(1)
  def clear
    @items.clear
  end

  # Display stack
  def display
    "Bottom [#{@items.join(', ')}] Top"
  end

  # Convert to array
  def to_a
    @items.dup
  end
end

# ========================================
# 2. BASIC OPERATIONS
# ========================================

puts "\n2. Basic Stack Operations:"

stack = Stack.new
puts "Initial stack: #{stack.display}"
puts "Is empty? #{stack.empty?}"

stack.push(10)
stack.push(20)
stack.push(30)
puts "After pushing 10, 20, 30: #{stack.display}"

puts "Top element (peek): #{stack.peek}"
puts "Size: #{stack.size}"

popped = stack.pop
puts "Popped element: #{popped}"
puts "After pop: #{stack.display}"

# ========================================
# 3. STACK USING LINKED LIST
# ========================================

class Node
  attr_accessor :data, :next

  def initialize(data)
    @data = data
    @next = nil
  end
end

class LinkedStack
  def initialize
    @top = nil
    @size = 0
  end

  # Push - O(1)
  def push(data)
    new_node = Node.new(data)
    new_node.next = @top
    @top = new_node
    @size += 1
  end

  # Pop - O(1)
  def pop
    return nil if @top.nil?

    data = @top.data
    @top = @top.next
    @size -= 1
    data
  end

  # Peek - O(1)
  def peek
    @top&.data
  end

  # Empty? - O(1)
  def empty?
    @top.nil?
  end

  # Size - O(1)
  def size
    @size
  end

  # Display
  def display
    return "Empty stack" if @top.nil?

    result = []
    current = @top
    while current
      result << current.data
      current = current.next
    end
    "Top [#{result.join(', ')}] Bottom"
  end
end

# ========================================
# 4. TESTING LINKED STACK
# ========================================

puts "\n4. Stack Using Linked List:"

linked_stack = LinkedStack.new
linked_stack.push('A')
linked_stack.push('B')
linked_stack.push('C')
puts "After pushing A, B, C: #{linked_stack.display}"

puts "Popped: #{linked_stack.pop}"
puts "After pop: #{linked_stack.display}"

# ========================================
# 5. MIN STACK (Get minimum in O(1))
# ========================================

class MinStack
  def initialize
    @stack = []
    @min_stack = []
  end

  def push(val)
    @stack.push(val)
    if @min_stack.empty? || val <= @min_stack.last
      @min_stack.push(val)
    end
  end

  def pop
    val = @stack.pop
    @min_stack.pop if val == @min_stack.last
    val
  end

  def top
    @stack.last
  end

  def get_min
    @min_stack.last
  end

  def display
    "Stack: #{@stack}, Min: #{get_min}"
  end
end

# ========================================
# 6. TESTING MIN STACK
# ========================================

puts "\n6. Min Stack (O(1) minimum retrieval):"

min_stack = MinStack.new
min_stack.push(5)
min_stack.push(2)
min_stack.push(7)
min_stack.push(1)
puts "After pushing 5, 2, 7, 1: #{min_stack.display}"

min_stack.pop
puts "After popping: #{min_stack.display}"

# ========================================
# 7. PRACTICAL APPLICATIONS
# ========================================

puts "\n7. Practical Applications:"

# Application 1: Balanced Parentheses
def balanced_parentheses?(str)
  stack = []
  pairs = { '(' => ')', '[' => ']', '{' => '}' }

  str.each_char do |char|
    if pairs.key?(char)
      stack.push(char)
    elsif pairs.value?(char)
      return false if stack.empty? || pairs[stack.pop] != char
    end
  end

  stack.empty?
end

test_cases = ['()', '()[]{}', '(]', '([)]', '{[()]}']
test_cases.each do |test|
  puts "Is '#{test}' balanced? #{balanced_parentheses?(test)}"
end

# Application 2: Evaluate Postfix Expression
def evaluate_postfix(expression)
  stack = []
  operators = %w[+ - * /]

  expression.split.each do |token|
    if operators.include?(token)
      b = stack.pop
      a = stack.pop
      result = case token
               when '+' then a + b
               when '-' then a - b
               when '*' then a * b
               when '/' then a / b
               end
      stack.push(result)
    else
      stack.push(token.to_i)
    end
  end

  stack.pop
end

puts "\nPostfix '2 3 + 4 *' = #{evaluate_postfix('2 3 + 4 *')}"  # (2+3)*4 = 20

# Application 3: Infix to Postfix Conversion
def infix_to_postfix(expression)
  stack = []
  output = []
  precedence = { '+' => 1, '-' => 1, '*' => 2, '/' => 2, '^' => 3 }

  expression.split.each do |token|
    if token =~ /\d+/
      output << token
    elsif token == '('
      stack.push(token)
    elsif token == ')'
      until stack.empty? || stack.last == '('
        output << stack.pop
      end
      stack.pop  # Remove '('
    elsif precedence.key?(token)
      while !stack.empty? && stack.last != '(' &&
            precedence[stack.last] && precedence[stack.last] >= precedence[token]
        output << stack.pop
      end
      stack.push(token)
    end
  end

  output.concat(stack.reverse)
  output.join(' ')
end

puts "Infix '3 + 4 * 2' to Postfix: #{infix_to_postfix('3 + 4 * 2')}"

# Application 4: Reverse String
def reverse_string(str)
  stack = Stack.new
  str.each_char { |char| stack.push(char) }

  result = ''
  result += stack.pop until stack.empty?
  result
end

puts "Reverse 'Hello': #{reverse_string('Hello')}"

# Application 5: Next Greater Element
def next_greater_element(arr)
  stack = []
  result = Array.new(arr.length, -1)

  arr.each_with_index do |num, i|
    while !stack.empty? && arr[stack.last] < num
      idx = stack.pop
      result[idx] = num
    end
    stack.push(i)
  end

  result
end

arr = [4, 5, 2, 10, 8]
puts "Next greater elements for #{arr}: #{next_greater_element(arr)}"

# Application 6: Valid Parentheses Sequence
def generate_parentheses(n)
  result = []

  def backtrack(result, current, open, close, max)
    if current.length == max * 2
      result << current
      return
    end

    backtrack(result, current + '(', open + 1, close, max) if open < max
    backtrack(result, current + ')', open, close + 1, max) if close < open
  end

  backtrack(result, '', 0, 0, n)
  result
end

puts "Valid parentheses for n=3: #{generate_parentheses(3)}"

# Application 7: Simplify Path (Unix-style)
def simplify_path(path)
  stack = []
  parts = path.split('/')

  parts.each do |part|
    next if part.empty? || part == '.'

    if part == '..'
      stack.pop unless stack.empty?
    else
      stack.push(part)
    end
  end

  '/' + stack.join('/')
end

puts "Simplify '/home//foo/../bar': #{simplify_path('/home//foo/../bar')}"

# Application 8: Decode String
def decode_string(s)
  stack = []

  s.each_char do |char|
    if char != ']'
      stack.push(char)
    else
      # Get the encoded string
      str = ''
      str = stack.pop + str while stack.last != '['
      stack.pop  # Remove '['

      # Get the number
      num_str = ''
      num_str = stack.pop + num_str while !stack.empty? && stack.last =~ /\d/
      num = num_str.to_i

      # Push decoded string
      stack.push(str * num)
    end
  end

  stack.join
end

puts "Decode '3[a2[c]]': #{decode_string('3[a2[c]]')}"  # accaccacc

# Application 9: Daily Temperatures
def daily_temperatures(temperatures)
  stack = []
  result = Array.new(temperatures.length, 0)

  temperatures.each_with_index do |temp, i|
    while !stack.empty? && temperatures[stack.last] < temp
      idx = stack.pop
      result[idx] = i - idx
    end
    stack.push(i)
  end

  result
end

temps = [73, 74, 75, 71, 69, 72, 76, 73]
puts "Days until warmer for #{temps}:"
puts "#{daily_temperatures(temps)}"

# Application 10: Largest Rectangle in Histogram
def largest_rectangle_area(heights)
  stack = []
  max_area = 0
  heights.each_with_index do |h, i|
    while !stack.empty? && heights[stack.last] > h
      height_idx = stack.pop
      width = stack.empty? ? i : i - stack.last - 1
      area = heights[height_idx] * width
      max_area = [max_area, area].max
    end
    stack.push(i)
  end

  while !stack.empty?
    height_idx = stack.pop
    width = stack.empty? ? heights.length : heights.length - stack.last - 1
    area = heights[height_idx] * width
    max_area = [max_area, area].max
  end

  max_area
end

histogram = [2, 1, 5, 6, 2, 3]
puts "Largest rectangle in histogram #{histogram}: #{largest_rectangle_area(histogram)}"

# ========================================
# TIME COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY ANALYSIS"
puts "=" * 50
puts "Push:                 O(1)"
puts "Pop:                  O(1)"
puts "Peek:                 O(1)"
puts "Search:               O(n)"
puts "Space complexity:     O(n)"
puts "=" * 50

# ========================================
# PRACTICE PROBLEMS
# ========================================

puts "\nPRACTICE PROBLEMS:"
puts "1. Implement a stack that supports getMax() in O(1)"
puts "2. Sort a stack using only stack operations"
puts "3. Implement two stacks using one array"
puts "4. Check if given postfix expression is valid"
puts "5. Remove adjacent duplicates using stack"
puts "6. Implement browser back/forward using stacks"
puts "7. Evaluate arithmetic expression with precedence"
puts "8. Find the celebrity using stack"
puts "9. Implement a stack with O(1) getMiddle() operation"
puts "10. Reverse a stack using recursion"
