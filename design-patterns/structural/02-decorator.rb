# ========================================
# DECORATOR PATTERN
# ========================================
# Attaches additional responsibilities to an object dynamically.
# Decorators provide a flexible alternative to subclassing for extending functionality.

puts "=" * 50
puts "DECORATOR PATTERN"
puts "=" * 50

# ========================================
# 1. PROBLEM WITHOUT DECORATOR
# ========================================

puts "\n1. Problem - Subclass Explosion:"

# BAD: Need a class for every combination
class Coffee
  def cost
    5
  end

  def description
    "Coffee"
  end
end

class CoffeeWithMilk < Coffee
  def cost
    super + 1
  end

  def description
    super + ", Milk"
  end
end

class CoffeeWithMilkAndSugar < CoffeeWithMilk
  def cost
    super + 0.5
  end

  def description
    super + ", Sugar"
  end
end

# What if we want milk, sugar, whip, and caramel?
# Need exponentially more classes!

puts "Without decorator (class explosion):"
coffee = CoffeeWithMilkAndSugar.new
puts "#{coffee.description}: $#{coffee.cost}"

# ========================================
# 2. DECORATOR PATTERN SOLUTION
# ========================================

puts "\n2. Decorator Pattern:"

class SimpleCoffee
  def cost
    5
  end

  def description
    "Coffee"
  end
end

# Base decorator
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

# Concrete decorators
class MilkDecorator < CoffeeDecorator
  def cost
    @coffee.cost + 1
  end

  def description
    "#{@coffee.description}, Milk"
  end
end

class SugarDecorator < CoffeeDecorator
  def cost
    @coffee.cost + 0.5
  end

  def description
    "#{@coffee.description}, Sugar"
  end
end

class WhipDecorator < CoffeeDecorator
  def cost
    @coffee.cost + 1.5
  end

  def description
    "#{@coffee.description}, Whipped Cream"
  end
end

class CaramelDecorator < CoffeeDecorator
  def cost
    @coffee.cost + 2
  end

  def description
    "#{@coffee.description}, Caramel"
  end
end

class VanillaDecorator < CoffeeDecorator
  def cost
    @coffee.cost + 1.5
  end

  def description
    "#{@coffee.description}, Vanilla"
  end
end

# Build any combination!
puts "Building coffee with decorators:"

coffee = SimpleCoffee.new
puts "#{coffee.description}: $#{coffee.cost}"

coffee = MilkDecorator.new(SimpleCoffee.new)
puts "#{coffee.description}: $#{coffee.cost}"

coffee = SugarDecorator.new(MilkDecorator.new(SimpleCoffee.new))
puts "#{coffee.description}: $#{coffee.cost}"

fancy_coffee = CaramelDecorator.new(
  VanillaDecorator.new(
    WhipDecorator.new(
      SugarDecorator.new(
        MilkDecorator.new(
          SimpleCoffee.new
        )
      )
    )
  )
)
puts "#{fancy_coffee.description}: $#{fancy_coffee.cost}"

# ========================================
# 3. TEXT FORMATTING
# ========================================

puts "\n3. Text Formatting Decorators:"

class PlainText
  def initialize(text)
    @text = text
  end

  def render
    @text
  end
end

class TextDecorator
  def initialize(text_component)
    @text_component = text_component
  end

  def render
    @text_component.render
  end
end

class BoldDecorator < TextDecorator
  def render
    "<b>#{@text_component.render}</b>"
  end
end

class ItalicDecorator < TextDecorator
  def render
    "<i>#{@text_component.render}</i>"
  end
end

class UnderlineDecorator < TextDecorator
  def render
    "<u>#{@text_component.render}</u>"
  end
end

class ColorDecorator < TextDecorator
  def initialize(text_component, color)
    super(text_component)
    @color = color
  end

  def render
    "<span style='color:#{@color}'>#{@text_component.render}</span>"
  end
end

text = PlainText.new("Hello, World!")
puts "Plain: #{text.render}"

bold_text = BoldDecorator.new(PlainText.new("Hello, World!"))
puts "Bold: #{bold_text.render}"

fancy_text = ColorDecorator.new(
  UnderlineDecorator.new(
    ItalicDecorator.new(
      BoldDecorator.new(
        PlainText.new("Hello, World!")
      )
    )
  ),
  "red"
)
puts "Fancy: #{fancy_text.render}"

# ========================================
# 4. STREAM/FILE DECORATORS
# ========================================

puts "\n4. Stream Decorators:"

class FileStream
  def initialize(filename)
    @filename = filename
  end

  def write(data)
    puts "Writing to #{@filename}: #{data}"
  end
end

class StreamDecorator
  def initialize(stream)
    @stream = stream
  end

  def write(data)
    @stream.write(data)
  end
end

class CompressionDecorator < StreamDecorator
  def write(data)
    compressed = compress(data)
    puts "  [Compression] Reduced size by 50%"
    @stream.write(compressed)
  end

  private

  def compress(data)
    "COMPRESSED(#{data})"
  end
end

class EncryptionDecorator < StreamDecorator
  def write(data)
    encrypted = encrypt(data)
    puts "  [Encryption] Data encrypted"
    @stream.write(encrypted)
  end

  private

  def encrypt(data)
    "ENCRYPTED(#{data})"
  end
end

class LoggingDecorator < StreamDecorator
  def write(data)
    puts "  [Logging] Writing #{data.length} bytes at #{Time.now}"
    @stream.write(data)
  end
end

# Stack decorators
puts "File stream with decorators:"
stream = FileStream.new("output.txt")
stream.write("Hello, World!")

puts "\nWith logging:"
stream = LoggingDecorator.new(FileStream.new("output.txt"))
stream.write("Hello, World!")

puts "\nWith compression and encryption:"
stream = EncryptionDecorator.new(
  CompressionDecorator.new(
    FileStream.new("output.txt")
  )
)
stream.write("Hello, World!")

puts "\nWith all decorators:"
stream = LoggingDecorator.new(
  EncryptionDecorator.new(
    CompressionDecorator.new(
      FileStream.new("output.txt")
    )
  )
)
stream.write("Hello, World!")

# ========================================
# 5. NOTIFICATION DECORATORS
# ========================================

puts "\n5. Notification Decorators:"

class Notifier
  def send(message)
    puts "📧 Email: #{message}"
  end
end

class NotifierDecorator
  def initialize(notifier)
    @notifier = notifier
  end

  def send(message)
    @notifier.send(message)
  end
end

class SMSDecorator < NotifierDecorator
  def send(message)
    super
    puts "📱 SMS: #{message}"
  end
end

class SlackDecorator < NotifierDecorator
  def send(message)
    super
    puts "💬 Slack: #{message}"
  end
end

class FacebookDecorator < NotifierDecorator
  def send(message)
    super
    puts "👥 Facebook: #{message}"
  end
end

puts "Notifying through multiple channels:"
notifier = Notifier.new
notifier.send("Server is down!")

puts "\nWith SMS:"
notifier = SMSDecorator.new(Notifier.new)
notifier.send("Server is down!")

puts "\nWith all channels:"
notifier = FacebookDecorator.new(
  SlackDecorator.new(
    SMSDecorator.new(
      Notifier.new
    )
  )
)
notifier.send("Server is down!")

# ========================================
# 6. WINDOW/UI DECORATORS
# ========================================

puts "\n6. UI Window Decorators:"

class Window
  def render
    puts "Rendering basic window"
  end
end

class WindowDecorator
  def initialize(window)
    @window = window
  end

  def render
    @window.render
  end
end

class ScrollbarDecorator < WindowDecorator
  def render
    super
    puts "  + Adding scrollbars"
  end
end

class BorderDecorator < WindowDecorator
  def initialize(window, border_width)
    super(window)
    @border_width = border_width
  end

  def render
    super
    puts "  + Adding #{@border_width}px border"
  end
end

class ShadowDecorator < WindowDecorator
  def render
    super
    puts "  + Adding drop shadow"
  end
end

puts "Rendering windows:"
window = Window.new
window.render

puts "\nWith scrollbars:"
window = ScrollbarDecorator.new(Window.new)
window.render

puts "\nFully decorated:"
window = ShadowDecorator.new(
  BorderDecorator.new(
    ScrollbarDecorator.new(
      Window.new
    ),
    5
  )
)
window.render

# ========================================
# 7. RUBY MODULE-BASED DECORATOR
# ========================================

puts "\n7. Ruby Module-Based Decorator:"

class Pizza
  def cost
    10
  end

  def description
    "Pizza"
  end
end

module Cheese
  def cost
    super + 2
  end

  def description
    super + " + Cheese"
  end
end

module Pepperoni
  def cost
    super + 3
  end

  def description
    super + " + Pepperoni"
  end
end

module Mushrooms
  def cost
    super + 1.5
  end

  def description
    super + " + Mushrooms"
  end
end

# Decorate using modules
pizza = Pizza.new
pizza.extend(Cheese)
pizza.extend(Pepperoni)
pizza.extend(Mushrooms)

puts "#{pizza.description}: $#{pizza.cost}"

# ========================================
# 8. REQUEST/RESPONSE DECORATORS
# ========================================

puts "\n8. HTTP Request Decorators:"

class HttpRequest
  def execute
    puts "Executing HTTP request"
    { status: 200, body: "Response" }
  end
end

class RequestDecorator
  def initialize(request)
    @request = request
  end

  def execute
    @request.execute
  end
end

class AuthDecorator < RequestDecorator
  def execute
    puts "  [Auth] Adding authentication headers"
    super
  end
end

class RetryDecorator < RequestDecorator
  def execute
    puts "  [Retry] Will retry on failure (max 3 attempts)"
    super
  rescue => e
    puts "  [Retry] Request failed, retrying..."
    super
  end
end

class CacheDecorator < RequestDecorator
  def initialize(request)
    super
    @cache = {}
  end

  def execute
    if @cache[:response]
      puts "  [Cache] Returning cached response"
      return @cache[:response]
    end

    puts "  [Cache] Cache miss, executing request"
    @cache[:response] = super
  end
end

class LoggingDecorator < RequestDecorator
  def execute
    puts "  [Log] Starting request at #{Time.now}"
    result = super
    puts "  [Log] Request completed at #{Time.now}"
    result
  end
end

puts "HTTP request with decorators:"
request = LoggingDecorator.new(
  CacheDecorator.new(
    RetryDecorator.new(
      AuthDecorator.new(
        HttpRequest.new
      )
    )
  )
)
request.execute

puts "\nSecond request (should use cache):"
request.execute

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "DECORATOR PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Attach additional responsibilities dynamically"
puts "• Provide flexible alternative to subclassing"
puts "• Wrap objects to add behavior"
puts "\nWHEN TO USE:"
puts "• Add responsibilities to objects dynamically"
puts "• Responsibilities can be withdrawn"
puts "• Extension by subclassing is impractical"
puts "• Need to add features to legacy code"
puts "\nBENEFITS:"
puts "✓ More flexibility than static inheritance"
puts "✓ Avoid feature-laden classes high in hierarchy"
puts "✓ Add/remove responsibilities at runtime"
puts "✓ Combine behaviors by stacking decorators"
puts "✓ Single Responsibility Principle"
puts "\nDRAWBACKS:"
puts "✗ Lots of small objects"
puts "✗ Decorators can be difficult to debug"
puts "✗ Order of decorators matters"
puts "✗ Hard to remove specific decorator from stack"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Java I/O streams (BufferedReader, etc.)"
puts "• Coffee shop (milk, sugar, whip, etc.)"
puts "• UI components (borders, scrollbars, shadows)"
puts "• Middleware in web frameworks"
puts "• Notifications (email, SMS, Slack, etc.)"
puts "=" * 50
