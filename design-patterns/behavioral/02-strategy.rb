# ========================================
# STRATEGY PATTERN
# ========================================
# Defines a family of algorithms, encapsulates each one, and makes them interchangeable.
# Strategy lets the algorithm vary independently from clients that use it.

puts "=" * 50
puts "STRATEGY PATTERN"
puts "=" * 50

# ========================================
# 1. PROBLEM WITHOUT STRATEGY
# ========================================

puts "\n1. Problem - Hardcoded Algorithms:"

# BAD: All algorithms in one class with conditionals
class PaymentProcessorBad
  def process_payment(amount, method)
    if method == :credit_card
      puts "Processing $#{amount} with credit card"
      puts "Applying 3% fee"
      amount * 1.03
    elsif method == :paypal
      puts "Processing $#{amount} with PayPal"
      puts "Applying 2.5% fee"
      amount * 1.025
    elsif method == :bitcoin
      puts "Processing $#{amount} with Bitcoin"
      puts "Applying 1% fee"
      amount * 1.01
    else
      raise "Unknown payment method"
    end
  end
end

processor = PaymentProcessorBad.new
puts "Total: $#{processor.process_payment(100, :credit_card)}"

puts "\nProblem: Need to modify class for each new payment method"

# ========================================
# 2. STRATEGY PATTERN SOLUTION
# ========================================

puts "\n2. Strategy Pattern:"

# Strategy interface
class PaymentStrategy
  def process(amount)
    raise NotImplementedError
  end

  def fee_percentage
    raise NotImplementedError
  end
end

# Concrete strategies
class CreditCardStrategy < PaymentStrategy
  def process(amount)
    fee = amount * fee_percentage
    total = amount + fee
    puts "💳 Credit Card: Processing $#{amount}"
    puts "   Fee (#{fee_percentage * 100}%): $#{fee.round(2)}"
    total
  end

  def fee_percentage
    0.03
  end
end

class PayPalStrategy < PaymentStrategy
  def process(amount)
    fee = amount * fee_percentage
    total = amount + fee
    puts "💰 PayPal: Processing $#{amount}"
    puts "   Fee (#{fee_percentage * 100}%): $#{fee.round(2)}"
    total
  end

  def fee_percentage
    0.025
  end
end

class BitcoinStrategy < PaymentStrategy
  def process(amount)
    fee = amount * fee_percentage
    total = amount + fee
    puts "₿  Bitcoin: Processing $#{amount}"
    puts "   Fee (#{fee_percentage * 100}%): $#{fee.round(2)}"
    total
  end

  def fee_percentage
    0.01
  end
end

# Context
class PaymentProcessor
  def initialize(strategy)
    @strategy = strategy
  end

  def process_payment(amount)
    @strategy.process(amount)
  end

  def change_strategy(strategy)
    @strategy = strategy
  end
end

puts "Using different payment strategies:"
processor = PaymentProcessor.new(CreditCardStrategy.new)
total = processor.process_payment(100)
puts "Total: $#{total.round(2)}\n\n"

processor.change_strategy(PayPalStrategy.new)
total = processor.process_payment(100)
puts "Total: $#{total.round(2)}\n\n"

processor.change_strategy(BitcoinStrategy.new)
total = processor.process_payment(100)
puts "Total: $#{total.round(2)}"

# ========================================
# 3. SORTING STRATEGIES
# ========================================

puts "\n3. Sorting Strategies:"

class SortStrategy
  def sort(data)
    raise NotImplementedError
  end
end

class BubbleSortStrategy < SortStrategy
  def sort(data)
    puts "Using Bubble Sort"
    arr = data.dup
    n = arr.length
    (n - 1).times do |i|
      (n - i - 1).times do |j|
        arr[j], arr[j + 1] = arr[j + 1], arr[j] if arr[j] > arr[j + 1]
      end
    end
    arr
  end
end

class QuickSortStrategy < SortStrategy
  def sort(data)
    puts "Using Quick Sort"
    quick_sort(data.dup)
  end

  private

  def quick_sort(arr)
    return arr if arr.length <= 1

    pivot = arr.delete_at(arr.length / 2)
    left = arr.select { |x| x < pivot }
    right = arr.select { |x| x >= pivot }

    quick_sort(left) + [pivot] + quick_sort(right)
  end
end

class RubySortStrategy < SortStrategy
  def sort(data)
    puts "Using Ruby's built-in sort"
    data.sort
  end
end

class Sorter
  def initialize(strategy)
    @strategy = strategy
  end

  def sort(data)
    @strategy.sort(data)
  end

  def change_strategy(strategy)
    @strategy = strategy
  end
end

data = [64, 34, 25, 12, 22, 11, 90]

puts "Original: #{data}"

sorter = Sorter.new(BubbleSortStrategy.new)
puts "Sorted: #{sorter.sort(data)}\n\n"

sorter.change_strategy(QuickSortStrategy.new)
puts "Sorted: #{sorter.sort(data)}\n\n"

sorter.change_strategy(RubySortStrategy.new)
puts "Sorted: #{sorter.sort(data)}"

# ========================================
# 4. COMPRESSION STRATEGIES
# ========================================

puts "\n4. Compression Strategies:"

class CompressionStrategy
  def compress(file)
    raise NotImplementedError
  end
end

class ZipCompression < CompressionStrategy
  def compress(file)
    puts "🗜️  Compressing #{file} using ZIP"
    puts "   Compression ratio: 50%"
    "#{file}.zip"
  end
end

class RarCompression < CompressionStrategy
  def compress(file)
    puts "🗜️  Compressing #{file} using RAR"
    puts "   Compression ratio: 60%"
    "#{file}.rar"
  end
end

class GzipCompression < CompressionStrategy
  def compress(file)
    puts "🗜️  Compressing #{file} using GZIP"
    puts "   Compression ratio: 45%"
    "#{file}.gz"
  end
end

class FileCompressor
  def initialize(strategy)
    @strategy = strategy
  end

  def compress(file)
    @strategy.compress(file)
  end

  def set_compression(strategy)
    @strategy = strategy
  end
end

compressor = FileCompressor.new(ZipCompression.new)
puts compressor.compress("document.txt")

puts
compressor.set_compression(RarCompression.new)
puts compressor.compress("archive.tar")

puts
compressor.set_compression(GzipCompression.new)
puts compressor.compress("data.json")

# ========================================
# 5. NAVIGATION STRATEGIES
# ========================================

puts "\n5. Navigation Strategies:"

class RouteStrategy
  def calculate_route(from, to)
    raise NotImplementedError
  end
end

class CarRoute < RouteStrategy
  def calculate_route(from, to)
    puts "🚗 Car Route: #{from} → #{to}"
    puts "   Distance: 15 miles"
    puts "   Time: 25 minutes"
    puts "   Via: Highway 101"
  end
end

class WalkingRoute < RouteStrategy
  def calculate_route(from, to)
    puts "🚶 Walking Route: #{from} → #{to}"
    puts "   Distance: 2.5 miles"
    puts "   Time: 45 minutes"
    puts "   Via: Park Trail"
  end
end

class PublicTransitRoute < RouteStrategy
  def calculate_route(from, to)
    puts "🚌 Public Transit: #{from} → #{to}"
    puts "   Distance: 12 miles"
    puts "   Time: 40 minutes"
    puts "   Via: Bus 42 → Metro Red Line"
  end
end

class BikeRoute < RouteStrategy
  def calculate_route(from, to)
    puts "🚴 Bike Route: #{from} → #{to}"
    puts "   Distance: 8 miles"
    puts "   Time: 30 minutes"
    puts "   Via: Bike lanes"
  end
end

class Navigator
  def initialize(strategy)
    @strategy = strategy
  end

  def find_route(from, to)
    @strategy.calculate_route(from, to)
  end

  def change_mode(strategy)
    @strategy = strategy
  end
end

nav = Navigator.new(CarRoute.new)
nav.find_route("Home", "Office")

puts
nav.change_mode(WalkingRoute.new)
nav.find_route("Home", "Office")

puts
nav.change_mode(BikeRoute.new)
nav.find_route("Home", "Office")

# ========================================
# 6. DISCOUNT STRATEGIES
# ========================================

puts "\n6. Discount Strategies:"

class DiscountStrategy
  def calculate_discount(amount)
    raise NotImplementedError
  end
end

class NoDiscount < DiscountStrategy
  def calculate_discount(amount)
    { discount: 0, final: amount, description: "No discount" }
  end
end

class PercentageDiscount < DiscountStrategy
  def initialize(percentage)
    @percentage = percentage
  end

  def calculate_discount(amount)
    discount = amount * (@percentage / 100.0)
    {
      discount: discount,
      final: amount - discount,
      description: "#{@percentage}% off"
    }
  end
end

class FixedDiscount < DiscountStrategy
  def initialize(amount)
    @discount_amount = amount
  end

  def calculate_discount(amount)
    discount = [@discount_amount, amount].min
    {
      discount: discount,
      final: amount - discount,
      description: "$#{@discount_amount} off"
    }
  end
end

class BuyOneGetOneFree < DiscountStrategy
  def calculate_discount(amount)
    discount = amount * 0.5
    {
      discount: discount,
      final: amount - discount,
      description: "Buy One Get One Free (50% off)"
    }
  end
end

class ShoppingCart
  def initialize
    @items = []
    @discount_strategy = NoDiscount.new
  end

  def add_item(name, price)
    @items << { name: name, price: price }
  end

  def set_discount(strategy)
    @discount_strategy = strategy
  end

  def checkout
    subtotal = @items.sum { |item| item[:price] }
    result = @discount_strategy.calculate_discount(subtotal)

    puts "\n🛒 Shopping Cart:"
    @items.each { |item| puts "   - #{item[:name]}: $#{item[:price]}" }
    puts "   Subtotal: $#{subtotal}"
    puts "   Discount: -$#{result[:discount].round(2)} (#{result[:description]})"
    puts "   Total: $#{result[:final].round(2)}"

    result[:final]
  end
end

cart = ShoppingCart.new
cart.add_item("Laptop", 1000)
cart.add_item("Mouse", 50)
cart.add_item("Keyboard", 100)

cart.set_discount(NoDiscount.new)
cart.checkout

cart.set_discount(PercentageDiscount.new(20))
cart.checkout

cart.set_discount(FixedDiscount.new(100))
cart.checkout

cart.set_discount(BuyOneGetOneFree.new)
cart.checkout

# ========================================
# 7. VALIDATION STRATEGIES
# ========================================

puts "\n7. Validation Strategies:"

class ValidationStrategy
  def validate(value)
    raise NotImplementedError
  end
end

class EmailValidation < ValidationStrategy
  def validate(email)
    if email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      { valid: true, message: "Email is valid" }
    else
      { valid: false, message: "Invalid email format" }
    end
  end
end

class PhoneValidation < ValidationStrategy
  def validate(phone)
    if phone =~ /\A\d{3}-\d{3}-\d{4}\z/
      { valid: true, message: "Phone number is valid" }
    else
      { valid: false, message: "Invalid phone format (use XXX-XXX-XXXX)" }
    end
  end
end

class PasswordValidation < ValidationStrategy
  def validate(password)
    if password.length >= 8 && password =~ /[A-Z]/ && password =~ /[0-9]/
      { valid: true, message: "Password is strong" }
    else
      { valid: false, message: "Password must be 8+ chars with uppercase and number" }
    end
  end
end

class Validator
  def initialize(strategy)
    @strategy = strategy
  end

  def validate(value)
    result = @strategy.validate(value)
    puts "Validating '#{value}': #{result[:message]}"
    result[:valid]
  end
end

puts "Email validation:"
Validator.new(EmailValidation.new).validate("user@example.com")
Validator.new(EmailValidation.new).validate("invalid-email")

puts "\nPhone validation:"
Validator.new(PhoneValidation.new).validate("555-123-4567")
Validator.new(PhoneValidation.new).validate("5551234567")

puts "\nPassword validation:"
Validator.new(PasswordValidation.new).validate("SecurePass123")
Validator.new(PasswordValidation.new).validate("weak")

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "STRATEGY PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Define family of algorithms"
puts "• Encapsulate each algorithm"
puts "• Make them interchangeable"
puts "• Algorithm varies independently from clients"
puts "\nWHEN TO USE:"
puts "• Many related classes differ only in behavior"
puts "• Need different variants of an algorithm"
puts "• Algorithm uses data clients shouldn't know about"
puts "• Class has many conditional statements"
puts "\nBENEFITS:"
puts "✓ Open/Closed Principle"
puts "✓ Eliminates conditional statements"
puts "✓ Choose algorithms at runtime"
puts "✓ Isolate implementation details"
puts "✓ Replace inheritance with composition"
puts "\nDRAWBACKS:"
puts "✗ Clients must be aware of strategies"
puts "✗ Increased number of objects"
puts "✗ Communication overhead between strategy and context"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Payment processing"
puts "• Sorting algorithms"
puts "• Compression algorithms"
puts "• Routing/navigation"
puts "• Validation rules"
puts "• Discount calculations"
puts "=" * 50
