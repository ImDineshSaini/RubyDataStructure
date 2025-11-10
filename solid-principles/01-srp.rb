# ========================================
# SINGLE RESPONSIBILITY PRINCIPLE (SRP)
# ========================================
# "A class should have one, and only one, reason to change."
# Each class should have only one responsibility or job.

puts "=" * 50
puts "SINGLE RESPONSIBILITY PRINCIPLE"
puts "=" * 50

# ========================================
# 1. VIOLATION OF SRP
# ========================================

puts "\n1. SRP Violation (God Object):"

# BAD: User class doing too many things
class UserBad
  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  # Responsibility 1: User data management
  def save_to_database
    puts "Saving user to database..."
    # Database logic
  end

  # Responsibility 2: Email handling
  def send_welcome_email
    puts "Sending welcome email to #{@email}..."
    # Email logic
  end

  # Responsibility 3: Report generation
  def generate_report
    puts "Generating report for #{@name}..."
    # Report logic
  end

  # Responsibility 4: Validation
  def validate_email
    @email.include?('@')
  end

  # Responsibility 5: Logging
  def log_activity(action)
    puts "[LOG] #{Time.now}: User #{@name} - #{action}"
  end
end

user_bad = UserBad.new("John", "john@example.com")
puts "Problems: User class has 5 different responsibilities!"
puts "If email sending changes, we must modify User class"
puts "If logging changes, we must modify User class"
puts "Testing becomes difficult - too many dependencies"

# ========================================
# 2. FOLLOWING SRP
# ========================================

puts "\n2. Following SRP (Separated Concerns):"

# GOOD: Each class has single responsibility

# Responsibility 1: User data
class User
  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end
end

# Responsibility 2: Database operations
class UserRepository
  def save(user)
    puts "UserRepository: Saving #{user.name} to database..."
    # Database logic only
    true
  end

  def find(id)
    puts "UserRepository: Finding user with id #{id}..."
    # Database query logic
  end
end

# Responsibility 3: Email operations
class EmailService
  def send_welcome_email(user)
    puts "EmailService: Sending welcome email to #{user.email}..."
    # Email sending logic only
  end
end

# Responsibility 4: Report generation
class ReportGenerator
  def generate_user_report(user)
    puts "ReportGenerator: Generating report for #{user.name}..."
    # Report generation logic only
  end
end

# Responsibility 5: Validation
class EmailValidator
  def self.valid?(email)
    email.include?('@')
  end
end

# Responsibility 6: Logging
class Logger
  def self.log(message)
    puts "[LOG] #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}: #{message}"
  end
end

# Usage with SRP
puts "\nUsing separated responsibilities:"
user = User.new("Jane", "jane@example.com")
repository = UserRepository.new
email_service = EmailService.new
report_generator = ReportGenerator.new

repository.save(user)
email_service.send_welcome_email(user)
report_generator.generate_user_report(user)
Logger.log("User #{user.name} registered")

puts "\nBenefits:"
puts "✓ Each class has one reason to change"
puts "✓ Easy to test in isolation"
puts "✓ Easy to maintain and modify"
puts "✓ Reusable components"

# ========================================
# 3. PRACTICAL EXAMPLE: E-COMMERCE ORDER
# ========================================

puts "\n3. E-Commerce Order Example:"

# BAD: Order doing everything
class OrderBad
  def initialize(items)
    @items = items
  end

  def calculate_total
    @items.sum { |item| item[:price] * item[:quantity] }
  end

  def save_to_database
    puts "Saving order to database..."
  end

  def send_confirmation_email
    puts "Sending confirmation email..."
  end

  def process_payment(card_number)
    puts "Processing payment with card #{card_number}..."
  end

  def update_inventory
    puts "Updating inventory..."
  end

  def generate_invoice
    puts "Generating invoice..."
  end
end

puts "OrderBad has 6 different responsibilities - violates SRP!"

# GOOD: Separated concerns
class Order
  attr_reader :id, :items, :total

  def initialize(items)
    @id = rand(1000..9999)
    @items = items
    @total = calculate_total
  end

  private

  def calculate_total
    @items.sum { |item| item[:price] * item[:quantity] }
  end
end

class OrderRepository
  def save(order)
    puts "OrderRepository: Saving order ##{order.id} (Total: $#{order.total})"
    # Save to database
  end
end

class PaymentProcessor
  def process(order, card_number)
    puts "PaymentProcessor: Processing $#{order.total} with card #{card_number[-4..-1]}"
    # Payment processing
    { success: true, transaction_id: "TXN#{rand(10000)}" }
  end
end

class InventoryManager
  def update(items)
    puts "InventoryManager: Updating inventory for #{items.size} items"
    items.each do |item|
      puts "  - Reducing #{item[:name]} by #{item[:quantity]}"
    end
  end
end

class OrderNotifier
  def send_confirmation(order, customer_email)
    puts "OrderNotifier: Sending confirmation for order ##{order.id} to #{customer_email}"
  end
end

class InvoiceGenerator
  def generate(order)
    puts "InvoiceGenerator: Creating invoice for order ##{order.id}"
    {
      invoice_number: "INV#{order.id}",
      amount: order.total,
      items: order.items
    }
  end
end

# Usage
puts "\nProcessing order with SRP:"
items = [
  { name: 'Laptop', price: 999.99, quantity: 1 },
  { name: 'Mouse', price: 29.99, quantity: 2 }
]

order = Order.new(items)
puts "Order created: ##{order.id}, Total: $#{order.total}"

OrderRepository.new.save(order)
payment_result = PaymentProcessor.new.process(order, "1234-5678-9012-3456")
InventoryManager.new.update(items)
OrderNotifier.new.send_confirmation(order, "customer@example.com")
InvoiceGenerator.new.generate(order)

# ========================================
# 4. SERVICE OBJECTS (SRP IN RAILS)
# ========================================

puts "\n4. Service Objects Pattern:"

# Service object: One specific action
class UserRegistrationService
  def initialize(user_params)
    @user_params = user_params
  end

  def call
    user = create_user
    return failure("Invalid user data") unless user

    send_welcome_email(user)
    log_registration(user)
    notify_admins(user)

    success(user)
  end

  private

  def create_user
    User.new(@user_params[:name], @user_params[:email])
  end

  def send_welcome_email(user)
    EmailService.new.send_welcome_email(user)
  end

  def log_registration(user)
    Logger.log("New user registered: #{user.name}")
  end

  def notify_admins(user)
    puts "Notifying admins about new user: #{user.name}"
  end

  def success(user)
    { success: true, user: user }
  end

  def failure(message)
    { success: false, error: message }
  end
end

puts "Service Object handles one workflow:"
result = UserRegistrationService.new(
  name: "Alice",
  email: "alice@example.com"
).call

puts "Registration #{result[:success] ? 'successful' : 'failed'}"

# ========================================
# 5. FORM OBJECTS (SRP FOR VALIDATIONS)
# ========================================

puts "\n5. Form Objects:"

class UserForm
  attr_reader :errors

  def initialize(params)
    @name = params[:name]
    @email = params[:email]
    @password = params[:password]
    @errors = []
  end

  def valid?
    validate_name
    validate_email
    validate_password
    @errors.empty?
  end

  def to_h
    { name: @name, email: @email, password: @password }
  end

  private

  def validate_name
    @errors << "Name can't be blank" if @name.nil? || @name.empty?
    @errors << "Name too short" if @name && @name.length < 2
  end

  def validate_email
    @errors << "Email can't be blank" if @email.nil? || @email.empty?
    @errors << "Invalid email format" if @email && !@email.include?('@')
  end

  def validate_password
    @errors << "Password can't be blank" if @password.nil? || @password.empty?
    @errors << "Password too short" if @password && @password.length < 6
  end
end

form = UserForm.new(name: "Bob", email: "bob@example.com", password: "secret123")
if form.valid?
  puts "Form is valid: #{form.to_h}"
else
  puts "Form errors: #{form.errors.join(', ')}"
end

# ========================================
# 6. PRESENTER OBJECTS (SRP FOR VIEWS)
# ========================================

puts "\n6. Presenter Objects:"

class UserPresenter
  def initialize(user)
    @user = user
  end

  def display_name
    @user.name.upcase
  end

  def display_email
    obfuscate_email(@user.email)
  end

  def full_info
    "#{display_name} <#{display_email}>"
  end

  private

  def obfuscate_email(email)
    username, domain = email.split('@')
    "#{username[0]}***@#{domain}"
  end
end

user = User.new("Charlie", "charlie@example.com")
presenter = UserPresenter.new(user)
puts "Presenter output: #{presenter.full_info}"

# ========================================
# 7. QUERY OBJECTS (SRP FOR DATABASE QUERIES)
# ========================================

puts "\n7. Query Objects:"

class ActiveUsersQuery
  def initialize(users)
    @users = users
  end

  def call
    # Complex query logic in one place
    @users.select { |u| active?(u) }
  end

  private

  def active?(user)
    # Complex business logic
    user.name.length > 3
  end
end

users = [
  User.new("John", "john@example.com"),
  User.new("Al", "al@example.com"),
  User.new("Alice", "alice@example.com")
]

active_users = ActiveUsersQuery.new(users).call
puts "Active users: #{active_users.map(&:name).join(', ')}"

# ========================================
# 8. IDENTIFYING SRP VIOLATIONS
# ========================================

puts "\n8. How to Identify SRP Violations:"
puts "Questions to ask:"
puts "• Can you describe the class in one sentence without 'and'?"
puts "• How many reasons are there for the class to change?"
puts "• How many different teams might need to modify this class?"
puts "• How difficult is it to test this class?"
puts "• Does the class name contain 'Manager', 'Handler', 'Processor'?"

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "SINGLE RESPONSIBILITY PRINCIPLE - SUMMARY"
puts "=" * 50
puts "DO:"
puts "✓ One class, one responsibility"
puts "✓ Extract separate concerns into separate classes"
puts "✓ Use service objects for complex workflows"
puts "✓ Use form objects for validations"
puts "✓ Use presenters for view logic"
puts "✓ Use query objects for complex queries"
puts "\nDON'T:"
puts "✗ Create god objects that do everything"
puts "✗ Mix business logic with presentation"
puts "✗ Put database logic in models"
puts "✗ Handle multiple unrelated concerns in one class"
puts "\nBENEFITS:"
puts "• Easier to understand and maintain"
puts "• Easier to test in isolation"
puts "• More reusable components"
puts "• Better separation of concerns"
puts "• Reduced coupling"
puts "=" * 50
