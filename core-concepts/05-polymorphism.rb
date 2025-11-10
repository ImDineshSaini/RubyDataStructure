# ========================================
# POLYMORPHISM IN RUBY
# ========================================
# Polymorphism means "many forms" - ability of different objects to respond
# to the same message/method in different ways.

puts "=" * 50
puts "POLYMORPHISM IN RUBY"
puts "=" * 50

# ========================================
# 1. BASIC POLYMORPHISM
# ========================================

puts "\n1. Basic Polymorphism:"

class Dog
  def speak
    "Woof!"
  end
end

class Cat
  def speak
    "Meow!"
  end
end

class Duck
  def speak
    "Quack!"
  end
end

# Polymorphic behavior - same method, different implementations
animals = [Dog.new, Cat.new, Duck.new]

animals.each do |animal|
  puts "#{animal.class.name} says: #{animal.speak}"
end

# ========================================
# 2. POLYMORPHISM THROUGH INHERITANCE
# ========================================

puts "\n2. Polymorphism Through Inheritance:"

class Shape
  def area
    raise NotImplementedError, "Subclasses must implement area"
  end

  def describe
    puts "#{self.class.name} with area: #{area}"
  end
end

class Circle < Shape
  def initialize(radius)
    @radius = radius
  end

  def area
    Math::PI * @radius ** 2
  end
end

class Rectangle < Shape
  def initialize(width, height)
    @width = width
    @height = height
  end

  def area
    @width * @height
  end
end

class Triangle < Shape
  def initialize(base, height)
    @base = base
    @height = height
  end

  def area
    0.5 * @base * @height
  end
end

# Polymorphic usage - treat all shapes uniformly
shapes = [
  Circle.new(5),
  Rectangle.new(4, 6),
  Triangle.new(3, 4)
]

shapes.each do |shape|
  shape.describe
end

# ========================================
# 3. DUCK TYPING
# ========================================

puts "\n3. Duck Typing (If it quacks like a duck...):"

# No common base class or interface needed
class FileLogger
  def log(message)
    puts "Writing to file: #{message}"
  end
end

class DatabaseLogger
  def log(message)
    puts "Writing to database: #{message}"
  end
end

class ConsoleLogger
  def log(message)
    puts "Writing to console: #{message}"
  end
end

# Polymorphic function - works with any object that has 'log' method
def perform_logging(logger, message)
  logger.log(message)
end

perform_logging(FileLogger.new, "File log message")
perform_logging(DatabaseLogger.new, "Database log message")
perform_logging(ConsoleLogger.new, "Console log message")

puts "\nDuck typing: If it has a log method, it's a logger!"

# ========================================
# 4. POLYMORPHISM WITH MODULES
# ========================================

puts "\n4. Polymorphism with Modules:"

module Drawable
  def draw
    raise NotImplementedError, "Subclasses must implement draw"
  end
end

class Button
  include Drawable

  def draw
    puts "Drawing button with border and text"
  end
end

class Checkbox
  include Drawable

  def draw
    puts "Drawing checkbox with checkmark"
  end
end

class TextField
  include Drawable

  def draw
    puts "Drawing text field with input box"
  end
end

# Polymorphic UI rendering
components = [Button.new, Checkbox.new, TextField.new]

puts "Rendering UI components:"
components.each do |component|
  component.draw
end

# ========================================
# 5. PARAMETRIC POLYMORPHISM
# ========================================

puts "\n5. Parametric Polymorphism (Generic Methods):"

# Method works with any type
def print_items(items)
  items.each_with_index do |item, index|
    puts "#{index + 1}. #{item}"
  end
end

puts "Numbers:"
print_items([1, 2, 3, 4, 5])

puts "\nStrings:"
print_items(["apple", "banana", "cherry"])

puts "\nMixed types:"
print_items([1, "two", 3.0, :four])

# Generic container class
class Box
  def initialize(content)
    @content = content
  end

  def get
    @content
  end

  def set(new_content)
    @content = new_content
  end

  def inspect_content
    "Box containing: #{@content.inspect}"
  end
end

int_box = Box.new(42)
string_box = Box.new("Hello")
array_box = Box.new([1, 2, 3])

puts "\n#{int_box.inspect_content}"
puts string_box.inspect_content
puts array_box.inspect_content

# ========================================
# 6. OPERATOR OVERLOADING
# ========================================

puts "\n6. Operator Overloading (Polymorphic Operators):"

class Vector
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  # Overload + operator
  def +(other)
    Vector.new(@x + other.x, @y + other.y)
  end

  # Overload * operator
  def *(scalar)
    Vector.new(@x * scalar, @y * scalar)
  end

  # Overload == operator
  def ==(other)
    @x == other.x && @y == other.y
  end

  def to_s
    "(#{@x}, #{@y})"
  end
end

v1 = Vector.new(3, 4)
v2 = Vector.new(1, 2)

puts "v1: #{v1}"
puts "v2: #{v2}"
puts "v1 + v2: #{v1 + v2}"
puts "v1 * 3: #{v1 * 3}"
puts "v1 == v2: #{v1 == v2}"

# ========================================
# 7. POLYMORPHISM WITH BLOCKS
# ========================================

puts "\n7. Polymorphism with Blocks:"

class DataProcessor
  def process(data, &strategy)
    puts "Processing data..."
    result = data.map(&strategy)
    puts "Result: #{result}"
  end
end

processor = DataProcessor.new

puts "Double numbers:"
processor.process([1, 2, 3, 4, 5]) { |n| n * 2 }

puts "\nSquare numbers:"
processor.process([1, 2, 3, 4, 5]) { |n| n ** 2 }

puts "\nConvert to strings:"
processor.process([1, 2, 3, 4, 5]) { |n| "Number: #{n}" }

# ========================================
# 8. STRATEGY PATTERN (POLYMORPHISM)
# ========================================

puts "\n8. Strategy Pattern:"

# Different sorting strategies
class BubbleSort
  def sort(array)
    puts "Using Bubble Sort"
    arr = array.dup
    n = arr.length
    loop do
      swapped = false
      (n - 1).times do |i|
        if arr[i] > arr[i + 1]
          arr[i], arr[i + 1] = arr[i + 1], arr[i]
          swapped = true
        end
      end
      break unless swapped
    end
    arr
  end
end

class QuickSort
  def sort(array)
    puts "Using Quick Sort"
    return array if array.length <= 1
    pivot = array.delete_at(array.length / 2)
    left = array.select { |x| x < pivot }
    right = array.select { |x| x >= pivot }
    QuickSort.new.sort(left) + [pivot] + QuickSort.new.sort(right)
  end
end

class RubySort
  def sort(array)
    puts "Using Ruby's Built-in Sort"
    array.sort
  end
end

# Polymorphic usage
class Sorter
  def initialize(strategy)
    @strategy = strategy
  end

  def sort(array)
    @strategy.sort(array)
  end

  def change_strategy(strategy)
    @strategy = strategy
  end
end

data = [64, 34, 25, 12, 22, 11, 90]

sorter = Sorter.new(BubbleSort.new)
puts "Result: #{sorter.sort(data)}"

sorter.change_strategy(QuickSort.new)
puts "Result: #{sorter.sort(data)}"

# ========================================
# 9. POLYMORPHIC COLLECTIONS
# ========================================

puts "\n9. Polymorphic Collections:"

class Employee
  attr_reader :name, :salary

  def initialize(name, salary)
    @name = name
    @salary = salary
  end

  def calculate_pay
    @salary
  end
end

class Contractor
  attr_reader :name, :hourly_rate, :hours

  def initialize(name, hourly_rate, hours)
    @name = name
    @hourly_rate = hourly_rate
    @hours = hours
  end

  def calculate_pay
    @hourly_rate * @hours
  end
end

class Intern
  attr_reader :name, :stipend

  def initialize(name, stipend)
    @name = name
    @stipend = stipend
  end

  def calculate_pay
    @stipend
  end
end

# Polymorphic collection - different types, same interface
workers = [
  Employee.new("Alice", 5000),
  Contractor.new("Bob", 50, 160),
  Intern.new("Charlie", 1000)
]

puts "Payroll:"
total = 0
workers.each do |worker|
  pay = worker.calculate_pay
  puts "#{worker.name}: $#{pay}"
  total += pay
end
puts "Total: $#{total}"

# ========================================
# 10. METHOD MISSING (EXTREME POLYMORPHISM)
# ========================================

puts "\n10. Method Missing - Dynamic Polymorphism:"

class DynamicResponder
  def method_missing(method_name, *args, &block)
    if method_name.to_s.start_with?('say_')
      word = method_name.to_s.sub('say_', '')
      "Saying: #{word.upcase}!"
    elsif method_name.to_s.start_with?('calculate_')
      operation = method_name.to_s.sub('calculate_', '')
      "Calculating #{operation} with args: #{args.inspect}"
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('say_', 'calculate_') || super
  end
end

responder = DynamicResponder.new

puts responder.say_hello
puts responder.say_goodbye
puts responder.calculate_sum(10, 20, 30)
puts responder.calculate_average(5, 10, 15)

# ========================================
# 11. INTERFACE SEGREGATION
# ========================================

puts "\n11. Interface Segregation with Modules:"

module Flyable
  def fly
    raise NotImplementedError
  end
end

module Swimmable
  def swim
    raise NotImplementedError
  end
end

module Walkable
  def walk
    raise NotImplementedError
  end
end

class Airplane
  include Flyable

  def fly
    "Airplane flying at 30,000 feet"
  end
end

class Fish
  include Swimmable

  def swim
    "Fish swimming in water"
  end
end

class Human
  include Walkable
  include Swimmable

  def walk
    "Human walking on land"
  end

  def swim
    "Human swimming in pool"
  end
end

# Polymorphic functions
def test_flying(flyable_object)
  puts flyable_object.fly
end

def test_swimming(swimmable_object)
  puts swimmable_object.swim
end

test_flying(Airplane.new)
test_swimming(Fish.new)

human = Human.new
test_swimming(human)
puts human.walk

# ========================================
# 12. DOUBLE DISPATCH
# ========================================

puts "\n12. Double Dispatch:"

class Rock
  def beats?(other)
    other.beaten_by_rock?
  end

  def beaten_by_rock?
    false
  end

  def beaten_by_paper?
    true
  end

  def beaten_by_scissors?
    false
  end

  def to_s
    "Rock"
  end
end

class Paper
  def beats?(other)
    other.beaten_by_paper?
  end

  def beaten_by_rock?
    false
  end

  def beaten_by_paper?
    false
  end

  def beaten_by_scissors?
    true
  end

  def to_s
    "Paper"
  end
end

class Scissors
  def beats?(other)
    other.beaten_by_scissors?
  end

  def beaten_by_rock?
    true
  end

  def beaten_by_paper?
    false
  end

  def beaten_by_scissors?
    false
  end

  def to_s
    "Scissors"
  end
end

def play_game(player1, player2)
  if player1.beats?(player2)
    puts "#{player1} beats #{player2}"
  elsif player2.beats?(player1)
    puts "#{player2} beats #{player1}"
  else
    puts "Tie!"
  end
end

play_game(Rock.new, Scissors.new)
play_game(Paper.new, Rock.new)
play_game(Scissors.new, Paper.new)
play_game(Rock.new, Rock.new)

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "POLYMORPHISM - SUMMARY"
puts "=" * 50
puts "TYPES OF POLYMORPHISM:"
puts "\n1. SUBTYPE POLYMORPHISM (Inheritance):"
puts "   • Child classes override parent methods"
puts "   • Treated uniformly through parent interface"
puts "   • Example: Shape -> Circle, Rectangle, Triangle"
puts "\n2. DUCK TYPING (Interface Polymorphism):"
puts "   • Objects with same methods are interchangeable"
puts "   • No inheritance or interface declaration needed"
puts "   • \"If it walks like a duck and quacks like a duck...\""
puts "   • Most Ruby-like approach"
puts "\n3. PARAMETRIC POLYMORPHISM (Generics):"
puts "   • Methods/classes work with any type"
puts "   • Type-agnostic operations"
puts "   • Example: Array, Hash work with any type"
puts "\n4. AD-HOC POLYMORPHISM (Operator Overloading):"
puts "   • Same operator works differently for different types"
puts "   • Example: + for numbers, strings, arrays"
puts "\nKEY BENEFITS:"
puts "✓ Code reuse - Write once, use with many types"
puts "✓ Flexibility - Easy to add new types"
puts "✓ Maintainability - Changes in one place"
puts "✓ Abstraction - Work with interfaces, not implementations"
puts "✓ Open/Closed Principle - Open for extension"
puts "\nRUBY FEATURES FOR POLYMORPHISM:"
puts "• Duck typing (no explicit interfaces)"
puts "• Modules for shared behavior"
puts "• method_missing for dynamic behavior"
puts "• Blocks and procs as strategies"
puts "• Operator overloading"
puts "\nBEST PRACTICES:"
puts "✓ Favor duck typing over strict interfaces"
puts "✓ Define clear method contracts"
puts "✓ Use modules for shared behavior"
puts "✓ Keep interfaces small and focused"
puts "✓ Document expected behavior"
puts "✓ Use respond_to? to check capabilities"
puts "\nCOMMON PATTERNS USING POLYMORPHISM:"
puts "• Strategy Pattern - Interchangeable algorithms"
puts "• Template Method - Customizable algorithm steps"
puts "• Factory Pattern - Create different types"
puts "• Visitor Pattern - Operations on different types"
puts "• Command Pattern - Executable commands"
puts "\nWHEN TO USE:"
puts "• Multiple objects share interface"
puts "• Need to treat different types uniformly"
puts "• Want to add new types without changing code"
puts "• Implementing design patterns"
puts "\nAVOID:"
puts "✗ Overusing inheritance (prefer composition)"
puts "✗ Breaking Liskov Substitution Principle"
puts "✗ Making assumptions about object types"
puts "✗ Type checking with is_a? (prefer duck typing)"
puts "=" * 50
