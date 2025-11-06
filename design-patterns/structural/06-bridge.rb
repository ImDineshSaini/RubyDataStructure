# ========================================
# BRIDGE PATTERN
# ========================================
# Decouples an abstraction from its implementation so that the two can vary independently.
# Separates the interface from the implementation.

puts "=" * 50
puts "BRIDGE PATTERN"
puts "=" * 50

# ========================================
# 1. PROBLEM WITHOUT BRIDGE
# ========================================

puts "\n1. Problem - Class Explosion:"

# BAD: Need a class for every combination of abstraction and implementation
class RedCircle
  def draw(x, y, radius)
    puts "Drawing red circle at (#{x},#{y}) with radius #{radius}"
  end
end

class BlueCircle
  def draw(x, y, radius)
    puts "Drawing blue circle at (#{x},#{y}) with radius #{radius}"
  end
end

class RedSquare
  def draw(x, y, side)
    puts "Drawing red square at (#{x},#{y}) with side #{side}"
  end
end

class BlueSquare
  def draw(x, y, side)
    puts "Drawing blue square at (#{x},#{y}) with side #{side}"
  end
end

# What if we add green? Need GreenCircle, GreenSquare, etc.
# What if we add Triangle? Need RedTriangle, BlueTriangle, GreenTriangle...
# This leads to class explosion!

puts "Without bridge (class explosion):"
RedCircle.new.draw(10, 10, 5)
BlueSquare.new.draw(20, 20, 8)

# ========================================
# 2. BRIDGE PATTERN SOLUTION
# ========================================

puts "\n2. Bridge Pattern:"

# Implementation interface
class Color
  def apply_color
    raise NotImplementedError
  end
end

# Concrete implementations
class Red < Color
  def apply_color
    puts "   🔴 Applying red color"
  end
end

class Blue < Color
  def apply_color
    puts "   🔵 Applying blue color"
  end
end

class Green < Color
  def apply_color
    puts "   🟢 Applying green color"
  end
end

# Abstraction
class Shape
  def initialize(color)
    @color = color
  end

  def draw
    raise NotImplementedError
  end
end

# Refined abstractions
class Circle < Shape
  def initialize(x, y, radius, color)
    super(color)
    @x = x
    @y = y
    @radius = radius
  end

  def draw
    puts "Drawing circle at (#{@x},#{@y}) with radius #{@radius}"
    @color.apply_color
  end
end

class Square < Shape
  def initialize(x, y, side, color)
    super(color)
    @x = x
    @y = y
    @side = side
  end

  def draw
    puts "Drawing square at (#{@x},#{@y}) with side #{@side}"
    @color.apply_color
  end
end

class Triangle < Shape
  def initialize(x, y, base, height, color)
    super(color)
    @x = x
    @y = y
    @base = base
    @height = height
  end

  def draw
    puts "Drawing triangle at (#{@x},#{@y}) base=#{@base}, height=#{@height}"
    @color.apply_color
  end
end

puts "Using bridge pattern:"
red = Red.new
blue = Blue.new
green = Green.new

Circle.new(10, 10, 5, red).draw
Square.new(20, 20, 8, blue).draw
Triangle.new(30, 30, 6, 10, green).draw

puts "\nEasily add new colors or shapes without class explosion!"

# ========================================
# 3. DEVICE AND REMOTE CONTROL
# ========================================

puts "\n3. Device and Remote Control:"

# Implementation - Device interface
class Device
  def is_enabled
    raise NotImplementedError
  end

  def enable
    raise NotImplementedError
  end

  def disable
    raise NotImplementedError
  end

  def get_volume
    raise NotImplementedError
  end

  def set_volume(percent)
    raise NotImplementedError
  end

  def get_channel
    raise NotImplementedError
  end

  def set_channel(channel)
    raise NotImplementedError
  end
end

# Concrete implementations
class TV < Device
  def initialize
    @on = false
    @volume = 30
    @channel = 1
  end

  def is_enabled
    @on
  end

  def enable
    @on = true
    puts "📺 TV is now ON"
  end

  def disable
    @on = false
    puts "📺 TV is now OFF"
  end

  def get_volume
    @volume
  end

  def set_volume(percent)
    @volume = percent
    puts "📺 TV volume set to #{@volume}%"
  end

  def get_channel
    @channel
  end

  def set_channel(channel)
    @channel = channel
    puts "📺 TV channel set to #{@channel}"
  end
end

class Radio < Device
  def initialize
    @on = false
    @volume = 20
    @channel = 88
  end

  def is_enabled
    @on
  end

  def enable
    @on = true
    puts "📻 Radio is now ON"
  end

  def disable
    @on = false
    puts "📻 Radio is now OFF"
  end

  def get_volume
    @volume
  end

  def set_volume(percent)
    @volume = percent
    puts "📻 Radio volume set to #{@volume}%"
  end

  def get_channel
    @channel
  end

  def set_channel(channel)
    @channel = channel
    puts "📻 Radio tuned to #{@channel} FM"
  end
end

# Abstraction - Remote Control
class RemoteControl
  def initialize(device)
    @device = device
  end

  def toggle_power
    if @device.is_enabled
      @device.disable
    else
      @device.enable
    end
  end

  def volume_up
    @device.set_volume(@device.get_volume + 10)
  end

  def volume_down
    @device.set_volume(@device.get_volume - 10)
  end

  def channel_up
    @device.set_channel(@device.get_channel + 1)
  end

  def channel_down
    @device.set_channel(@device.get_channel - 1)
  end
end

# Advanced remote - Refined abstraction
class AdvancedRemoteControl < RemoteControl
  def mute
    puts "🔇 Muting..."
    @device.set_volume(0)
  end

  def set_channel_direct(channel)
    @device.set_channel(channel)
  end
end

puts "Using remotes with different devices:"
tv = TV.new
remote = RemoteControl.new(tv)
remote.toggle_power
remote.volume_up
remote.channel_up

puts "\nAdvanced remote with radio:"
radio = Radio.new
advanced_remote = AdvancedRemoteControl.new(radio)
advanced_remote.toggle_power
advanced_remote.set_channel_direct(95)
advanced_remote.mute

# ========================================
# 4. MESSAGING PLATFORMS
# ========================================

puts "\n4. Messaging Across Platforms:"

# Implementation - Platform interface
class MessagingPlatform
  def send_message(message)
    raise NotImplementedError
  end

  def send_image(image_path)
    raise NotImplementedError
  end
end

# Concrete implementations
class EmailPlatform < MessagingPlatform
  def send_message(message)
    puts "📧 Sending email: #{message}"
  end

  def send_image(image_path)
    puts "📧 Sending email with attachment: #{image_path}"
  end
end

class SMSPlatform < MessagingPlatform
  def send_message(message)
    puts "📱 Sending SMS: #{message[0..50]}..."
  end

  def send_image(image_path)
    puts "📱 Sending MMS with image: #{image_path}"
  end
end

class SlackPlatform < MessagingPlatform
  def send_message(message)
    puts "💬 Posting to Slack: #{message}"
  end

  def send_image(image_path)
    puts "💬 Uploading to Slack: #{image_path}"
  end
end

# Abstraction - Message types
class Message
  def initialize(platform)
    @platform = platform
  end

  def send
    raise NotImplementedError
  end
end

# Refined abstractions
class TextMessage < Message
  def initialize(platform, text)
    super(platform)
    @text = text
  end

  def send
    @platform.send_message(@text)
  end
end

class ImageMessage < Message
  def initialize(platform, image_path, caption)
    super(platform)
    @image_path = image_path
    @caption = caption
  end

  def send
    @platform.send_message(@caption) if @caption
    @platform.send_image(@image_path)
  end
end

class UrgentMessage < Message
  def initialize(platform, text)
    super(platform)
    @text = text
  end

  def send
    @platform.send_message("⚠️ URGENT: #{@text}")
  end
end

puts "Sending messages across platforms:"
email = EmailPlatform.new
sms = SMSPlatform.new
slack = SlackPlatform.new

TextMessage.new(email, "Hello from email").send
TextMessage.new(sms, "Hello from SMS").send
ImageMessage.new(slack, "screenshot.png", "Check this out!").send
UrgentMessage.new(sms, "Server is down!").send

# ========================================
# 5. DATABASE ABSTRACTION
# ========================================

puts "\n5. Database Operations:"

# Implementation - Database drivers
class DatabaseDriver
  def connect(connection_string)
    raise NotImplementedError
  end

  def execute(query)
    raise NotImplementedError
  end

  def close
    raise NotImplementedError
  end
end

# Concrete implementations
class MySQLDriver < DatabaseDriver
  def connect(connection_string)
    puts "🔌 Connecting to MySQL: #{connection_string}"
  end

  def execute(query)
    puts "🗄️  MySQL executing: #{query}"
    ["row1", "row2", "row3"]
  end

  def close
    puts "🔒 Closing MySQL connection"
  end
end

class PostgreSQLDriver < DatabaseDriver
  def connect(connection_string)
    puts "🔌 Connecting to PostgreSQL: #{connection_string}"
  end

  def execute(query)
    puts "🗄️  PostgreSQL executing: #{query}"
    ["row1", "row2"]
  end

  def close
    puts "🔒 Closing PostgreSQL connection"
  end
end

class MongoDBDriver < DatabaseDriver
  def connect(connection_string)
    puts "🔌 Connecting to MongoDB: #{connection_string}"
  end

  def execute(query)
    puts "🗄️  MongoDB executing: #{query}"
    [{ doc: 1 }, { doc: 2 }]
  end

  def close
    puts "🔒 Closing MongoDB connection"
  end
end

# Abstraction - Database operations
class Database
  def initialize(driver, connection_string)
    @driver = driver
    @driver.connect(connection_string)
  end

  def query(sql)
    @driver.execute(sql)
  end

  def disconnect
    @driver.close
  end
end

# Refined abstraction - Repository
class UserRepository < Database
  def find_all
    puts "📋 Finding all users"
    query("SELECT * FROM users")
  end

  def find_by_id(id)
    puts "🔍 Finding user by ID: #{id}"
    query("SELECT * FROM users WHERE id = #{id}")
  end

  def create(user_data)
    puts "➕ Creating user: #{user_data}"
    query("INSERT INTO users VALUES #{user_data}")
  end
end

puts "Using different database drivers:"
mysql_users = UserRepository.new(MySQLDriver.new, "mysql://localhost/myapp")
mysql_users.find_all
mysql_users.disconnect

puts "\nSwitching to PostgreSQL:"
pg_users = UserRepository.new(PostgreSQLDriver.new, "postgres://localhost/myapp")
pg_users.find_by_id(123)
pg_users.disconnect

# ========================================
# 6. RENDERING ENGINES
# ========================================

puts "\n6. Rendering with Different Engines:"

# Implementation - Rendering engines
class Renderer
  def render_circle(x, y, radius)
    raise NotImplementedError
  end

  def render_rectangle(x, y, width, height)
    raise NotImplementedError
  end
end

# Concrete implementations
class VectorRenderer < Renderer
  def render_circle(x, y, radius)
    puts "   🎨 Vector: Drawing circle at (#{x},#{y}) r=#{radius}"
  end

  def render_rectangle(x, y, width, height)
    puts "   🎨 Vector: Drawing rectangle at (#{x},#{y}) #{width}x#{height}"
  end
end

class RasterRenderer < Renderer
  def render_circle(x, y, radius)
    puts "   🖼️  Raster: Rendering pixels for circle at (#{x},#{y}) r=#{radius}"
  end

  def render_rectangle(x, y, width, height)
    puts "   🖼️  Raster: Rendering pixels for rectangle at (#{x},#{y}) #{width}x#{height}"
  end
end

class ThreeDRenderer < Renderer
  def render_circle(x, y, radius)
    puts "   🎲 3D: Rendering sphere at (#{x},#{y},0) r=#{radius}"
  end

  def render_rectangle(x, y, width, height)
    puts "   🎲 3D: Rendering box at (#{x},#{y},0) #{width}x#{height}x10"
  end
end

# Abstraction - Shapes
class RenderableShape
  def initialize(renderer)
    @renderer = renderer
  end

  def draw
    raise NotImplementedError
  end

  def resize(factor)
    raise NotImplementedError
  end
end

# Refined abstractions
class RenderableCircle < RenderableShape
  def initialize(x, y, radius, renderer)
    super(renderer)
    @x = x
    @y = y
    @radius = radius
  end

  def draw
    @renderer.render_circle(@x, @y, @radius)
  end

  def resize(factor)
    @radius *= factor
    puts "🔄 Circle resized to radius #{@radius}"
  end
end

class RenderableRectangle < RenderableShape
  def initialize(x, y, width, height, renderer)
    super(renderer)
    @x = x
    @y = y
    @width = width
    @height = height
  end

  def draw
    @renderer.render_rectangle(@x, @y, @width, @height)
  end

  def resize(factor)
    @width *= factor
    @height *= factor
    puts "🔄 Rectangle resized to #{@width}x#{@height}"
  end
end

puts "Rendering with different engines:"
vector = VectorRenderer.new
raster = RasterRenderer.new
three_d = ThreeDRenderer.new

circle1 = RenderableCircle.new(10, 10, 5, vector)
circle1.draw

circle2 = RenderableCircle.new(20, 20, 8, raster)
circle2.draw

rect = RenderableRectangle.new(30, 30, 15, 20, three_d)
rect.draw
rect.resize(2)
rect.draw

# ========================================
# 7. PAYMENT PROCESSING
# ========================================

puts "\n7. Payment Processing:"

# Implementation - Payment gateways
class PaymentGateway
  def process_payment(amount)
    raise NotImplementedError
  end

  def refund(transaction_id)
    raise NotImplementedError
  end
end

# Concrete implementations
class StripeGateway < PaymentGateway
  def process_payment(amount)
    puts "💳 Processing $#{amount} through Stripe"
    { success: true, transaction_id: "stripe_#{rand(10000)}" }
  end

  def refund(transaction_id)
    puts "💵 Refunding via Stripe: #{transaction_id}"
    { success: true }
  end
end

class PayPalGateway < PaymentGateway
  def process_payment(amount)
    puts "💰 Processing $#{amount} through PayPal"
    { success: true, transaction_id: "paypal_#{rand(10000)}" }
  end

  def refund(transaction_id)
    puts "💵 Refunding via PayPal: #{transaction_id}"
    { success: true }
  end
end

class BraintreeGateway < PaymentGateway
  def process_payment(amount)
    puts "🏦 Processing $#{amount} through Braintree"
    { success: true, transaction_id: "braintree_#{rand(10000)}" }
  end

  def refund(transaction_id)
    puts "💵 Refunding via Braintree: #{transaction_id}"
    { success: true }
  end
end

# Abstraction - Payment types
class Payment
  def initialize(gateway)
    @gateway = gateway
  end

  def execute(amount)
    raise NotImplementedError
  end
end

# Refined abstractions
class OneTimePayment < Payment
  def execute(amount)
    puts "🛒 Processing one-time payment"
    @gateway.process_payment(amount)
  end
end

class RecurringPayment < Payment
  def initialize(gateway, interval)
    super(gateway)
    @interval = interval
  end

  def execute(amount)
    puts "🔄 Setting up recurring payment (#{@interval})"
    @gateway.process_payment(amount)
  end
end

class SplitPayment < Payment
  def initialize(gateway, split_count)
    super(gateway)
    @split_count = split_count
  end

  def execute(amount)
    installment = amount / @split_count
    puts "📊 Processing split payment (#{@split_count} installments of $#{installment})"
    @gateway.process_payment(installment)
  end
end

puts "Different payment types with different gateways:"
OneTimePayment.new(StripeGateway.new).execute(100)
RecurringPayment.new(PayPalGateway.new, "monthly").execute(29.99)
SplitPayment.new(BraintreeGateway.new, 4).execute(400)

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "BRIDGE PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Decouple abstraction from implementation"
puts "• Let both vary independently"
puts "• Avoid class explosion from combinations"
puts "• Prefer composition over inheritance"
puts "\nWHEN TO USE:"
puts "• Avoid permanent binding between abstraction and implementation"
puts "• Both abstraction and implementation should be extensible"
puts "• Changes in implementation shouldn't affect clients"
puts "• Want to share implementation among multiple objects"
puts "• Class explosion from combinations (N abstractions × M implementations)"
puts "\nCOMPONENTS:"
puts "• Abstraction: High-level interface"
puts "• Refined Abstraction: Extends abstraction"
puts "• Implementation: Interface for concrete implementations"
puts "• Concrete Implementation: Actual implementations"
puts "\nBENEFITS:"
puts "✓ Decouples interface from implementation"
puts "✓ Improves extensibility (add abstractions or implementations)"
puts "✓ Hides implementation details from clients"
puts "✓ Avoids combinatorial explosion of classes"
puts "✓ Single Responsibility Principle"
puts "✓ Open/Closed Principle"
puts "✓ Can change implementation at runtime"
puts "\nDRAWBACKS:"
puts "✗ Increases complexity"
puts "✗ More indirection"
puts "✗ Overkill for simple scenarios"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Device drivers (abstraction) vs platforms (implementation)"
puts "• Shapes (abstraction) vs rendering (implementation)"
puts "• Remote controls (abstraction) vs devices (implementation)"
puts "• Message types (abstraction) vs platforms (implementation)"
puts "• Database repositories (abstraction) vs drivers (implementation)"
puts "• UI widgets across different OS platforms"
puts "\nBRIDGE VS ADAPTER:"
puts "• Bridge: Designed upfront to separate interface from implementation"
puts "• Adapter: Created after to make incompatible interfaces work together"
puts "• Bridge: Both sides designed to be extended"
puts "• Adapter: Usually wraps existing code"
puts "=" * 50
