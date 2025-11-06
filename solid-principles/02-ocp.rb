# ========================================
# OPEN/CLOSED PRINCIPLE (OCP)
# ========================================
# "Software entities should be open for extension, but closed for modification."
# You should be able to add new functionality without changing existing code.

puts "=" * 50
puts "OPEN/CLOSED PRINCIPLE"
puts "=" * 50

# ========================================
# 1. VIOLATION OF OCP
# ========================================

puts "\n1. OCP Violation (Using Conditionals):"

# BAD: Need to modify class for each new shape
class AreaCalculatorBad
  def calculate(shapes)
    total_area = 0

    shapes.each do |shape|
      if shape[:type] == :circle
        total_area += Math::PI * shape[:radius]**2
      elsif shape[:type] == :rectangle
        total_area += shape[:width] * shape[:height]
      elsif shape[:type] == :triangle
        total_area += 0.5 * shape[:base] * shape[:height]
      # Need to add elsif for each new shape - VIOLATION!
      end
    end

    total_area
  end
end

shapes = [
  { type: :circle, radius: 5 },
  { type: :rectangle, width: 4, height: 6 }
]

calculator_bad = AreaCalculatorBad.new
puts "Total area (bad): #{calculator_bad.calculate(shapes).round(2)}"

puts "\nProblems:"
puts "✗ Must modify AreaCalculator for each new shape"
puts "✗ Growing if/elsif chain"
puts "✗ Violates OCP - not closed for modification"

# ========================================
# 2. FOLLOWING OCP (POLYMORPHISM)
# ========================================

puts "\n2. Following OCP (Using Polymorphism):"

# GOOD: Define interface
class Shape
  def area
    raise NotImplementedError, "Subclasses must implement area"
  end
end

# Concrete implementations
class Circle < Shape
  def initialize(radius)
    @radius = radius
  end

  def area
    Math::PI * @radius**2
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

# Calculator doesn't need modification for new shapes
class AreaCalculator
  def calculate(shapes)
    shapes.sum(&:area)
  end
end

shapes = [
  Circle.new(5),
  Rectangle.new(4, 6),
  Triangle.new(3, 4)
]

calculator = AreaCalculator.new
puts "Total area (good): #{calculator.calculate(shapes).round(2)}"

# Add new shape without modifying AreaCalculator!
class Square < Shape
  def initialize(side)
    @side = side
  end

  def area
    @side**2
  end
end

shapes << Square.new(5)
puts "With square: #{calculator.calculate(shapes).round(2)}"

puts "\nBenefits:"
puts "✓ Add new shapes without modifying AreaCalculator"
puts "✓ Each shape encapsulates its own logic"
puts "✓ Open for extension, closed for modification"

# ========================================
# 3. STRATEGY PATTERN (OCP)
# ========================================

puts "\n3. Strategy Pattern:"

# BAD: Modify PaymentProcessor for each payment method
class PaymentProcessorBad
  def process(amount, method)
    if method == :credit_card
      puts "Processing $#{amount} via credit card"
    elsif method == :paypal
      puts "Processing $#{amount} via PayPal"
    elsif method == :bitcoin
      puts "Processing $#{amount} via Bitcoin"
    # Add elsif for each new method - VIOLATION!
    end
  end
end

# GOOD: Strategy pattern
class PaymentStrategy
  def process(amount)
    raise NotImplementedError
  end
end

class CreditCardPayment < PaymentStrategy
  def process(amount)
    puts "CreditCard: Processing $#{amount}"
    { status: :success, method: :credit_card }
  end
end

class PayPalPayment < PaymentStrategy
  def process(amount)
    puts "PayPal: Processing $#{amount}"
    { status: :success, method: :paypal }
  end
end

class BitcoinPayment < PaymentStrategy
  def process(amount)
    puts "Bitcoin: Processing $#{amount}"
    { status: :success, method: :bitcoin }
  end
end

class PaymentProcessor
  def initialize(strategy)
    @strategy = strategy
  end

  def process(amount)
    @strategy.process(amount)
  end

  def change_strategy(strategy)
    @strategy = strategy
  end
end

puts "\nProcessing payments:"
processor = PaymentProcessor.new(CreditCardPayment.new)
processor.process(100)

processor.change_strategy(PayPalPayment.new)
processor.process(200)

# Add new payment method without modifying existing code
class ApplePayPayment < PaymentStrategy
  def process(amount)
    puts "ApplePay: Processing $#{amount}"
    { status: :success, method: :apple_pay }
  end
end

processor.change_strategy(ApplePayPayment.new)
processor.process(300)

# ========================================
# 4. DECORATOR PATTERN (OCP)
# ========================================

puts "\n4. Decorator Pattern:"

class Coffee
  def cost
    5
  end

  def description
    "Coffee"
  end
end

# Decorators extend functionality
class CoffeeDecorator
  def initialize(coffee)
    @coffee = coffee
  end

  def cost
    @coffee.cost
  end

  def description
    @coffee.description
  end
end

class MilkDecorator < CoffeeDecorator
  def cost
    @coffee.cost + 1
  end

  def description
    @coffee.description + ", Milk"
  end
end

class SugarDecorator < CoffeeDecorator
  def cost
    @coffee.cost + 0.5
  end

  def description
    @coffee.description + ", Sugar"
  end
end

class WhipDecorator < CoffeeDecorator
  def cost
    @coffee.cost + 1.5
  end

  def description
    @coffee.description + ", Whipped Cream"
  end
end

# Build coffee with decorators
coffee = Coffee.new
puts "#{coffee.description}: $#{coffee.cost}"

coffee_with_milk = MilkDecorator.new(coffee)
puts "#{coffee_with_milk.description}: $#{coffee_with_milk.cost}"

fancy_coffee = WhipDecorator.new(SugarDecorator.new(MilkDecorator.new(Coffee.new)))
puts "#{fancy_coffee.description}: $#{fancy_coffee.cost}"

# Add new decorator without modifying existing code
class CaramelDecorator < CoffeeDecorator
  def cost
    @coffee.cost + 2
  end

  def description
    @coffee.description + ", Caramel"
  end
end

super_fancy = CaramelDecorator.new(fancy_coffee)
puts "#{super_fancy.description}: $#{super_fancy.cost}"

# ========================================
# 5. NOTIFICATION SYSTEM
# ========================================

puts "\n5. Notification System:"

# BAD: Modify class for each notification type
class NotifierBad
  def notify(message, type)
    if type == :email
      puts "Email: #{message}"
    elsif type == :sms
      puts "SMS: #{message}"
    elsif type == :push
      puts "Push: #{message}"
    end
  end
end

# GOOD: Extensible notification system
class Notifier
  def notify(message)
    raise NotImplementedError
  end
end

class EmailNotifier < Notifier
  def notify(message)
    puts "📧 Email: #{message}"
  end
end

class SMSNotifier < Notifier
  def notify(message)
    puts "📱 SMS: #{message}"
  end
end

class PushNotifier < Notifier
  def notify(message)
    puts "🔔 Push: #{message}"
  end
end

class NotificationService
  def initialize
    @notifiers = []
  end

  def add_notifier(notifier)
    @notifiers << notifier
  end

  def send(message)
    @notifiers.each { |notifier| notifier.notify(message) }
  end
end

service = NotificationService.new
service.add_notifier(EmailNotifier.new)
service.add_notifier(SMSNotifier.new)

puts "\nSending notifications:"
service.send("Hello, World!")

# Add new notifier without modifying NotificationService
class SlackNotifier < Notifier
  def notify(message)
    puts "💬 Slack: #{message}"
  end
end

service.add_notifier(SlackNotifier.new)
puts "\nWith Slack added:"
service.send("New message!")

# ========================================
# 6. LOGGER WITH MULTIPLE OUTPUTS
# ========================================

puts "\n6. Logger System:"

class Logger
  def log(level, message)
    raise NotImplementedError
  end
end

class FileLogger < Logger
  def initialize(filename)
    @filename = filename
  end

  def log(level, message)
    puts "FileLogger[#{@filename}]: [#{level}] #{message}"
  end
end

class ConsoleLogger < Logger
  def log(level, message)
    puts "Console: [#{level}] #{message}"
  end
end

class RemoteLogger < Logger
  def initialize(endpoint)
    @endpoint = endpoint
  end

  def log(level, message)
    puts "Remote[#{@endpoint}]: [#{level}] #{message}"
  end
end

class MultiLogger
  def initialize
    @loggers = []
  end

  def add_logger(logger)
    @loggers << logger
  end

  def info(message)
    @loggers.each { |logger| logger.log(:INFO, message) }
  end

  def error(message)
    @loggers.each { |logger| logger.log(:ERROR, message) }
  end
end

multi_logger = MultiLogger.new
multi_logger.add_logger(ConsoleLogger.new)
multi_logger.add_logger(FileLogger.new("app.log"))
multi_logger.add_logger(RemoteLogger.new("https://logs.example.com"))

puts "\nLogging to multiple outputs:"
multi_logger.info("Application started")
multi_logger.error("An error occurred")

# ========================================
# 7. FILTER CHAIN
# ========================================

puts "\n7. Filter Chain:"

class Filter
  def apply(text)
    raise NotImplementedError
  end
end

class ProfanityFilter < Filter
  def apply(text)
    text.gsub(/badword/, "***")
  end
end

class HTMLFilter < Filter
  def apply(text)
    text.gsub(/<[^>]+>/, "")
  end
end

class TrimFilter < Filter
  def apply(text)
    text.strip
  end
end

class FilterChain
  def initialize
    @filters = []
  end

  def add_filter(filter)
    @filters << filter
  end

  def process(text)
    @filters.reduce(text) { |result, filter| filter.apply(result) }
  end
end

chain = FilterChain.new
chain.add_filter(HTMLFilter.new)
chain.add_filter(TrimFilter.new)
chain.add_filter(ProfanityFilter.new)

text = "  <b>Hello badword</b>  "
puts "\nOriginal: '#{text}'"
puts "Filtered: '#{chain.process(text)}'"

# Add new filter without modifying chain
class UppercaseFilter < Filter
  def apply(text)
    text.upcase
  end
end

chain.add_filter(UppercaseFilter.new)
puts "With uppercase: '#{chain.process(text)}'"

# ========================================
# 8. REPORT GENERATOR
# ========================================

puts "\n8. Report Generator:"

class ReportFormat
  def generate(data)
    raise NotImplementedError
  end
end

class PDFFormat < ReportFormat
  def generate(data)
    "PDF Report: #{data.inspect}"
  end
end

class HTMLFormat < ReportFormat
  def generate(data)
    "<html><body>#{data.inspect}</body></html>"
  end
end

class CSVFormat < ReportFormat
  def generate(data)
    data.map { |k, v| "#{k},#{v}" }.join("\n")
  end
end

class ReportGenerator
  def initialize(format)
    @format = format
  end

  def generate(data)
    @format.generate(data)
  end
end

data = { name: "John", age: 30, city: "NYC" }

puts "\nGenerating reports:"
puts ReportGenerator.new(PDFFormat.new).generate(data)
puts ReportGenerator.new(HTMLFormat.new).generate(data)
puts ReportGenerator.new(CSVFormat.new).generate(data)

# Add new format without modifying ReportGenerator
class JSONFormat < ReportFormat
  def generate(data)
    require 'json'
    data.to_json
  end
end

puts ReportGenerator.new(JSONFormat.new).generate(data)

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "OPEN/CLOSED PRINCIPLE - SUMMARY"
puts "=" * 50
puts "KEY CONCEPTS:"
puts "• Open for extension - can add new functionality"
puts "• Closed for modification - don't change existing code"
puts "• Use abstraction and polymorphism"
puts "• Prefer composition over modification"
puts "\nTECHNIQUES:"
puts "✓ Inheritance and polymorphism"
puts "✓ Strategy pattern"
puts "✓ Decorator pattern"
puts "✓ Template method pattern"
puts "✓ Plugin architectures"
puts "\nBENEFITS:"
puts "• Reduces risk of breaking existing code"
puts "• Easier to add new features"
puts "• More maintainable codebase"
puts "• Promotes loose coupling"
puts "\nRECOGNIZING VIOLATIONS:"
puts "✗ Long if/elsif/else chains for types"
puts "✗ Switch statements on type codes"
puts "✗ Modifying existing classes for new features"
puts "✗ Tight coupling to concrete classes"
puts "=" * 50
