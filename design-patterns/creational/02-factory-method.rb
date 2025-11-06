# ========================================
# FACTORY METHOD PATTERN
# ========================================
# Defines an interface for creating an object, but lets subclasses decide
# which class to instantiate. Factory Method lets a class defer instantiation to subclasses.

puts "=" * 50
puts "FACTORY METHOD PATTERN"
puts "=" * 50

# ========================================
# 1. BASIC FACTORY METHOD
# ========================================

puts "\n1. Basic Factory Method:"

# Without factory
class Circle
  def draw
    puts "Drawing a Circle"
  end
end

class Square
  def draw
    puts "Drawing a Square"
  end
end

# With factory method
class ShapeFactory
  def create_shape(type)
    case type
    when :circle
      Circle.new
    when :square
      Square.new
    else
      raise "Unknown shape type: #{type}"
    end
  end
end

factory = ShapeFactory.new
circle = factory.create_shape(:circle)
circle.draw

square = factory.create_shape(:square)
square.draw

# ========================================
# 2. ABSTRACT CREATOR
# ========================================

puts "\n2. Abstract Creator Pattern:"

# Abstract creator
class Document
  def initialize
    @pages = []
  end

  # Factory method (to be overridden)
  def create_page
    raise NotImplementedError, "Subclasses must implement create_page"
  end

  def add_page
    page = create_page
    @pages << page
    puts "Added #{page.class} to document"
    page
  end

  def pages
    @pages
  end
end

# Concrete pages
class ResumePage
  def content
    "Resume content"
  end
end

class ReportPage
  def content
    "Report content"
  end
end

# Concrete creators
class Resume < Document
  def create_page
    ResumePage.new
  end
end

class Report < Document
  def create_page
    ReportPage.new
  end
end

puts "\nCreating resume:"
resume = Resume.new
resume.add_page
resume.add_page

puts "\nCreating report:"
report = Report.new
report.add_page

# ========================================
# 3. LOGISTICS EXAMPLE
# ========================================

puts "\n3. Logistics Example:"

# Abstract product
class Transport
  def deliver
    raise NotImplementedError
  end
end

# Concrete products
class Truck < Transport
  def deliver
    puts "🚚 Delivering by land in a truck"
  end
end

class Ship < Transport
  def deliver
    puts "🚢 Delivering by sea in a ship"
  end
end

class Plane < Transport
  def deliver
    puts "✈️  Delivering by air in a plane"
  end
end

# Abstract creator
class Logistics
  def plan_delivery
    transport = create_transport
    transport.deliver
  end

  # Factory method
  def create_transport
    raise NotImplementedError
  end
end

# Concrete creators
class RoadLogistics < Logistics
  def create_transport
    Truck.new
  end
end

class SeaLogistics < Logistics
  def create_transport
    Ship.new
  end
end

class AirLogistics < Logistics
  def create_transport
    Plane.new
  end
end

puts "Planning deliveries:"
RoadLogistics.new.plan_delivery
SeaLogistics.new.plan_delivery
AirLogistics.new.plan_delivery

# ========================================
# 4. NOTIFICATION SYSTEM
# ========================================

puts "\n4. Notification System:"

# Abstract product
class Notification
  def send(message)
    raise NotImplementedError
  end
end

# Concrete products
class EmailNotification < Notification
  def send(message)
    puts "📧 Sending email: #{message}"
  end
end

class SMSNotification < Notification
  def send(message)
    puts "📱 Sending SMS: #{message}"
  end
end

class PushNotification < Notification
  def send(message)
    puts "🔔 Sending push notification: #{message}"
  end
end

# Creator with factory method
class NotificationService
  def notify(message, channel)
    notification = create_notification(channel)
    notification.send(message)
  end

  private

  def create_notification(channel)
    case channel
    when :email
      EmailNotification.new
    when :sms
      SMSNotification.new
    when :push
      PushNotification.new
    else
      raise "Unknown notification channel: #{channel}"
    end
  end
end

service = NotificationService.new
puts "Sending notifications:"
service.notify("Welcome!", :email)
service.notify("Verification code: 123456", :sms)
service.notify("New message received", :push)

# ========================================
# 5. DATABASE CONNECTION
# ========================================

puts "\n5. Database Connection Factory:"

class DatabaseConnection
  def connect
    raise NotImplementedError
  end

  def query(sql)
    raise NotImplementedError
  end
end

class MySQLConnection < DatabaseConnection
  def connect
    puts "MySQL: Connecting to database..."
  end

  def query(sql)
    puts "MySQL: Executing '#{sql}'"
  end
end

class PostgreSQLConnection < DatabaseConnection
  def connect
    puts "PostgreSQL: Connecting to database..."
  end

  def query(sql)
    puts "PostgreSQL: Executing '#{sql}'"
  end
end

class MongoDBConnection < DatabaseConnection
  def connect
    puts "MongoDB: Connecting to database..."
  end

  def query(sql)
    puts "MongoDB: Executing '#{sql}'"
  end
end

class DatabaseFactory
  def self.create_connection(type)
    case type
    when :mysql
      MySQLConnection.new
    when :postgresql
      PostgreSQLConnection.new
    when :mongodb
      MongoDBConnection.new
    else
      raise "Unknown database type: #{type}"
    end
  end
end

puts "Database connections:"
db = DatabaseFactory.create_connection(:mysql)
db.connect
db.query("SELECT * FROM users")

db = DatabaseFactory.create_connection(:postgresql)
db.connect
db.query("SELECT * FROM users")

# ========================================
# 6. PAYMENT PROCESSING
# ========================================

puts "\n6. Payment Processing:"

class Payment
  def process(amount)
    raise NotImplementedError
  end
end

class CreditCardPayment < Payment
  def process(amount)
    puts "Processing $#{amount} via Credit Card"
    { status: :success, method: :credit_card, amount: amount }
  end
end

class PayPalPayment < Payment
  def process(amount)
    puts "Processing $#{amount} via PayPal"
    { status: :success, method: :paypal, amount: amount }
  end
end

class BitcoinPayment < Payment
  def process(amount)
    puts "Processing $#{amount} via Bitcoin"
    { status: :success, method: :bitcoin, amount: amount }
  end
end

class PaymentFactory
  def self.create_payment(method)
    case method
    when :credit_card
      CreditCardPayment.new
    when :paypal
      PayPalPayment.new
    when :bitcoin
      BitcoinPayment.new
    else
      raise "Unknown payment method: #{method}"
    end
  end
end

puts "Processing payments:"
payment = PaymentFactory.create_payment(:credit_card)
payment.process(100)

payment = PaymentFactory.create_payment(:paypal)
payment.process(200)

# ========================================
# 7. LOGGER FACTORY
# ========================================

puts "\n7. Logger Factory:"

class Logger
  def log(message)
    raise NotImplementedError
  end
end

class FileLogger < Logger
  def initialize(filename)
    @filename = filename
  end

  def log(message)
    puts "FileLogger[#{@filename}]: #{message}"
  end
end

class ConsoleLogger < Logger
  def log(message)
    puts "Console: #{message}"
  end
end

class RemoteLogger < Logger
  def initialize(endpoint)
    @endpoint = endpoint
  end

  def log(message)
    puts "Remote[#{@endpoint}]: #{message}"
  end
end

class LoggerFactory
  def self.create_logger(type, *args)
    case type
    when :file
      FileLogger.new(args[0] || "app.log")
    when :console
      ConsoleLogger.new
    when :remote
      RemoteLogger.new(args[0] || "https://logs.example.com")
    else
      raise "Unknown logger type: #{type}"
    end
  end
end

puts "Logging with different loggers:"
logger = LoggerFactory.create_logger(:file, "myapp.log")
logger.log("Application started")

logger = LoggerFactory.create_logger(:console)
logger.log("Debug message")

logger = LoggerFactory.create_logger(:remote, "https://logger.io")
logger.log("Error occurred")

# ========================================
# 8. PARAMETERIZED FACTORY METHOD
# ========================================

puts "\n8. Parameterized Factory Method:"

class Enemy
  def attack
    raise NotImplementedError
  end
end

class Goblin < Enemy
  def initialize(level)
    @level = level
  end

  def attack
    puts "Goblin (lvl #{@level}) attacks with #{@level * 5} damage"
  end
end

class Dragon < Enemy
  def initialize(level)
    @level = level
  end

  def attack
    puts "Dragon (lvl #{@level}) attacks with #{@level * 20} damage"
  end
end

class Zombie < Enemy
  def initialize(level)
    @level = level
  end

  def attack
    puts "Zombie (lvl #{@level}) attacks with #{@level * 3} damage"
  end
end

class Game
  def spawn_enemy(type, level)
    enemy = create_enemy(type, level)
    puts "Spawned #{enemy.class}"
    enemy
  end

  private

  def create_enemy(type, level)
    case type
    when :goblin
      Goblin.new(level)
    when :dragon
      Dragon.new(level)
    when :zombie
      Zombie.new(level)
    else
      raise "Unknown enemy type: #{type}"
    end
  end
end

game = Game.new
puts "Spawning enemies:"
goblin = game.spawn_enemy(:goblin, 5)
goblin.attack

dragon = game.spawn_enemy(:dragon, 10)
dragon.attack

zombie = game.spawn_enemy(:zombie, 3)
zombie.attack

# ========================================
# 9. REGISTRATION-BASED FACTORY
# ========================================

puts "\n9. Registration-Based Factory:"

class PluginFactory
  @plugins = {}

  def self.register(name, klass)
    @plugins[name] = klass
  end

  def self.create(name, *args)
    plugin_class = @plugins[name]
    raise "Plugin not registered: #{name}" unless plugin_class

    plugin_class.new(*args)
  end

  def self.registered_plugins
    @plugins.keys
  end
end

class Plugin
  def execute
    raise NotImplementedError
  end
end

class CachePlugin < Plugin
  def execute
    puts "Cache plugin: Clearing cache"
  end
end

class LogPlugin < Plugin
  def execute
    puts "Log plugin: Rotating logs"
  end
end

class BackupPlugin < Plugin
  def execute
    puts "Backup plugin: Creating backup"
  end
end

# Register plugins
PluginFactory.register(:cache, CachePlugin)
PluginFactory.register(:log, LogPlugin)
PluginFactory.register(:backup, BackupPlugin)

puts "Registered plugins: #{PluginFactory.registered_plugins}"
puts "\nExecuting plugins:"

plugin = PluginFactory.create(:cache)
plugin.execute

plugin = PluginFactory.create(:log)
plugin.execute

plugin = PluginFactory.create(:backup)
plugin.execute

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "FACTORY METHOD PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Define interface for creating objects"
puts "• Let subclasses decide which class to instantiate"
puts "• Defer instantiation to subclasses"
puts "\nWHEN TO USE:"
puts "• Class can't anticipate type of objects to create"
puts "• Class wants subclasses to specify objects to create"
puts "• Need to delegate responsibility to helper subclasses"
puts "\nBENEFITS:"
puts "✓ Eliminates need to bind application-specific classes"
puts "✓ Code deals with interfaces, not implementations"
puts "✓ Provides hooks for subclasses"
puts "✓ Connects parallel class hierarchies"
puts "\nDRAWBACKS:"
puts "✗ Can require creating many subclasses"
puts "✗ Code may become more complicated"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Document creation (Word, PDF, HTML)"
puts "• Database connections (MySQL, PostgreSQL)"
puts "• UI element creation (Button, TextField)"
puts "• Logistics planning (Truck, Ship, Plane)"
puts "=" * 50
