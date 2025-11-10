# ========================================
# CLASSES AND OBJECTS IN RUBY
# ========================================
# Classes are blueprints for creating objects.
# Objects are instances of classes with their own state and behavior.

puts "=" * 50
puts "CLASSES AND OBJECTS IN RUBY"
puts "=" * 50

# ========================================
# 1. BASIC CLASS DEFINITION
# ========================================

puts "\n1. Basic Class Definition:"

class Dog
  def bark
    puts "Woof!"
  end
end

# Create an instance (object)
dog = Dog.new
dog.bark

# Check class and object_id
puts "Class: #{dog.class}"
puts "Object ID: #{dog.object_id}"

# ========================================
# 2. INSTANCE VARIABLES AND INITIALIZE
# ========================================

puts "\n2. Instance Variables and Initialize:"

class Person
  def initialize(name, age)
    @name = name  # Instance variable
    @age = age
  end

  def introduce
    puts "Hi, I'm #{@name} and I'm #{@age} years old."
  end

  def birthday
    @age += 1
    puts "Happy birthday! Now #{@age} years old."
  end
end

person1 = Person.new("Alice", 25)
person2 = Person.new("Bob", 30)

person1.introduce
person2.introduce
person1.birthday

# Instance variables are private to each object
puts "Person1 and Person2 are different objects: #{person1.object_id != person2.object_id}"

# ========================================
# 3. ATTR_ACCESSOR, ATTR_READER, ATTR_WRITER
# ========================================

puts "\n3. Attribute Accessors:"

class Book
  attr_reader :title      # Only getter
  attr_writer :price      # Only setter
  attr_accessor :author   # Both getter and setter

  def initialize(title, author, price)
    @title = title
    @author = author
    @price = price
  end

  def info
    "#{@title} by #{@author} - $#{@price}"
  end
end

book = Book.new("Ruby Programming", "Matz", 49.99)

# attr_reader allows reading
puts "Title: #{book.title}"

# attr_writer allows writing
book.price = 39.99
# puts book.price  # Error: no getter defined

# attr_accessor allows both
puts "Author: #{book.author}"
book.author = "Yukihiro Matsumoto"
puts "Updated author: #{book.author}"

puts book.info

# ========================================
# 4. CLASS VARIABLES AND CLASS METHODS
# ========================================

puts "\n4. Class Variables and Class Methods:"

class BankAccount
  @@total_accounts = 0  # Class variable (shared across all instances)
  @@interest_rate = 0.02

  def initialize(owner, balance)
    @owner = owner
    @balance = balance
    @@total_accounts += 1
  end

  # Instance method
  def deposit(amount)
    @balance += amount
    puts "Deposited $#{amount}. New balance: $#{@balance}"
  end

  def apply_interest
    interest = @balance * @@interest_rate
    @balance += interest
    puts "Interest of $#{interest.round(2)} applied. New balance: $#{@balance.round(2)}"
  end

  # Class method (can be called on class itself)
  def self.total_accounts
    @@total_accounts
  end

  def self.set_interest_rate(rate)
    @@interest_rate = rate
    puts "Interest rate set to #{rate * 100}%"
  end

  def self.interest_rate
    @@interest_rate
  end
end

account1 = BankAccount.new("Alice", 1000)
account2 = BankAccount.new("Bob", 2000)

puts "Total accounts: #{BankAccount.total_accounts}"

account1.deposit(500)
account1.apply_interest

BankAccount.set_interest_rate(0.03)
account2.apply_interest

# ========================================
# 5. INHERITANCE
# ========================================

puts "\n5. Inheritance:"

class Vehicle
  attr_accessor :speed

  def initialize(brand)
    @brand = brand
    @speed = 0
  end

  def accelerate(amount)
    @speed += amount
    puts "#{@brand} accelerating... Speed: #{@speed} mph"
  end

  def brake
    @speed = 0
    puts "#{@brand} stopped."
  end
end

class Car < Vehicle
  attr_accessor :num_doors

  def initialize(brand, num_doors)
    super(brand)  # Call parent constructor
    @num_doors = num_doors
  end

  def honk
    puts "#{@brand} goes beep beep!"
  end
end

class Motorcycle < Vehicle
  def initialize(brand)
    super(brand)
  end

  def wheelie
    puts "#{@brand} doing a wheelie!" if @speed > 30
  end
end

car = Car.new("Toyota", 4)
car.accelerate(60)
car.honk
car.brake

motorcycle = Motorcycle.new("Harley")
motorcycle.accelerate(50)
motorcycle.wheelie

# Check inheritance
puts "Car is a Vehicle? #{car.is_a?(Vehicle)}"
puts "Car superclass: #{Car.superclass}"

# ========================================
# 6. METHOD OVERRIDING
# ========================================

puts "\n6. Method Overriding:"

class Animal
  def speak
    "Some generic sound"
  end

  def move
    "Moving..."
  end
end

class Cat < Animal
  def speak
    "Meow!"
  end

  def move
    super  # Call parent method
    puts "Cat is walking gracefully"
  end
end

class Lion < Cat
  def speak
    "ROAR!"
  end
end

cat = Cat.new
lion = Lion.new

puts cat.speak
puts lion.speak
cat.move

# ========================================
# 7. ACCESS CONTROL (PUBLIC, PRIVATE, PROTECTED)
# ========================================

puts "\n7. Access Control:"

class CreditCard
  def initialize(number, cvv, balance)
    @number = number
    @cvv = cvv
    @balance = balance
  end

  # Public methods (default)
  def display_balance
    puts "Balance: $#{@balance}"
  end

  def make_payment(amount)
    if valid_payment?(amount)
      @balance -= amount
      log_transaction("Payment", amount)
      puts "Payment of $#{amount} successful"
    else
      puts "Insufficient funds"
    end
  end

  # Protected methods (accessible within class and subclasses)
  protected

  def balance
    @balance
  end

  def compare_balance(other_card)
    if balance > other_card.balance
      "This card has higher balance"
    else
      "Other card has higher balance"
    end
  end

  # Private methods (only accessible within the class)
  private

  def valid_payment?(amount)
    amount <= @balance
  end

  def log_transaction(type, amount)
    puts "  [LOG] #{type}: $#{amount} at #{Time.now}"
  end
end

card = CreditCard.new("1234-5678-9012-3456", "123", 1000)
card.display_balance
card.make_payment(200)

# card.valid_payment?(100)  # Error: private method
# card.log_transaction("Test", 50)  # Error: private method

# ========================================
# 8. CLASS INSTANCE VARIABLES
# ========================================

puts "\n8. Class Instance Variables:"

class Product
  @count = 0  # Class instance variable

  def self.count
    @count
  end

  def self.create(name)
    @count += 1
    new(name)
  end

  def initialize(name)
    @name = name
  end

  def name
    @name
  end
end

class Electronics < Product
  @count = 0  # Separate counter for Electronics
end

Product.create("Widget")
Product.create("Gadget")
Electronics.create("TV")

puts "Total products: #{Product.count}"
puts "Total electronics: #{Electronics.count}"

# ========================================
# 9. SINGLETON METHODS
# ========================================

puts "\n9. Singleton Methods:"

# Method defined on a specific object
str = "hello"

def str.shout
  upcase + "!!!"
end

puts str.shout

# Other strings don't have this method
other_str = "world"
# other_str.shout  # Error: undefined method

# Singleton methods on classes
class Developer
end

dev1 = Developer.new
dev2 = Developer.new

def dev1.code
  puts "#{self.class.name} is coding Ruby!"
end

dev1.code
# dev2.code  # Error: undefined method

# ========================================
# 10. SELF KEYWORD
# ========================================

puts "\n10. Self Keyword:"

class Example
  def initialize(value)
    @value = value
  end

  # Instance method - self refers to the instance
  def show_self
    puts "Instance self: #{self}"
    puts "Instance self class: #{self.class}"
  end

  # Class method - self refers to the class
  def self.show_class_self
    puts "Class self: #{self}"
  end

  def update_value(value)
    self.value = value  # Explicit self needed for setter
  end

  def value=(val)
    @value = val
  end

  def value
    @value
  end
end

obj = Example.new(10)
obj.show_self
Example.show_class_self

# ========================================
# 11. CONSTANTS
# ========================================

puts "\n11. Constants:"

class Circle
  PI = 3.14159  # Constant

  def initialize(radius)
    @radius = radius
  end

  def area
    PI * @radius ** 2
  end

  def self.pi_value
    PI
  end
end

circle = Circle.new(5)
puts "Circle area: #{circle.area}"
puts "PI value: #{Circle::PI}"
puts "PI via method: #{Circle.pi_value}"

# Constants can be modified (with warning)
# Circle::PI = 3.14  # Warning: already initialized constant

# ========================================
# 12. CLASS METHODS VS INSTANCE METHODS
# ========================================

puts "\n12. Class Methods vs Instance Methods:"

class Calculator
  # Class method - doesn't need instance
  def self.add(a, b)
    a + b
  end

  def self.multiply(a, b)
    a * b
  end

  # Instance method - works with instance data
  def initialize
    @history = []
  end

  def calculate(operation, a, b)
    result = case operation
    when :add then a + b
    when :subtract then a - b
    when :multiply then a * b
    when :divide then a / b
    end

    @history << "#{a} #{operation} #{b} = #{result}"
    result
  end

  def show_history
    puts "Calculation history:"
    @history.each { |entry| puts "  #{entry}" }
  end
end

# Class methods - no instance needed
puts "Class method: 5 + 3 = #{Calculator.add(5, 3)}"
puts "Class method: 4 * 6 = #{Calculator.multiply(4, 6)}"

# Instance methods - need instance
calc = Calculator.new
calc.calculate(:add, 10, 5)
calc.calculate(:multiply, 3, 7)
calc.calculate(:divide, 20, 4)
calc.show_history

# ========================================
# 13. TO_S AND INSPECT
# ========================================

puts "\n13. to_s and inspect Methods:"

class Rectangle
  def initialize(width, height)
    @width = width
    @height = height
  end

  def to_s
    "Rectangle: #{@width}×#{@height}"
  end

  def inspect
    "#<Rectangle:#{object_id} @width=#{@width} @height=#{@height} area=#{area}>"
  end

  def area
    @width * @height
  end
end

rect = Rectangle.new(10, 5)
puts "to_s: #{rect}"
puts "inspect: #{rect.inspect}"

# Default puts calls to_s
puts rect

# p calls inspect
p rect

# ========================================
# 14. EQUALITY AND COMPARISON
# ========================================

puts "\n14. Equality and Comparison:"

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  # Custom equality
  def ==(other)
    return false unless other.is_a?(Point)
    @x == other.x && @y == other.y
  end

  # For use in hashes
  def eql?(other)
    self == other
  end

  def hash
    [@x, @y].hash
  end

  def to_s
    "(#{@x}, #{@y})"
  end
end

p1 = Point.new(5, 10)
p2 = Point.new(5, 10)
p3 = Point.new(3, 7)

puts "p1 == p2: #{p1 == p2}"
puts "p1 == p3: #{p1 == p3}"
puts "p1.equal?(p2): #{p1.equal?(p2)}"  # Same object?

# Use in hash
points = { p1 => "Point A", p2 => "Point B" }
puts "Hash lookup: #{points[Point.new(5, 10)]}"

# ========================================
# 15. DUCK TYPING
# ========================================

puts "\n15. Duck Typing:"

class Duck
  def quack
    "Quack!"
  end

  def swim
    "Paddling in the water"
  end
end

class Person
  def quack
    "I'm pretending to be a duck: Quack!"
  end

  def swim
    "Swimming like a human"
  end
end

class Robot
  def quack
    "Robotic quack sound"
  end

  def swim
    "Propelling through water"
  end
end

# If it quacks like a duck and swims like a duck...
def interact_with_duck(duck_like_thing)
  puts duck_like_thing.quack
  puts duck_like_thing.swim
end

puts "Interacting with duck:"
interact_with_duck(Duck.new)

puts "\nInteracting with person:"
interact_with_duck(Person.new)

puts "\nInteracting with robot:"
interact_with_duck(Robot.new)

# ========================================
# 16. OBJECT CLONING
# ========================================

puts "\n16. Object Cloning:"

class Address
  attr_accessor :street, :city

  def initialize(street, city)
    @street = street
    @city = city
  end

  def to_s
    "#{@street}, #{@city}"
  end
end

class Person
  attr_accessor :name, :address

  def initialize(name, address)
    @name = name
    @address = address
  end

  def to_s
    "#{@name} lives at #{@address}"
  end
end

# Shallow copy with dup
person1 = Person.new("Alice", Address.new("123 Main St", "NYC"))
person2 = person1.dup

puts "Original: #{person1}"
puts "Copy: #{person2}"

person2.name = "Bob"
person2.address.street = "456 Oak Ave"

puts "\nAfter modifying copy:"
puts "Original: #{person1}"  # Address also changed!
puts "Copy: #{person2}"

puts "\nShallow copy shares nested objects!"

# For deep copy, need custom implementation
class Person
  def deep_copy
    Marshal.load(Marshal.dump(self))
  end
end

person3 = person1.deep_copy
person3.address.street = "789 Pine Rd"

puts "\nDeep copy:"
puts "Original: #{person1}"
puts "Deep copy: #{person3}"

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "CLASSES AND OBJECTS - SUMMARY"
puts "=" * 50
puts "KEY CONCEPTS:"
puts "• Class - Blueprint for objects"
puts "• Object - Instance of a class"
puts "• Instance variables - @variable (unique per object)"
puts "• Class variables - @@variable (shared across all instances)"
puts "• Instance methods - Behavior for objects"
puts "• Class methods - self.method_name (called on class)"
puts "\nATTRIBUTE ACCESSORS:"
puts "• attr_reader :var - Only getter"
puts "• attr_writer :var - Only setter"
puts "• attr_accessor :var - Both getter and setter"
puts "\nACCESS CONTROL:"
puts "• public - Accessible everywhere (default)"
puts "• protected - Accessible within class and subclasses"
puts "• private - Only accessible within the class"
puts "\nINHERITANCE:"
puts "• class Child < Parent"
puts "• super - Call parent method"
puts "• Single inheritance only (use modules for multiple)"
puts "\nSPECIAL METHODS:"
puts "• initialize - Constructor"
puts "• to_s - String representation"
puts "• inspect - Debug representation"
puts "• == - Equality comparison"
puts "• hash, eql? - For hash keys"
puts "\nSELF KEYWORD:"
puts "• In instance methods: refers to the object"
puts "• In class methods: refers to the class"
puts "• Needed for calling setters"
puts "\nCLONING:"
puts "• dup - Shallow copy (shares nested objects)"
puts "• clone - Like dup but preserves frozen state"
puts "• Deep copy - Use Marshal or custom implementation"
puts "\nBEST PRACTICES:"
puts "✓ Use attr_* for simple getters/setters"
puts "✓ Initialize instance variables in initialize"
puts "✓ Use private for implementation details"
puts "✓ Override to_s for readable output"
puts "✓ Use class methods for factory methods"
puts "✓ Follow duck typing principles"
puts "=" * 50
