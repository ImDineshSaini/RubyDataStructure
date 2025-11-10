# ========================================
# LISKOV SUBSTITUTION PRINCIPLE (LSP)
# ========================================
# "Objects of a superclass should be replaceable with objects of its subclasses
# without breaking the application."
# Subtypes must be substitutable for their base types.

puts "=" * 50
puts "LISKOV SUBSTITUTION PRINCIPLE"
puts "=" * 50

# ========================================
# 1. VIOLATION OF LSP
# ========================================

puts "\n1. LSP Violation (Square/Rectangle Problem):"

# BAD: Square violates LSP when inheriting from Rectangle
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

class SquareBad < Rectangle
  def width=(value)
    @width = value
    @height = value  # Violates LSP - unexpected side effect
  end

  def height=(value)
    @width = value
    @height = value  # Violates LSP - unexpected side effect
  end
end

def test_rectangle(rect)
  rect.width = 5
  rect.height = 4
  expected_area = 5 * 4  # 20
  actual_area = rect.area

  puts "Expected: #{expected_area}, Actual: #{actual_area}"
  puts "Test #{expected_area == actual_area ? 'PASSED' : 'FAILED'}"
end

puts "\nTesting Rectangle:"
test_rectangle(Rectangle.new(0, 0))  # PASSED

puts "\nTesting Square (violates LSP):"
test_rectangle(SquareBad.new(0, 0))  # FAILED - Square breaks the test!

puts "\nProblem: Square cannot substitute Rectangle without breaking behavior"

# ========================================
# 2. FOLLOWING LSP
# ========================================

puts "\n2. Following LSP (Proper Design):"

# GOOD: Use common interface, don't force inheritance
class Shape
  def area
    raise NotImplementedError
  end
end

class Rectangle < Shape
  attr_accessor :width, :height

  def initialize(width, height)
    @width = width
    @height = height
  end

  def area
    @width * @height
  end
end

class Square < Shape
  attr_accessor :side

  def initialize(side)
    @side = side
  end

  def area
    @side * @side
  end
end

def calculate_area(shape)
  puts "Area: #{shape.area}"
end

puts "\nUsing common interface:"
calculate_area(Rectangle.new(5, 4))  # Works
calculate_area(Square.new(5))        # Works

puts "✓ Both can substitute Shape without breaking behavior"

# ========================================
# 3. BIRD EXAMPLE
# ========================================

puts "\n3. Bird Example:"

# BAD: Penguin can't fly but inherits from Bird
class BirdBad
  def fly
    puts "Flying in the sky"
  end
end

class SparrowBad < BirdBad
  # Inherits fly - OK
end

class PenguinBad < BirdBad
  def fly
    raise "Penguins can't fly!"  # Violates LSP
  end
end

puts "Testing birds (bad design):"
begin
  sparrow = SparrowBad.new
  sparrow.fly  # OK

  penguin = PenguinBad.new
  penguin.fly  # BREAKS - violates LSP
rescue => e
  puts "Error: #{e.message}"
end

# GOOD: Separate concerns
class Bird
  def eat
    puts "Eating..."
  end
end

module Flyable
  def fly
    puts "Flying in the sky"
  end
end

class Sparrow < Bird
  include Flyable
end

class Penguin < Bird
  def swim
    puts "Swimming in water"
  end
end

puts "\nTesting birds (good design):"
sparrow = Sparrow.new
sparrow.fly  # OK

penguin = Penguin.new
penguin.swim  # OK - uses appropriate behavior

# ========================================
# 4. SUBSTITUTABILITY TEST
# ========================================

puts "\n4. Substitutability Test:"

class Vehicle
  def start_engine
    puts "Engine started"
    true
  end

  def accelerate
    puts "Accelerating"
  end
end

class Car < Vehicle
  # Properly extends Vehicle
  def accelerate
    puts "Car accelerating smoothly"
  end
end

class Bicycle < Vehicle
  def start_engine
    # Violates LSP - bicycle has no engine!
    puts "Bicycle has no engine"
    false
  end
end

def test_vehicle(vehicle)
  if vehicle.start_engine
    vehicle.accelerate
  else
    puts "Cannot accelerate - engine failed to start"
  end
end

puts "\nTesting vehicles:"
puts "Car:"
test_vehicle(Car.new)  # Works as expected

puts "\nBicycle (violates LSP):"
test_vehicle(Bicycle.new)  # Breaks contract

# GOOD: Proper hierarchy
class Vehicle
  def move
    raise NotImplementedError
  end
end

class Motorized < Vehicle
  def start_engine
    puts "Engine started"
  end

  def move
    start_engine
    puts "Moving with engine"
  end
end

class Manual < Vehicle
  def move
    puts "Moving manually"
  end
end

class Car < Motorized
end

class Bicycle < Manual
end

puts "\nProper design:"
[Car.new, Bicycle.new].each { |v| v.move }

# ========================================
# 5. COLLECTION EXAMPLE
# ========================================

puts "\n5. Collection Example:"

class Collection
  def initialize
    @items = []
  end

  def add(item)
    @items << item
  end

  def remove(item)
    @items.delete(item)
  end

  def count
    @items.size
  end
end

# BAD: ImmutableCollection violates LSP
class ImmutableCollectionBad < Collection
  def add(item)
    raise "Cannot modify immutable collection"  # Breaks contract
  end

  def remove(item)
    raise "Cannot modify immutable collection"  # Breaks contract
  end
end

# GOOD: Separate interface
module Countable
  def count
    raise NotImplementedError
  end
end

class MutableCollection
  include Countable

  def initialize
    @items = []
  end

  def add(item)
    @items << item
  end

  def remove(item)
    @items.delete(item)
  end

  def count
    @items.size
  end
end

class ImmutableCollection
  include Countable

  def initialize(items)
    @items = items.freeze
  end

  def count
    @items.size
  end
end

puts "Using proper design:"
mutable = MutableCollection.new
mutable.add(1)
puts "Mutable count: #{mutable.count}"

immutable = ImmutableCollection.new([1, 2, 3])
puts "Immutable count: #{immutable.count}"

# ========================================
# 6. PRECONDITIONS AND POSTCONDITIONS
# ========================================

puts "\n6. Preconditions and Postconditions:"

class Account
  attr_reader :balance

  def initialize(balance)
    @balance = balance
  end

  # Precondition: amount > 0
  # Postcondition: balance decreases by amount
  def withdraw(amount)
    raise "Amount must be positive" if amount <= 0
    raise "Insufficient funds" if amount > @balance

    @balance -= amount
  end
end

# BAD: Subclass weakens precondition (wrong!)
class NoFeeAccount < Account
  def withdraw(amount)
    # Allows negative amounts - WEAKENS precondition
    @balance -= amount if amount > 0
  end
end

# BAD: Subclass strengthens postcondition (wrong!)
class LimitedAccount < Account
  def withdraw(amount)
    raise "Amount must be positive" if amount <= 0
    raise "Insufficient funds" if amount > @balance
    raise "Daily limit exceeded" if amount > 100  # STRENGTHENS postcondition

    @balance -= amount
  end
end

# GOOD: Subclass maintains contract
class PremiumAccount < Account
  def initialize(balance, credit_limit)
    super(balance)
    @credit_limit = credit_limit
  end

  def withdraw(amount)
    raise "Amount must be positive" if amount <= 0
    raise "Insufficient funds" if amount > (@balance + @credit_limit)

    @balance -= amount
  end
end

puts "Testing accounts:"
account = Account.new(100)
account.withdraw(50)
puts "Regular account balance: #{account.balance}"

premium = PremiumAccount.new(100, 50)
premium.withdraw(120)  # Uses credit
puts "Premium account balance: #{premium.balance}"

# ========================================
# 7. FACTORY PATTERN WITH LSP
# ========================================

puts "\n7. Factory Pattern with LSP:"

class Database
  def connect
    raise NotImplementedError
  end

  def query(sql)
    raise NotImplementedError
  end

  def close
    raise NotImplementedError
  end
end

class MySQL < Database
  def connect
    puts "MySQL: Connected"
  end

  def query(sql)
    puts "MySQL: Executing #{sql}"
    []
  end

  def close
    puts "MySQL: Closed"
  end
end

class PostgreSQL < Database
  def connect
    puts "PostgreSQL: Connected"
  end

  def query(sql)
    puts "PostgreSQL: Executing #{sql}"
    []
  end

  def close
    puts "PostgreSQL: Closed"
  end
end

class MongoDB < Database
  def connect
    puts "MongoDB: Connected"
  end

  def query(sql)
    puts "MongoDB: Executing #{sql}"
    []
  end

  def close
    puts "MongoDB: Closed"
  end
end

def run_migration(database)
  database.connect
  database.query("CREATE TABLE users")
  database.query("INSERT INTO users VALUES (...)")
  database.close
end

puts "\nRunning migrations (all databases substitutable):"
run_migration(MySQL.new)
run_migration(PostgreSQL.new)
run_migration(MongoDB.new)

# ========================================
# 8. TESTING LSP COMPLIANCE
# ========================================

puts "\n8. Testing LSP Compliance:"

class PaymentMethod
  def process(amount)
    puts "Processing $#{amount}"
    { success: true, transaction_id: rand(1000) }
  end
end

class CreditCard < PaymentMethod
  def process(amount)
    puts "Credit Card: Processing $#{amount}"
    { success: true, transaction_id: rand(1000) }
  end
end

class PayPal < PaymentMethod
  def process(amount)
    puts "PayPal: Processing $#{amount}"
    { success: true, transaction_id: rand(1000) }
  end
end

def checkout(payment_method, amount)
  result = payment_method.process(amount)
  if result[:success]
    puts "Payment successful! Transaction ID: #{result[:transaction_id]}"
  else
    puts "Payment failed!"
  end
end

puts "\nCheckout with different payment methods:"
checkout(CreditCard.new, 100)
checkout(PayPal.new, 200)

# Both work perfectly - LSP satisfied!

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "LISKOV SUBSTITUTION PRINCIPLE - SUMMARY"
puts "=" * 50
puts "KEY CONCEPTS:"
puts "• Subtypes must be substitutable for base types"
puts "• Child classes should enhance, not replace behavior"
puts "• Maintain the contract of the base class"
puts "• Don't weaken preconditions"
puts "• Don't strengthen postconditions"
puts "\nCOMMON VIOLATIONS:"
puts "✗ Throwing exceptions in overridden methods"
puts "✗ Returning different types than base class"
puts "✗ Weakening preconditions (accepting more)"
puts "✗ Strengthening postconditions (promising less)"
puts "✗ Changing expected behavior"
puts "\nHOW TO FOLLOW LSP:"
puts "✓ Design by contract"
puts "✓ Use composition over inheritance"
puts "✓ Extract common interfaces"
puts "✓ Use mixins for optional behavior"
puts "✓ Test substitutability"
puts "\nBENEFITS:"
puts "• More reliable inheritance hierarchies"
puts "• Predictable behavior"
puts "• Easier to extend"
puts "• Better polymorphism"
puts "=" * 50
