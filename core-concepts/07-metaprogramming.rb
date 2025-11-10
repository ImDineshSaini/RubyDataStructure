# ========================================
# METAPROGRAMMING IN RUBY
# ========================================
# Code that writes code. Ruby's dynamic nature makes metaprogramming powerful.
# Allows programs to modify themselves at runtime.

puts "=" * 50
puts "METAPROGRAMMING IN RUBY"
puts "=" * 50

# ========================================
# 1. DYNAMIC METHOD DEFINITION
# ========================================

puts "\n1. Dynamic Method Definition:"

class Person
  # Define getter and setter methods dynamically
  [:name, :age, :email].each do |attribute|
    define_method(attribute) do
      instance_variable_get("@#{attribute}")
    end

    define_method("#{attribute}=") do |value|
      instance_variable_set("@#{attribute}", value)
    end
  end
end

person = Person.new
person.name = "Alice"
person.age = 30
puts "#{person.name}, #{person.age}"

# ========================================
# 2. METHOD_MISSING
# ========================================

puts "\n2. method_missing - Ghost Methods:"

class DynamicRouter
  def method_missing(method_name, *args, &block)
    if method_name.to_s.start_with?('get_')
      resource = method_name.to_s.sub('get_', '')
      puts "GET /#{resource}"
    elsif method_name.to_s.start_with?('post_')
      resource = method_name.to_s.sub('post_', '')
      puts "POST /#{resource} with #{args.first}"
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('get_', 'post_') || super
  end
end

router = DynamicRouter.new
router.get_users
router.post_users({ name: "John" })
router.get_products

# ========================================
# 3. DEFINE_METHOD VS DEF
# ========================================

puts "\n3. define_method vs def:"

class Report
  # Using define_method - can use variables from surrounding scope
  %w[daily weekly monthly].each do |period|
    define_method("generate_#{period}_report") do
      puts "Generating #{period} report"
      period.upcase
    end
  end

  # Regular def - cannot access 'period' from loop
  # def generate_period_report
  #   puts period  # Error: undefined local variable
  # end
end

report = Report.new
report.generate_daily_report
report.generate_weekly_report
report.generate_monthly_report

# ========================================
# 4. CLASS_EVAL AND INSTANCE_EVAL
# ========================================

puts "\n4. class_eval and instance_eval:"

class MyClass
end

# class_eval - adds instance methods
MyClass.class_eval do
  def instance_method
    puts "Instance method added via class_eval"
  end
end

# instance_eval - adds class methods
MyClass.instance_eval do
  def class_method
    puts "Class method added via instance_eval"
  end
end

obj = MyClass.new
obj.instance_method
MyClass.class_method

# ========================================
# 5. SEND METHOD
# ========================================

puts "\n5. send - Calling Methods Dynamically:"

class Calculator
  def add(a, b)
    a + b
  end

  def subtract(a, b)
    a - b
  end

  def multiply(a, b)
    a * b
  end

  private

  def secret_method
    "This is secret!"
  end
end

calc = Calculator.new

# Call methods dynamically
operation = :add
result = calc.send(operation, 5, 3)
puts "#{operation}: #{result}"

# Send can even call private methods
puts calc.send(:secret_method)

# public_send only calls public methods
# calc.public_send(:secret_method)  # Error!

# ========================================
# 6. ATTR_ACCESSOR AND FRIENDS
# ========================================

puts "\n6. Creating Our Own attr_accessor:"

class Module
  def my_attr_accessor(*attributes)
    attributes.each do |attribute|
      # Getter
      define_method(attribute) do
        instance_variable_get("@#{attribute}")
      end

      # Setter
      define_method("#{attribute}=") do |value|
        instance_variable_set("@#{attribute}", value)
      end
    end
  end
end

class Book
  my_attr_accessor :title, :author, :isbn
end

book = Book.new
book.title = "Ruby Metaprogramming"
book.author = "Expert"
puts "#{book.title} by #{book.author}"

# ========================================
# 7. HOOKS (CALLBACKS)
# ========================================

puts "\n7. Hooks and Callbacks:"

class BaseClass
  def self.inherited(subclass)
    puts "#{subclass} inherited from #{self}"
  end
end

class ChildClass < BaseClass
end

module Loggable
  def self.included(base)
    puts "Loggable included in #{base}"
    base.extend(ClassMethods)
  end

  module ClassMethods
    def log_method(method_name)
      original_method = instance_method(method_name)

      define_method(method_name) do |*args, &block|
        puts "Calling #{method_name} with #{args}"
        result = original_method.bind(self).call(*args, &block)
        puts "#{method_name} returned #{result}"
        result
      end
    end
  end
end

class Service
  include Loggable

  def process(data)
    data.upcase
  end

  log_method :process
end

service = Service.new
service.process("hello")

# ========================================
# 8. SINGLETON METHODS
# ========================================

puts "\n8. Singleton Methods:"

str = "hello"

# Define method on single object
def str.shout
  upcase + "!!!"
end

puts str.shout

# Other strings don't have this method
other_str = "world"
# other_str.shout  # Error: undefined method

# ========================================
# 9. METHOD ALIASING
# ========================================

puts "\n9. Method Aliasing:"

class String
  alias_method :original_reverse, :reverse

  def reverse
    puts "Reversing string..."
    original_reverse
  end
end

puts "hello".reverse

# ========================================
# 10. DYNAMIC CLASS CREATION
# ========================================

puts "\n10. Dynamic Class Creation:"

# Create class at runtime
DynamicClass = Class.new do
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def greet
    "Hello, I'm #{@name}"
  end
end

obj = DynamicClass.new("Dynamic")
puts obj.greet

# ========================================
# 11. CONST_MISSING
# ========================================

puts "\n11. const_missing - Lazy Constants:"

class Module
  def const_missing(name)
    puts "Constant #{name} is missing, creating it..."
    const_set(name, "DynamicallyCreated#{name}")
  end
end

puts MissingConstant  # Automatically created!

# ========================================
# 12. PRACTICAL EXAMPLE: VALIDATIONS
# ========================================

puts "\n12. Practical: Validation Framework:"

module Validatable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def validates_presence_of(*attributes)
      attributes.each do |attribute|
        define_method("validate_#{attribute}") do
          value = send(attribute)
          if value.nil? || value.to_s.empty?
            errors << "#{attribute} cannot be blank"
          end
        end
      end
    end

    def validates_format_of(attribute, options = {})
      define_method("validate_#{attribute}") do
        value = send(attribute)
        unless value.to_s.match?(options[:with])
          errors << "#{attribute} has invalid format"
        end
      end
    end
  end

  def errors
    @errors ||= []
  end

  def valid?
    @errors = []
    methods.grep(/^validate_/).each { |method| send(method) }
    @errors.empty?
  end
end

class User
  include Validatable

  attr_accessor :name, :email, :age

  validates_presence_of :name, :email
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def initialize(name, email, age)
    @name = name
    @email = email
    @age = age
  end
end

user1 = User.new("John", "john@example.com", 30)
puts "\nUser 1 valid? #{user1.valid?}"

user2 = User.new("", "invalid-email", 25)
puts "User 2 valid? #{user2.valid?}"
puts "Errors: #{user2.errors.join(', ')}"

# ========================================
# 13. PRACTICAL: DSL (Domain Specific Language)
# ========================================

puts "\n13. Practical: Building a DSL:"

class RouteMapper
  def initialize
    @routes = []
  end

  def get(path, &block)
    @routes << { method: :get, path: path, handler: block }
  end

  def post(path, &block)
    @routes << { method: :post, path: path, handler: block }
  end

  def match(method, path)
    route = @routes.find { |r| r[:method] == method && r[:path] == path }
    route[:handler].call if route
  end

  def self.draw(&block)
    mapper = new
    mapper.instance_eval(&block)
    mapper
  end
end

routes = RouteMapper.draw do
  get '/users' do
    puts "Fetching all users"
  end

  post '/users' do
    puts "Creating new user"
  end

  get '/products' do
    puts "Fetching all products"
  end
end

routes.match(:get, '/users')
routes.match(:post, '/users')

# ========================================
# 14. PRACTICAL: LAZY ATTRIBUTES
# ========================================

puts "\n14. Practical: Lazy Attributes:"

module LazyAttributes
  def lazy_attr(name, &block)
    define_method(name) do
      var_name = "@#{name}"
      return instance_variable_get(var_name) if instance_variable_defined?(var_name)

      value = instance_eval(&block)
      instance_variable_set(var_name, value)
      value
    end
  end
end

class ExpensiveComputation
  extend LazyAttributes

  lazy_attr :expensive_data do
    puts "Computing expensive data (only happens once)..."
    sleep(0.1)
    "Expensive Result"
  end
end

comp = ExpensiveComputation.new
puts "First call:"
puts comp.expensive_data
puts "Second call (cached):"
puts comp.expensive_data

# ========================================
# 15. PRACTICAL: DELEGATION
# ========================================

puts "\n15. Practical: Delegation Pattern:"

module Delegatable
  def delegate(*methods, to:)
    methods.each do |method|
      define_method(method) do |*args, &block|
        target = send(to)
        target.send(method, *args, &block)
      end
    end
  end
end

class Order
  extend Delegatable

  attr_reader :customer

  delegate :name, :email, to: :customer

  def initialize(customer)
    @customer = customer
  end
end

Customer = Struct.new(:name, :email)
customer = Customer.new("Alice", "alice@example.com")
order = Order.new(customer)

puts "Order customer name: #{order.name}"
puts "Order customer email: #{order.email}"

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "METAPROGRAMMING - SUMMARY"
puts "=" * 50
puts "KEY TECHNIQUES:"
puts "• define_method - Define methods dynamically"
puts "• method_missing - Handle undefined methods"
puts "• class_eval/instance_eval - Evaluate code in context"
puts "• send/public_send - Call methods dynamically"
puts "• class/module hooks - inherited, included, extended"
puts "• const_missing - Handle missing constants"
puts "\nCOMMON USES:"
puts "• DSLs (Domain Specific Languages)"
puts "• Validations and callbacks"
puts "• Delegation and decorators"
puts "• ORMs (like ActiveRecord)"
puts "• Testing frameworks"
puts "\nBEST PRACTICES:"
puts "✓ Use sparingly - can make code hard to understand"
puts "✓ Document metaprogrammed code well"
puts "✓ Prefer simpler solutions when possible"
puts "✓ Consider performance implications"
puts "✓ Implement respond_to_missing? with method_missing"
puts "\nWARNINGS:"
puts "✗ Can make code hard to debug"
puts "✗ Can impact performance"
puts "✗ Can break IDE/editor features"
puts "✗ Harder for static analysis"
puts "=" * 50
