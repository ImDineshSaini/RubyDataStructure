# ========================================
# BLOCKS, PROCS, AND LAMBDAS IN RUBY
# ========================================
# Understanding Ruby's closure mechanisms

puts "=" * 50
puts "BLOCKS, PROCS, AND LAMBDAS"
puts "=" * 50

# ========================================
# 1. BLOCKS - THE BASICS
# ========================================

puts "\n1. Blocks - Basic Usage:"

# Blocks are chunks of code between do...end or {...}
def greet
  puts "Before block"
  yield
  puts "After block"
end

puts "Calling with block:"
greet do
  puts "  Inside block"
end

# yield passes arguments to block
def greet_with_name
  yield("Alice")
  yield("Bob")
end

puts "\nBlock with arguments:"
greet_with_name do |name|
  puts "  Hello, #{name}!"
end

# Check if block given
def optional_block
  if block_given?
    puts "Block was given"
    yield
  else
    puts "No block given"
  end
end

puts "\nWith block:"
optional_block { puts "  I'm a block!" }

puts "\nWithout block:"
optional_block

# ========================================
# 2. BLOCKS WITH RETURN VALUES
# ========================================

puts "\n2. Blocks with Return Values:"

def calculate
  result = yield(5, 3)
  puts "Result: #{result}"
end

calculate { |a, b| a + b }  # 8
calculate { |a, b| a * b }  # 15

# Block return value example
def process_numbers(numbers)
  numbers.map do |n|
    yield(n)
  end
end

result = process_numbers([1, 2, 3]) { |n| n * 2 }
puts "Processed: #{result}"

# ========================================
# 3. BLOCKS FOR ITERATION
# ========================================

puts "\n3. Custom Iterator with Blocks:"

class Range5
  def initialize(start_val, end_val)
    @start = start_val
    @end = end_val
  end

  def each
    current = @start
    while current <= @end
      yield(current)
      current += 1
    end
  end
end

range = Range5.new(1, 5)
range.each { |num| puts "  Number: #{num}" }

# ========================================
# 4. PROCS - REUSABLE BLOCKS
# ========================================

puts "\n4. Procs - Reusable Blocks:"

# Create a Proc
square = Proc.new { |x| x * x }
cube = Proc.new { |x| x * x * x }

puts "Square of 5: #{square.call(5)}"
puts "Cube of 5: #{cube.call(5)}"

# Alternative syntax
multiply = proc { |a, b| a * b }
puts "Multiply 3 * 4: #{multiply.call(3, 4)}"

# Procs can be passed around
def apply_operation(numbers, operation)
  numbers.map { |n| operation.call(n) }
end

numbers = [1, 2, 3, 4, 5]
puts "Squared: #{apply_operation(numbers, square)}"
puts "Cubed: #{apply_operation(numbers, cube)}"

# ========================================
# 5. LAMBDAS - STRICT PROCS
# ========================================

puts "\n5. Lambdas:"

# Create lambda
double = lambda { |x| x * 2 }
triple = ->(x) { x * 3 }  # Stabby lambda syntax

puts "Double 5: #{double.call(5)}"
puts "Triple 5: #{triple.call(5)}"

# Lambda with multiple parameters
add = ->(a, b) { a + b }
puts "Add 3 + 7: #{add.call(3, 7)}"

# Alternative call syntax
puts "Alternative call: #{add[3, 7]}"
puts "Another way: #{add.(3, 7)}"

# ========================================
# 6. PROC VS LAMBDA DIFFERENCES
# ========================================

puts "\n6. Proc vs Lambda Differences:"

puts "\nDifference 1: Argument Strictness"

# Lambda is strict about arguments
my_lambda = lambda { |x, y| puts "x: #{x}, y: #{y}" }
my_proc = Proc.new { |x, y| puts "x: #{x}, y: #{y}" }

puts "Lambda with correct args:"
my_lambda.call(1, 2)

puts "Proc with wrong number of args (doesn't error):"
my_proc.call(1)  # Missing arg becomes nil

puts "\nDifference 2: Return Behavior"

def test_proc
  my_proc = Proc.new { return "Proc return" }
  my_proc.call
  "After proc"  # Never reached
end

def test_lambda
  my_lambda = lambda { return "Lambda return" }
  my_lambda.call
  "After lambda"  # This is reached
end

puts "Proc test: #{test_proc}"
puts "Lambda test: #{test_lambda}"

# ========================================
# 7. CLOSURES - CAPTURING SCOPE
# ========================================

puts "\n7. Closures:"

def multiplier(factor)
  lambda { |n| n * factor }
end

times_2 = multiplier(2)
times_5 = multiplier(5)

puts "5 * 2 = #{times_2.call(5)}"
puts "5 * 5 = #{times_5.call(5)}"

# Closures capture variables
def counter
  count = 0
  lambda { count += 1 }
end

counter1 = counter
counter2 = counter

puts "Counter1: #{counter1.call}"  # 1
puts "Counter1: #{counter1.call}"  # 2
puts "Counter1: #{counter1.call}"  # 3
puts "Counter2: #{counter2.call}"  # 1 (separate closure)

# ========================================
# 8. SYMBOL TO PROC
# ========================================

puts "\n8. Symbol to Proc (&:symbol):"

numbers = [1, 2, 3, 4, 5]

# Long form
puts "Doubled (long): #{numbers.map { |n| n * 2 }}"

# Using symbol to proc
strings = ['hello', 'world', 'ruby']
puts "Uppercase: #{strings.map(&:upcase)}"
puts "Lengths: #{strings.map(&:length)}"

# How it works:
# &:upcase is shorthand for { |s| s.upcase }

# Custom to_proc
class Symbol
  def custom_to_proc
    proc { |obj| obj.send(self) }
  end
end

# ========================================
# 9. PRACTICAL EXAMPLES
# ========================================

puts "\n9. Practical Examples:"

# Example 1: Custom each_with_index
class Array
  def my_each_with_index
    index = 0
    each do |element|
      yield(element, index)
      index += 1
    end
  end
end

puts "Custom each_with_index:"
['a', 'b', 'c'].my_each_with_index do |item, idx|
  puts "  #{idx}: #{item}"
end

# Example 2: Retry mechanism
def retry_on_failure(max_attempts = 3)
  attempts = 0
  begin
    attempts += 1
    puts "  Attempt #{attempts}"
    yield
  rescue StandardError => e
    if attempts < max_attempts
      puts "  Failed, retrying..."
      retry
    else
      puts "  Max attempts reached"
      raise e
    end
  end
end

puts "\nRetry mechanism:"
counter = 0
retry_on_failure(3) do
  counter += 1
  raise "Error!" if counter < 3
  puts "  Success!"
end

# Example 3: Benchmark
def benchmark
  start_time = Time.now
  yield
  end_time = Time.now
  puts "  Execution time: #{(end_time - start_time).round(4)}s"
end

puts "\nBenchmark example:"
benchmark do
  1000.times { "a" * 1000 }
end

# Example 4: Transaction wrapper
def transaction
  puts "  Starting transaction..."
  begin
    result = yield
    puts "  Committing..."
    result
  rescue StandardError => e
    puts "  Rolling back..."
    raise e
  end
end

puts "\nTransaction:"
transaction do
  puts "  Performing database operations..."
  "Success"
end

# Example 5: Memoization with lambda
class Fibonacci
  def initialize
    @memo = {}
    @calculator = lambda do |n|
      return n if n <= 1
      @memo[n] ||= @calculator.call(n - 1) + @calculator.call(n - 2)
    end
  end

  def calculate(n)
    @calculator.call(n)
  end
end

puts "\nFibonacci with memoization:"
fib = Fibonacci.new
puts "Fib(10) = #{fib.calculate(10)}"
puts "Fib(20) = #{fib.calculate(20)}"

# ========================================
# 10. HIGHER-ORDER FUNCTIONS
# ========================================

puts "\n10. Higher-Order Functions:"

# Functions that take functions as arguments
def compose(f, g)
  lambda { |x| f.call(g.call(x)) }
end

add_one = ->(x) { x + 1 }
multiply_by_two = ->(x) { x * 2 }

# Compose: first multiply by 2, then add 1
composed = compose(add_one, multiply_by_two)
puts "Composed(5): #{composed.call(5)}"  # (5 * 2) + 1 = 11

# Curry
def curry(f, *first_args)
  lambda do |*rest_args|
    f.call(*first_args, *rest_args)
  end
end

multiply = ->(x, y) { x * y }
double_fn = curry(multiply, 2)
puts "Curried double(5): #{double_fn.call(5)}"

# ========================================
# 11. BLOCKS FOR RESOURCE MANAGEMENT
# ========================================

puts "\n11. Resource Management with Blocks:"

class FileHandler
  def self.open(filename)
    file = new(filename)
    if block_given?
      begin
        yield(file)
      ensure
        file.close
      end
    else
      file
    end
  end

  def initialize(filename)
    @filename = filename
    puts "  Opening #{@filename}"
  end

  def read
    "Content of #{@filename}"
  end

  def close
    puts "  Closing #{@filename}"
  end
end

puts "File handling with block:"
FileHandler.open("data.txt") do |file|
  puts "  Reading: #{file.read}"
end
puts "  File automatically closed"

# ========================================
# 12. BLOCK BINDING AND SCOPE
# ========================================

puts "\n12. Block Binding and Scope:"

x = 10

puts "Outer x: #{x}"

5.times do |i|
  x = i  # Modifies outer x
  y = i * 2  # Local to block
end

puts "After block, x: #{x}"
# puts y  # Error: y is not defined outside block

# Binding object
def show_binding
  x = 100
  yield
end

puts "\nAccessing binding:"
show_binding do
  puts "  Inside block, can't access method's x directly"
  puts "  But closure captures surrounding scope"
end

# ========================================
# 13. PRACTICAL PATTERNS
# ========================================

puts "\n13. Practical Patterns:"

# Builder pattern with block
class User
  attr_accessor :name, :email, :age

  def self.build
    user = new
    yield(user) if block_given?
    user
  end
end

user = User.build do |u|
  u.name = "John Doe"
  u.email = "john@example.com"
  u.age = 30
end
puts "Built user: #{user.name}, #{user.email}"

# DSL (Domain Specific Language)
class Router
  def initialize
    @routes = []
  end

  def get(path, &handler)
    @routes << { method: :get, path: path, handler: handler }
  end

  def call(method, path)
    route = @routes.find { |r| r[:method] == method && r[:path] == path }
    route[:handler].call if route
  end
end

router = Router.new
router.get("/home") { puts "  Home page" }
router.get("/about") { puts "  About page" }

puts "\nDSL Router:"
router.call(:get, "/home")
router.call(:get, "/about")

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "BLOCKS, PROCS, AND LAMBDAS - SUMMARY"
puts "=" * 50
puts "BLOCKS:"
puts "• Anonymous code chunks"
puts "• Passed to methods implicitly"
puts "• Executed with yield"
puts "• Not objects (but can be converted)"
puts "\nPROCS:"
puts "• Objects wrapping blocks"
puts "• Can be stored and passed around"
puts "• Lenient about arguments"
puts "• return exits enclosing method"
puts "\nLAMBDAS:"
puts "• Special type of Proc"
puts "• Strict about argument count"
puts "• return exits lambda only"
puts "• More function-like behavior"
puts "\nUSE CASES:"
puts "• Blocks: Iterators, callbacks, resource management"
puts "• Procs: Storing code as variables"
puts "• Lambdas: Function-like behavior, safer returns"
puts "=" * 50
