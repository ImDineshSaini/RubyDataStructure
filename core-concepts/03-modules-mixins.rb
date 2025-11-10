# ========================================
# MODULES AND MIXINS IN RUBY
# ========================================
# Modules are a way of grouping together methods, classes, and constants.
# Mixins are modules that are included in classes to add functionality.

puts "=" * 50
puts "MODULES AND MIXINS IN RUBY"
puts "=" * 50

# ========================================
# 1. BASIC MODULE DEFINITION
# ========================================

puts "\n1. Basic Module Definition:"

module Greetable
  def greet
    "Hello!"
  end

  def farewell
    "Goodbye!"
  end
end

class Person
  include Greetable

  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

person = Person.new("Alice")
puts "#{person.name} says: #{person.greet}"
puts "#{person.name} says: #{person.farewell}"

# ========================================
# 2. MODULES AS NAMESPACES
# ========================================

puts "\n2. Modules as Namespaces:"

module Geometry
  class Rectangle
    attr_accessor :width, :height

    def initialize(width, height)
      @width = width
      @height = height
    end

    def area
      @width * @height
    end
  end

  class Circle
    attr_accessor :radius

    def initialize(radius)
      @radius = radius
    end

    def area
      Math::PI * @radius ** 2
    end
  end

  PI = 3.14159  # Constant in module
end

module Physics
  class Circle
    # Different Circle class in different namespace
    attr_accessor :mass, :velocity

    def initialize(mass, velocity)
      @mass = mass
      @velocity = velocity
    end

    def kinetic_energy
      0.5 * @mass * @velocity ** 2
    end
  end
end

# No name conflict!
geo_circle = Geometry::Circle.new(5)
phys_circle = Physics::Circle.new(10, 20)

puts "Geometry circle area: #{geo_circle.area.round(2)}"
puts "Physics circle kinetic energy: #{phys_circle.kinetic_energy}"
puts "Geometry::PI = #{Geometry::PI}"

# ========================================
# 3. INCLUDE VS EXTEND VS PREPEND
# ========================================

puts "\n3. Include vs Extend vs Prepend:"

module Walkable
  def walk
    "#{self.class.name} is walking"
  end
end

module Swimmable
  def swim
    "#{self.class.name} is swimming"
  end
end

module Flyable
  def fly
    "#{self.class.name} is flying"
  end
end

# Include - adds instance methods
class Dog
  include Walkable
  include Swimmable
end

dog = Dog.new
puts dog.walk
puts dog.swim

# Extend - adds class methods
class Cat
  extend Walkable
end

puts Cat.walk  # Class method
# Cat.new.walk # Error: undefined method

# Prepend - adds methods before class methods
class Bird
  prepend Flyable

  def fly
    "Bird's own fly method"
  end
end

bird = Bird.new
puts bird.fly  # Calls Flyable#fly, not Bird#fly

puts "\nAncestor chain:"
puts "Dog ancestors: #{Dog.ancestors}"

# ========================================
# 4. MODULE INSTANCE VARIABLES AND METHODS
# ========================================

puts "\n4. Module Instance Variables:"

module Trackable
  def initialize(*args)
    super
    @created_at = Time.now
  end

  def created_at
    @created_at
  end

  def age
    Time.now - @created_at
  end
end

class Product
  include Trackable

  attr_accessor :name, :price

  def initialize(name, price)
    @name = name
    @price = price
    super()  # Call module's initialize
  end
end

product = Product.new("Laptop", 1000)
puts "Product: #{product.name}"
puts "Created at: #{product.created_at}"
sleep(0.1)
puts "Age: #{product.age.round(3)} seconds"

# ========================================
# 5. MODULE METHODS (CLASS METHODS IN MODULES)
# ========================================

puts "\n5. Module Methods:"

module MathUtils
  # Module method (can be called without including)
  def self.square(n)
    n * n
  end

  def self.cube(n)
    n * n * n
  end

  # Alternative syntax
  module_function

  def factorial(n)
    return 1 if n <= 1
    n * factorial(n - 1)
  end
end

puts "Square of 5: #{MathUtils.square(5)}"
puts "Cube of 3: #{MathUtils.cube(3)}"
puts "Factorial of 5: #{MathUtils.factorial(5)}"

# ========================================
# 6. PRACTICAL MIXIN EXAMPLES
# ========================================

puts "\n6. Practical Mixin Examples:"

# Comparable mixin
module Comparable
  def <(other)
    (self <=> other) < 0
  end

  def <=(other)
    (self <=> other) <= 0
  end

  def ==(other)
    (self <=> other) == 0
  end

  def >(other)
    (self <=> other) > 0
  end

  def >=(other)
    (self <=> other) >= 0
  end

  def between?(min, max)
    self >= min && self <= max
  end
end

class Employee
  include Comparable

  attr_accessor :name, :salary

  def initialize(name, salary)
    @name = name
    @salary = salary
  end

  # Define <=> and get all comparison operators for free!
  def <=>(other)
    @salary <=> other.salary
  end

  def to_s
    "#{@name} ($#{@salary})"
  end
end

emp1 = Employee.new("Alice", 80000)
emp2 = Employee.new("Bob", 90000)
emp3 = Employee.new("Charlie", 85000)

puts "#{emp1} < #{emp2}: #{emp1 < emp2}"
puts "#{emp2} > #{emp3}: #{emp2 > emp3}"
puts "#{emp3} between #{emp1} and #{emp2}? #{emp3.between?(emp1, emp2)}"

# ========================================
# 7. MULTIPLE MIXINS
# ========================================

puts "\n7. Multiple Mixins:"

module Loggable
  def log(message)
    puts "[#{Time.now}] #{self.class.name}: #{message}"
  end
end

module Validatable
  def valid?
    errors.empty?
  end

  def errors
    @errors ||= []
  end

  def add_error(message)
    errors << message
  end
end

module Persistable
  def save
    if valid?
      log("Saving #{self.class.name}...")
      puts "✅ Saved successfully"
      true
    else
      log("Validation failed: #{errors.join(', ')}")
      false
    end
  end
end

class User
  include Loggable
  include Validatable
  include Persistable

  attr_accessor :email, :password

  def initialize(email, password)
    @email = email
    @password = password
    validate
  end

  def validate
    add_error("Email cannot be blank") if email.nil? || email.empty?
    add_error("Password too short") if password.nil? || password.length < 6
  end
end

puts "Valid user:"
user1 = User.new("alice@example.com", "password123")
user1.save

puts "\nInvalid user:"
user2 = User.new("", "pass")
user2.save

# ========================================
# 8. HOOK METHODS
# ========================================

puts "\n8. Hook Methods:"

module Observable
  def self.included(base)
    puts "📌 Observable included in #{base}"
    base.extend(ClassMethods)
  end

  def self.extended(base)
    puts "📌 Observable extended into #{base}"
  end

  def self.prepended(base)
    puts "📌 Observable prepended to #{base}"
  end

  module ClassMethods
    def observable_attributes(*attrs)
      attrs.each do |attr|
        define_method("#{attr}=") do |value|
          old_value = instance_variable_get("@#{attr}")
          instance_variable_set("@#{attr}", value)
          notify_observers(attr, old_value, value)
        end

        define_method(attr) do
          instance_variable_get("@#{attr}")
        end
      end
    end
  end

  def add_observer(observer)
    @observers ||= []
    @observers << observer
  end

  def notify_observers(attr, old_value, new_value)
    @observers&.each do |observer|
      observer.update(self, attr, old_value, new_value)
    end
  end
end

class Observer
  def update(subject, attr, old_value, new_value)
    puts "🔔 #{subject.class.name}'s #{attr} changed: #{old_value} → #{new_value}"
  end
end

class Account
  include Observable

  observable_attributes :balance, :status
end

account = Account.new
observer = Observer.new
account.add_observer(observer)

account.balance = 1000
account.balance = 1500
account.status = "active"

# ========================================
# 9. METHOD RESOLUTION ORDER
# ========================================

puts "\n9. Method Resolution Order:"

module A
  def greet
    "Hello from A"
  end
end

module B
  def greet
    "Hello from B"
  end
end

module C
  include A
  include B
end

class TestClass
  include C
end

obj = TestClass.new
puts "Greeting: #{obj.greet}"
puts "Method resolution order:"
TestClass.ancestors.each_with_index do |ancestor, i|
  puts "  #{i + 1}. #{ancestor}"
end

# ========================================
# 10. REFINEMENTS
# ========================================

puts "\n10. Refinements (Scoped Monkey Patching):"

module StringExtensions
  refine String do
    def shout
      upcase + "!!!"
    end

    def whisper
      downcase + "..."
    end
  end
end

# Without using refinement
str1 = "hello"
# puts str1.shout  # Error: undefined method

# Using refinement
using StringExtensions

str2 = "hello"
puts str2.shout
puts str2.whisper

# ========================================
# 11. PRACTICAL PATTERNS
# ========================================

puts "\n11. Practical Patterns:"

# Timestampable mixin
module Timestampable
  def self.included(base)
    base.class_eval do
      attr_reader :created_at, :updated_at
    end
  end

  def initialize(*args)
    super(*args) if defined?(super)
    @created_at = Time.now
    @updated_at = Time.now
  end

  def touch
    @updated_at = Time.now
  end
end

# Serializable mixin
module Serializable
  def to_hash
    instance_variables.each_with_object({}) do |var, hash|
      hash[var.to_s.delete("@").to_sym] = instance_variable_get(var)
    end
  end

  def to_json
    require 'json'
    to_hash.to_json
  end
end

# Comparable by attribute
module ComparableByAttribute
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def compare_by(attribute)
      define_method(:<=>) do |other|
        send(attribute) <=> other.send(attribute)
      end
      include Comparable
    end
  end
end

class Article
  include Timestampable
  include Serializable
  include ComparableByAttribute

  attr_accessor :title, :views

  compare_by :views

  def initialize(title, views = 0)
    @title = title
    @views = views
    super()
  end
end

article1 = Article.new("Ruby Basics", 100)
sleep(0.1)
article2 = Article.new("Advanced Ruby", 250)

puts "Article 1 created: #{article1.created_at}"
puts "Article 2 created: #{article2.created_at}"
puts "Article 1 hash: #{article1.to_hash}"
puts "Article comparison: #{article2} > #{article1}? #{article2 > article1}"

# ========================================
# 12. SINGLETON METHODS WITH MODULES
# ========================================

puts "\n12. Singleton Methods with Modules:"

module AdminFeatures
  def delete_user(user_id)
    puts "🗑️  Admin deleting user #{user_id}"
  end

  def view_logs
    puts "📋 Admin viewing system logs"
  end
end

regular_user = User.new("user@example.com", "password123")
admin_user = User.new("admin@example.com", "adminpass123")

# Extend specific object with admin features
admin_user.extend(AdminFeatures)

admin_user.delete_user(456)
admin_user.view_logs

# regular_user.delete_user(789)  # Error: undefined method

# ========================================
# 13. CONCERN PATTERN (RAILS STYLE)
# ========================================

puts "\n13. Concern Pattern:"

module Concern
  def included(base)
    base.extend(ClassMethods) if const_defined?(:ClassMethods)
    base.include(InstanceMethods) if const_defined?(:InstanceMethods)
  end
end

module Searchable
  extend Concern

  module ClassMethods
    def search(query)
      puts "🔍 Searching for: #{query}"
      ["result1", "result2"]
    end

    def find_by_name(name)
      puts "🔍 Finding by name: #{name}"
    end
  end

  module InstanceMethods
    def searchable_fields
      instance_variables.map { |v| v.to_s.delete("@") }
    end
  end
end

class Post
  include Searchable

  attr_accessor :title, :body, :author

  def initialize(title, body, author)
    @title = title
    @body = body
    @author = author
  end
end

Post.search("ruby")
post = Post.new("Ruby Guide", "Content...", "Alice")
puts "Searchable fields: #{post.searchable_fields}"

# ========================================
# 14. STATE MACHINE MIXIN
# ========================================

puts "\n14. State Machine Mixin:"

module StateMachine
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def state_machine(&block)
      @states = []
      @transitions = {}
      instance_eval(&block)
    end

    def state(name)
      @states << name
      define_method("#{name}?") do
        @state == name
      end
    end

    def transition(from:, to:, on:)
      @transitions[on] = { from: from, to: to }

      define_method(on) do
        if @state == from
          @state = to
          puts "🔄 Transitioned from #{from} to #{to}"
          true
        else
          puts "❌ Cannot transition: not in #{from} state"
          false
        end
      end
    end
  end

  def initialize(*args)
    super(*args) if defined?(super)
    @state = self.class.instance_variable_get(:@states)&.first
  end

  def current_state
    @state
  end
end

class Order
  include StateMachine

  state_machine do
    state :pending
    state :paid
    state :shipped
    state :delivered

    transition from: :pending, to: :paid, on: :pay
    transition from: :paid, to: :shipped, on: :ship
    transition from: :shipped, to: :delivered, on: :deliver
  end

  attr_accessor :number

  def initialize(number)
    @number = number
    super()
  end
end

order = Order.new("ORD-123")
puts "Order #{order.number} state: #{order.current_state}"
puts "Is pending? #{order.pending?}"

order.pay
puts "Current state: #{order.current_state}"
puts "Is paid? #{order.paid?}"

order.ship
order.deliver
puts "Final state: #{order.current_state}"

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "MODULES AND MIXINS - SUMMARY"
puts "=" * 50
puts "MODULE PURPOSES:"
puts "1. Namespace - Group related classes/constants"
puts "2. Mixin - Share functionality across classes"
puts "3. Module methods - Utility functions"
puts "\nINCLUDE VS EXTEND VS PREPEND:"
puts "• include: Adds module methods as instance methods"
puts "• extend: Adds module methods as class methods"
puts "• prepend: Adds methods before class methods in lookup chain"
puts "\nBENEFITS:"
puts "✓ Code reuse without inheritance"
puts "✓ Multiple mixins per class (multiple inheritance)"
puts "✓ Keeps code DRY"
puts "✓ Separates concerns"
puts "✓ Namespace organization"
puts "\nCOMMON PATTERNS:"
puts "• Comparable - Add comparison operators"
puts "• Enumerable - Add iteration methods"
puts "• Observable - Observer pattern implementation"
puts "• Timestampable - Add created_at/updated_at"
puts "• Loggable - Add logging capability"
puts "• Validatable - Add validation support"
puts "• Serializable - Add to_hash/to_json"
puts "\nHOOK METHODS:"
puts "• included(base) - Called when module included"
puts "• extended(base) - Called when module extended"
puts "• prepended(base) - Called when module prepended"
puts "\nMETHOD LOOKUP:"
puts "Prepended modules → Class → Included modules → Superclass"
puts "\nBEST PRACTICES:"
puts "✓ Use modules for shared behavior"
puts "✓ Keep modules focused (single responsibility)"
puts "✓ Use descriptive names ending in -able"
puts "✓ Document module dependencies"
puts "✓ Consider hook methods for setup"
puts "✓ Use super when overriding module methods"
puts "\nAVOID:"
puts "✗ Too many mixins (confusion)"
puts "✗ Mixins with state (prefer composition)"
puts "✗ Naming conflicts between modules"
puts "✗ Complex mixin hierarchies"
puts "=" * 50
