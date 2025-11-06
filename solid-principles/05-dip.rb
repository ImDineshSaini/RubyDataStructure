# ========================================
# DEPENDENCY INVERSION PRINCIPLE (DIP)
# ========================================
# "High-level modules should not depend on low-level modules.
# Both should depend on abstractions."
# "Abstractions should not depend on details. Details should depend on abstractions."

puts "=" * 50
puts "DEPENDENCY INVERSION PRINCIPLE"
puts "=" * 50

# ========================================
# 1. VIOLATION OF DIP
# ========================================

puts "\n1. DIP Violation (Tight Coupling):"

# BAD: High-level class directly depends on low-level classes
class MySQLDatabase
  def save(data)
    puts "MySQLDatabase: Saving #{data} to MySQL"
  end

  def find(id)
    puts "MySQLDatabase: Finding record #{id} in MySQL"
    { id: id, data: "MySQL data" }
  end
end

class UserServiceBad
  def initialize
    @database = MySQLDatabase.new  # Tightly coupled to MySQL
  end

  def create_user(user_data)
    @database.save(user_data)
    puts "User created"
  end

  def get_user(id)
    @database.find(id)
  end
end

service_bad = UserServiceBad.new
service_bad.create_user("John Doe")

puts "\nProblems:"
puts "✗ UserService is tightly coupled to MySQLDatabase"
puts "✗ Can't easily switch to PostgreSQL or MongoDB"
puts "✗ Difficult to test (need real MySQL)"
puts "✗ High-level module depends on low-level module"

# ========================================
# 2. FOLLOWING DIP WITH ABSTRACTION
# ========================================

puts "\n2. Following DIP (Loose Coupling):"

# GOOD: Define abstraction (interface)
module Database
  def save(data)
    raise NotImplementedError
  end

  def find(id)
    raise NotImplementedError
  end
end

# Low-level implementations
class MySQLDatabase
  include Database

  def save(data)
    puts "MySQLDatabase: Saving #{data}"
  end

  def find(id)
    puts "MySQLDatabase: Finding #{id}"
    { id: id, source: 'mysql' }
  end
end

class PostgreSQLDatabase
  include Database

  def save(data)
    puts "PostgreSQLDatabase: Saving #{data}"
  end

  def find(id)
    puts "PostgreSQLDatabase: Finding #{id}"
    { id: id, source: 'postgresql' }
  end
end

class MongoDatabase
  include Database

  def save(data)
    puts "MongoDatabase: Saving #{data}"
  end

  def find(id)
    puts "MongoDatabase: Finding #{id}"
    { id: id, source: 'mongo' }
  end
end

# High-level module depends on abstraction
class UserService
  def initialize(database)
    @database = database  # Depends on abstraction, not concrete class
  end

  def create_user(user_data)
    @database.save(user_data)
    puts "User created via #{@database.class}"
  end

  def get_user(id)
    @database.find(id)
  end
end

# Easy to switch implementations
puts "\nUsing MySQL:"
mysql_service = UserService.new(MySQLDatabase.new)
mysql_service.create_user("Alice")

puts "\nUsing PostgreSQL:"
postgres_service = UserService.new(PostgreSQLDatabase.new)
postgres_service.create_user("Bob")

puts "\nUsing MongoDB:"
mongo_service = UserService.new(MongoDatabase.new)
mongo_service.create_user("Charlie")

puts "\nBenefits:"
puts "✓ Loose coupling - easy to switch implementations"
puts "✓ Easy to test with mock database"
puts "✓ Both high and low level depend on abstraction"
puts "✓ Open for extension, closed for modification"

# ========================================
# 3. DEPENDENCY INJECTION
# ========================================

puts "\n3. Dependency Injection:"

# Constructor Injection
class OrderProcessor
  def initialize(payment_gateway, notifier)
    @payment_gateway = payment_gateway
    @notifier = notifier
  end

  def process(order)
    if @payment_gateway.charge(order.amount)
      @notifier.send("Order processed: #{order.id}")
      true
    else
      @notifier.send("Payment failed: #{order.id}")
      false
    end
  end
end

class StripeGateway
  def charge(amount)
    puts "StripeGateway: Charging $#{amount}"
    true
  end
end

class PayPalGateway
  def charge(amount)
    puts "PayPalGateway: Charging $#{amount}"
    true
  end
end

class EmailNotifier
  def send(message)
    puts "EmailNotifier: #{message}"
  end
end

class SMSNotifier
  def send(message)
    puts "SMSNotifier: #{message}"
  end
end

# Inject dependencies
Order = Struct.new(:id, :amount)
order = Order.new(123, 99.99)

puts "\nWith Stripe and Email:"
processor1 = OrderProcessor.new(StripeGateway.new, EmailNotifier.new)
processor1.process(order)

puts "\nWith PayPal and SMS:"
processor2 = OrderProcessor.new(PayPalGateway.new, SMSNotifier.new)
processor2.process(order)

# ========================================
# 4. DUCK TYPING (Ruby's Way)
# ========================================

puts "\n4. Duck Typing in Ruby:"

# In Ruby, we don't need explicit interfaces
# Objects just need to respond to the same methods

class FileLogger
  def log(message)
    puts "FileLogger: Writing to file - #{message}"
  end
end

class ConsoleLogger
  def log(message)
    puts "ConsoleLogger: #{message}"
  end
end

class RemoteLogger
  def log(message)
    puts "RemoteLogger: Sending to server - #{message}"
  end
end

class Application
  def initialize(logger)
    @logger = logger
  end

  def run
    @logger.log("Application started")
    # Do work...
    @logger.log("Application finished")
  end
end

# Works with any logger that responds to 'log'
puts "\nDuck typing - any logger works:"
Application.new(FileLogger.new).run
Application.new(ConsoleLogger.new).run
Application.new(RemoteLogger.new).run

# ========================================
# 5. PRACTICAL EXAMPLE: EMAIL SERVICE
# ========================================

puts "\n5. Email Service Example:"

# Abstract interface
module EmailProvider
  def send_email(to, subject, body)
    raise NotImplementedError
  end
end

# Concrete implementations
class SendGridProvider
  include EmailProvider

  def send_email(to, subject, body)
    puts "SendGrid: Sending email to #{to}"
    puts "  Subject: #{subject}"
    { status: 'sent', provider: 'sendgrid' }
  end
end

class MailgunProvider
  include EmailProvider

  def send_email(to, subject, body)
    puts "Mailgun: Sending email to #{to}"
    puts "  Subject: #{subject}"
    { status: 'sent', provider: 'mailgun' }
  end
end

class SMTPProvider
  include EmailProvider

  def send_email(to, subject, body)
    puts "SMTP: Sending email to #{to}"
    puts "  Subject: #{subject}"
    { status: 'sent', provider: 'smtp' }
  end
end

# Mock for testing
class MockEmailProvider
  include EmailProvider

  attr_reader :sent_emails

  def initialize
    @sent_emails = []
  end

  def send_email(to, subject, body)
    @sent_emails << { to: to, subject: subject, body: body }
    puts "MockEmailProvider: Email recorded (not actually sent)"
    { status: 'mocked' }
  end
end

# High-level service
class NotificationService
  def initialize(email_provider)
    @email_provider = email_provider
  end

  def notify_user(user_email, message)
    @email_provider.send_email(
      user_email,
      "Notification",
      message
    )
  end
end

puts "\nProduction with SendGrid:"
service = NotificationService.new(SendGridProvider.new)
service.notify_user("user@example.com", "Welcome!")

puts "\nTesting with Mock:"
mock_provider = MockEmailProvider.new
test_service = NotificationService.new(mock_provider)
test_service.notify_user("test@example.com", "Test message")
puts "Emails sent in test: #{mock_provider.sent_emails.size}"

# ========================================
# 6. INVERSION OF CONTROL (IoC) CONTAINER
# ========================================

puts "\n6. IoC Container Pattern:"

class Container
  def initialize
    @services = {}
  end

  def register(name, klass, *args)
    @services[name] = { klass: klass, args: args }
  end

  def register_singleton(name, instance)
    @services[name] = { instance: instance }
  end

  def resolve(name)
    service = @services[name]
    return nil unless service

    if service[:instance]
      service[:instance]
    else
      service[:klass].new(*service[:args])
    end
  end
end

# Setup container
container = Container.new
container.register(:database, PostgreSQLDatabase)
container.register(:email_provider, SendGridProvider)
container.register_singleton(:logger, ConsoleLogger.new)

# Resolve dependencies
puts "\nResolving from IoC container:"
db = container.resolve(:database)
email = container.resolve(:email_provider)
logger = container.resolve(:logger)

db.save("test data")
email.send_email("user@example.com", "Test", "Body")
logger.log("Using IoC container")

# ========================================
# 7. STRATEGY PATTERN WITH DIP
# ========================================

puts "\n7. Strategy Pattern with DIP:"

# Abstract strategy
module CompressionStrategy
  def compress(data)
    raise NotImplementedError
  end
end

# Concrete strategies
class ZipCompression
  include CompressionStrategy

  def compress(data)
    puts "ZIP: Compressing '#{data}' with ZIP algorithm"
    "#{data}.zip"
  end
end

class GzipCompression
  include CompressionStrategy

  def compress(data)
    puts "GZIP: Compressing '#{data}' with GZIP algorithm"
    "#{data}.gz"
  end
end

class RarCompression
  include CompressionStrategy

  def compress(data)
    puts "RAR: Compressing '#{data}' with RAR algorithm"
    "#{data}.rar"
  end
end

# Context depends on abstraction
class FileCompressor
  def initialize(strategy)
    @strategy = strategy
  end

  def compress_file(filename)
    @strategy.compress(filename)
  end

  def change_strategy(strategy)
    @strategy = strategy
  end
end

compressor = FileCompressor.new(ZipCompression.new)
compressor.compress_file("document.txt")

compressor.change_strategy(GzipCompression.new)
compressor.compress_file("image.png")

# ========================================
# 8. TESTING WITH DIP
# ========================================

puts "\n8. Testing Benefits of DIP:"

# Real payment gateway
class RealPaymentGateway
  def process_payment(amount)
    puts "RealPaymentGateway: Processing real payment of $#{amount}"
    # Actual API call
    { success: true, transaction_id: "TXN#{rand(10000)}" }
  end
end

# Mock for testing
class MockPaymentGateway
  attr_reader :payments_processed

  def initialize
    @payments_processed = []
  end

  def process_payment(amount)
    puts "MockPaymentGateway: Recording payment of $#{amount} (not charging)"
    @payments_processed << amount
    { success: true, transaction_id: "MOCK#{rand(10000)}" }
  end
end

class CheckoutService
  def initialize(payment_gateway)
    @payment_gateway = payment_gateway
  end

  def complete_checkout(amount)
    result = @payment_gateway.process_payment(amount)
    if result[:success]
      puts "Checkout completed. Transaction: #{result[:transaction_id]}"
      true
    else
      puts "Checkout failed"
      false
    end
  end
end

puts "\nProduction (real payment):"
prod_service = CheckoutService.new(RealPaymentGateway.new)
prod_service.complete_checkout(49.99)

puts "\nTesting (mock payment):"
mock_gateway = MockPaymentGateway.new
test_service = CheckoutService.new(mock_gateway)
test_service.complete_checkout(49.99)
test_service.complete_checkout(29.99)
puts "Total payments in test: #{mock_gateway.payments_processed.sum}"

# ========================================
# 9. ADAPTER PATTERN WITH DIP
# ========================================

puts "\n9. Adapter Pattern with DIP:"

# Third-party API (can't modify)
class LegacyPaymentAPI
  def make_payment(card, dollars)
    puts "LegacyAPI: Charging $#{dollars} to card #{card}"
    "SUCCESS"
  end
end

# Our interface
module PaymentGateway
  def process_payment(amount)
    raise NotImplementedError
  end
end

# Adapter to make legacy API conform to our interface
class LegacyPaymentAdapter
  include PaymentGateway

  def initialize(legacy_api)
    @legacy_api = legacy_api
  end

  def process_payment(amount)
    result = @legacy_api.make_payment("1234-5678", amount)
    { success: result == "SUCCESS", amount: amount }
  end
end

legacy_api = LegacyPaymentAPI.new
adapter = LegacyPaymentAdapter.new(legacy_api)
checkout = CheckoutService.new(adapter)
checkout.complete_checkout(99.99)

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "DEPENDENCY INVERSION PRINCIPLE - SUMMARY"
puts "=" * 50
puts "KEY CONCEPTS:"
puts "• High-level modules should not depend on low-level modules"
puts "• Both should depend on abstractions"
puts "• Abstractions should not depend on details"
puts "• Details should depend on abstractions"
puts "\nTECHNIQUES:"
puts "✓ Dependency Injection (constructor, setter, method)"
puts "✓ Duck Typing (Ruby's natural way)"
puts "✓ Abstract interfaces (modules in Ruby)"
puts "✓ IoC Containers"
puts "✓ Strategy Pattern"
puts "✓ Factory Pattern"
puts "\nBENEFITS:"
puts "• Loose coupling"
puts "• Easy to test with mocks"
puts "• Easy to swap implementations"
puts "• Flexible and maintainable"
puts "• Promotes reusability"
puts "\nPRACTICAL USES:"
puts "• Database abstraction layers"
puts "• Payment gateway integrations"
puts "• Email service providers"
puts "• Logging systems"
puts "• API clients"
puts "• Testing with mocks"
puts "=" * 50
