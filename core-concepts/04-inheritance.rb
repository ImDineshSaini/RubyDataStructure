# ========================================
# INHERITANCE IN RUBY
# ========================================
# Inheritance allows a class to inherit behavior and attributes from another class.
# Supports code reuse and represents "is-a" relationships.

puts "=" * 50
puts "INHERITANCE IN RUBY"
puts "=" * 50

# ========================================
# 1. BASIC INHERITANCE
# ========================================

puts "\n1. Basic Inheritance:"

class Animal
  def initialize(name)
    @name = name
  end

  def eat
    puts "#{@name} is eating"
  end

  def sleep
    puts "#{@name} is sleeping"
  end
end

class Dog < Animal  # Dog inherits from Animal
  def bark
    puts "#{@name} says: Woof!"
  end
end

class Cat < Animal  # Cat inherits from Animal
  def meow
    puts "#{@name} says: Meow!"
  end
end

dog = Dog.new("Buddy")
dog.eat      # Inherited from Animal
dog.sleep    # Inherited from Animal
dog.bark     # Dog's own method

cat = Cat.new("Whiskers")
cat.eat      # Inherited from Animal
cat.meow     # Cat's own method

# ========================================
# 2. METHOD OVERRIDING
# ========================================

puts "\n2. Method Overriding:"

class Vehicle
  def initialize(brand)
    @brand = brand
  end

  def start
    puts "#{@brand} engine starting..."
  end

  def stop
    puts "#{@brand} engine stopping..."
  end
end

class ElectricCar < Vehicle
  def start
    # Override parent method
    puts "#{@brand} electric motor activating silently..."
  end

  # stop method is inherited without changes
end

car = ElectricCar.new("Tesla")
car.start  # Uses overridden method
car.stop   # Uses inherited method

# ========================================
# 3. SUPER KEYWORD
# ========================================

puts "\n3. Using super:"

class Employee
  attr_reader :name, :salary

  def initialize(name, salary)
    @name = name
    @salary = salary
    puts "Employee initialized: #{@name}"
  end

  def work
    puts "#{@name} is working"
  end

  def annual_bonus
    @salary * 0.1
  end
end

class Manager < Employee
  attr_reader :department

  def initialize(name, salary, department)
    super(name, salary)  # Call parent constructor
    @department = department
    puts "Manager assigned to: #{@department}"
  end

  def work
    super  # Call parent method
    puts "#{@name} is also managing the #{@department} team"
  end

  def annual_bonus
    # Enhance parent calculation
    base_bonus = super
    manager_bonus = base_bonus * 0.5
    base_bonus + manager_bonus
  end
end

manager = Manager.new("Alice", 80000, "Engineering")
manager.work
puts "Annual bonus: $#{manager.annual_bonus}"

# ========================================
# 4. INHERITANCE CHAIN
# ========================================

puts "\n4. Inheritance Chain:"

class LivingBeing
  def breathe
    puts "Breathing..."
  end
end

class Mammal < LivingBeing
  def feed_young
    puts "Feeding young with milk"
  end
end

class Primate < Mammal
  def use_tools
    puts "Using tools"
  end
end

class Human < Primate
  def speak
    puts "Speaking in language"
  end
end

human = Human.new
human.breathe      # From LivingBeing
human.feed_young   # From Mammal
human.use_tools    # From Primate
human.speak        # From Human

puts "\nInheritance hierarchy:"
puts "Human -> #{Human.superclass}"
puts "Primate -> #{Primate.superclass}"
puts "Mammal -> #{Mammal.superclass}"
puts "LivingBeing -> #{LivingBeing.superclass}"

# ========================================
# 5. CHECKING CLASS RELATIONSHIPS
# ========================================

puts "\n5. Checking Class Relationships:"

class Shape
end

class Polygon < Shape
end

class Rectangle < Polygon
end

rect = Rectangle.new

# is_a? checks if object is instance of class or its ancestors
puts "rect.is_a?(Rectangle): #{rect.is_a?(Rectangle)}"
puts "rect.is_a?(Polygon): #{rect.is_a?(Polygon)}"
puts "rect.is_a?(Shape): #{rect.is_a?(Shape)}"
puts "rect.is_a?(Object): #{rect.is_a?(Object)}"

# instance_of? checks exact class only
puts "\nrect.instance_of?(Rectangle): #{rect.instance_of?(Rectangle)}"
puts "rect.instance_of?(Polygon): #{rect.instance_of?(Polygon)}"

# kind_of? is alias for is_a?
puts "\nrect.kind_of?(Shape): #{rect.kind_of?(Shape)}"

# Check class hierarchy
puts "\nRectangle < Polygon: #{Rectangle < Polygon}"
puts "Rectangle < Shape: #{Rectangle < Shape}"

# ========================================
# 6. ANCESTORS CHAIN
# ========================================

puts "\n6. Ancestors Chain:"

class A
end

class B < A
end

class C < B
end

puts "C.ancestors:"
C.ancestors.each_with_index do |ancestor, i|
  puts "  #{i}. #{ancestor}"
end

# Shows entire chain including modules and base classes

# ========================================
# 7. METHOD LOOKUP
# ========================================

puts "\n7. Method Lookup:"

class Parent
  def greet
    "Hello from Parent"
  end

  def shared_method
    "Parent's shared method"
  end
end

class Child < Parent
  def shared_method
    "Child's shared method"
  end

  def child_only
    "Only in Child"
  end
end

child = Child.new
puts child.greet           # Found in Parent
puts child.shared_method   # Found in Child (overridden)
puts child.child_only      # Found in Child

# Method lookup order
puts "\nMethod lookup path for Child:"
Child.ancestors.each { |a| puts "  #{a}" }

# ========================================
# 8. PROTECTED AND PRIVATE INHERITANCE
# ========================================

puts "\n8. Access Control with Inheritance:"

class BankAccount
  def initialize(balance)
    @balance = balance
  end

  def deposit(amount)
    @balance += amount
    log_transaction("Deposit", amount)
  end

  protected

  def balance
    @balance
  end

  def compare_balance(other_account)
    # Protected methods can be called on other instances
    if balance > other_account.balance
      "This account has more money"
    else
      "Other account has more money"
    end
  end

  private

  def log_transaction(type, amount)
    puts "  [LOG] #{type}: $#{amount}"
  end
end

class SavingsAccount < BankAccount
  def add_interest(rate)
    # Can call protected method from parent
    interest = balance * rate
    deposit(interest)
  end

  def compare_with(other)
    # Can call inherited protected method
    compare_balance(other)
  end
end

savings1 = SavingsAccount.new(1000)
savings2 = SavingsAccount.new(2000)

savings1.add_interest(0.05)
puts savings1.compare_with(savings2)

# ========================================
# 9. ABSTRACT BASE CLASSES
# ========================================

puts "\n9. Abstract Base Classes:"

class AbstractShape
  def initialize
    raise "Cannot instantiate abstract class" if self.class == AbstractShape
  end

  def area
    raise NotImplementedError, "Subclasses must implement area"
  end

  def perimeter
    raise NotImplementedError, "Subclasses must implement perimeter"
  end

  def describe
    puts "This is a #{self.class.name}"
    puts "Area: #{area}"
    puts "Perimeter: #{perimeter}"
  end
end

class Circle < AbstractShape
  def initialize(radius)
    @radius = radius
    super()
  end

  def area
    Math::PI * @radius ** 2
  end

  def perimeter
    2 * Math::PI * @radius
  end
end

class Square < AbstractShape
  def initialize(side)
    @side = side
    super()
  end

  def area
    @side ** 2
  end

  def perimeter
    4 * @side
  end
end

circle = Circle.new(5)
circle.describe

square = Square.new(4)
square.describe

# abstract = AbstractShape.new  # Would raise error

# ========================================
# 10. COMPOSITION VS INHERITANCE
# ========================================

puts "\n10. Composition vs Inheritance:"

# Inheritance approach (is-a relationship)
class Bird
  def fly
    "Flying high"
  end
end

class Penguin < Bird
  def fly
    # Penguins can't fly - inheritance problem!
    "I can't fly!"
  end
end

# Composition approach (has-a relationship)
class FlyingAbility
  def fly
    "Flying high"
  end
end

class SwimmingAbility
  def swim
    "Swimming"
  end
end

class Eagle
  def initialize
    @flying = FlyingAbility.new
  end

  def fly
    @flying.fly
  end
end

class Penguin2
  def initialize
    @swimming = SwimmingAbility.new
  end

  def swim
    @swimming.swim
  end
end

eagle = Eagle.new
puts "Eagle: #{eagle.fly}"

penguin = Penguin2.new
puts "Penguin: #{penguin.swim}"

puts "\nComposition is often better than inheritance!"

# ========================================
# 11. SINGLE INHERITANCE LIMITATION
# ========================================

puts "\n11. Single Inheritance (Use Modules for Multiple):"

# Ruby only supports single inheritance
class Vehicle
  def start
    "Starting vehicle"
  end
end

class ElectricDevice
  def charge
    "Charging device"
  end
end

# Can't inherit from both Vehicle and ElectricDevice
# class ElectricCar < Vehicle, ElectricDevice  # ERROR

# Solution: Use modules
module Electric
  def charge
    "Charging battery"
  end
end

module GPS
  def navigate
    "Navigating to destination"
  end
end

class Car < Vehicle
  include Electric
  include GPS
end

car = Car.new
puts car.start
puts car.charge
puts car.navigate

# ========================================
# 12. INHERITANCE WITH CLASS METHODS
# ========================================

puts "\n12. Inheriting Class Methods:"

class DatabaseRecord
  @@table_name = "base_table"

  def self.table_name
    @@table_name
  end

  def self.all
    puts "SELECT * FROM #{table_name}"
  end

  def self.find(id)
    puts "SELECT * FROM #{table_name} WHERE id = #{id}"
  end
end

class User < DatabaseRecord
  @@table_name = "users"
end

class Product < DatabaseRecord
  @@table_name = "products"
end

User.all
User.find(123)

Product.all
Product.find(456)

# ========================================
# 13. TEMPLATE METHOD PATTERN
# ========================================

puts "\n13. Template Method Pattern:"

class DataProcessor
  def process
    load_data
    validate_data
    transform_data
    save_data
  end

  def load_data
    puts "Loading data..."
  end

  def validate_data
    raise NotImplementedError, "Subclasses must implement validate_data"
  end

  def transform_data
    raise NotImplementedError, "Subclasses must implement transform_data"
  end

  def save_data
    puts "Saving data..."
  end
end

class CSVProcessor < DataProcessor
  def validate_data
    puts "Validating CSV format"
  end

  def transform_data
    puts "Converting CSV to structured data"
  end
end

class JSONProcessor < DataProcessor
  def validate_data
    puts "Validating JSON format"
  end

  def transform_data
    puts "Parsing JSON data"
  end
end

puts "CSV Processing:"
CSVProcessor.new.process

puts "\nJSON Processing:"
JSONProcessor.new.process

# ========================================
# 14. PREVENTING INHERITANCE
# ========================================

puts "\n14. Preventing Inheritance:"

class FinalClass
  def self.inherited(subclass)
    raise TypeError, "Cannot inherit from #{self}"
  end

  def some_method
    "This class cannot be inherited"
  end
end

obj = FinalClass.new
puts obj.some_method

# class ChildClass < FinalClass  # Would raise TypeError
# end

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "INHERITANCE - SUMMARY"
puts "=" * 50
puts "BASICS:"
puts "• class Child < Parent - Define inheritance"
puts "• super - Call parent method/constructor"
puts "• Only single inheritance (one superclass)"
puts "• Use modules for multiple inheritance behavior"
puts "\nMETHOD LOOKUP:"
puts "1. Check in the object's class"
puts "2. Check in included modules (last to first)"
puts "3. Check in parent class"
puts "4. Repeat up the chain to BasicObject"
puts "\nCHECKING RELATIONSHIPS:"
puts "• is_a? / kind_of? - Instance of class or ancestors"
puts "• instance_of? - Exact class only"
puts "• Class < Parent - Check class hierarchy"
puts "• ancestors - Show full lookup chain"
puts "\nACCESS CONTROL:"
puts "• public - Accessible everywhere"
puts "• protected - Accessible in class and subclasses"
puts "• private - Only within the class"
puts "• Child inherits access control rules"
puts "\nBEST PRACTICES:"
puts "✓ Use inheritance for \"is-a\" relationships"
puts "✓ Use composition for \"has-a\" relationships"
puts "✓ Prefer shallow hierarchies (max 2-3 levels)"
puts "✓ Use super when extending behavior"
puts "✓ Override judiciously, document changes"
puts "✓ Consider modules for shared behavior"
puts "\nAVOID:"
puts "✗ Deep inheritance hierarchies (hard to maintain)"
puts "✗ Inheriting when composition is better"
puts "✗ Breaking Liskov Substitution Principle"
puts "✗ Using inheritance just for code reuse"
puts "✗ Fragile base class problem"
puts "\nWHEN TO USE INHERITANCE:"
puts "• True \"is-a\" relationship"
puts "• Share interface and implementation"
puts "• Specialize general behavior"
puts "• Template method pattern"
puts "\nWHEN TO USE COMPOSITION:"
puts "• \"has-a\" or \"uses-a\" relationship"
puts "• More flexibility needed"
puts "• Behavior changes at runtime"
puts "• Avoid tight coupling"
puts "\nCOMMON PITFALLS:"
puts "• Overusing inheritance (favor composition)"
puts "• Violating Liskov Substitution"
puts "• Fragile base class (changes break children)"
puts "• Yo-yo problem (jumping up and down hierarchy)"
puts "=" * 50
