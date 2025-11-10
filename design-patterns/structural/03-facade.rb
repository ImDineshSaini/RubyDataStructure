# ========================================
# FACADE PATTERN
# ========================================
# Provides a unified, simplified interface to a complex subsystem.
# Makes the subsystem easier to use by hiding its complexity.

puts "=" * 50
puts "FACADE PATTERN"
puts "=" * 50

# ========================================
# 1. HOME THEATER EXAMPLE
# ========================================

puts "\n1. Home Theater Facade:"

# Complex subsystem classes
class Amplifier
  def on
    puts "Amplifier: Turning on"
  end

  def off
    puts "Amplifier: Turning off"
  end

  def set_volume(level)
    puts "Amplifier: Setting volume to #{level}"
  end

  def set_surround_sound
    puts "Amplifier: Setting surround sound mode"
  end
end

class DVDPlayer
  def on
    puts "DVD Player: Turning on"
  end

  def off
    puts "DVD Player: Turning off"
  end

  def play(movie)
    puts "DVD Player: Playing '#{movie}'"
  end

  def stop
    puts "DVD Player: Stopping"
  end
end

class Projector
  def on
    puts "Projector: Turning on"
  end

  def off
    puts "Projector: Turning off"
  end

  def wide_screen_mode
    puts "Projector: Setting wide screen mode"
  end
end

class Lights
  def dim(level)
    puts "Lights: Dimming to #{level}%"
  end

  def on
    puts "Lights: Turning on"
  end
end

class Screen
  def down
    puts "Screen: Going down"
  end

  def up
    puts "Screen: Going up"
  end
end

class PopcornPopper
  def on
    puts "Popcorn Popper: Turning on"
  end

  def off
    puts "Popcorn Popper: Turning off"
  end

  def pop
    puts "Popcorn Popper: Popping corn!"
  end
end

# Facade - simplifies the complex subsystem
class HomeTheaterFacade
  def initialize
    @amplifier = Amplifier.new
    @dvd = DVDPlayer.new
    @projector = Projector.new
    @lights = Lights.new
    @screen = Screen.new
    @popper = PopcornPopper.new
  end

  def watch_movie(movie)
    puts "\n🎬 Get ready to watch a movie...\n"
    @popper.on
    @popper.pop
    @lights.dim(10)
    @screen.down
    @projector.on
    @projector.wide_screen_mode
    @amplifier.on
    @amplifier.set_volume(5)
    @amplifier.set_surround_sound
    @dvd.on
    @dvd.play(movie)
    puts "\n✓ Enjoy your movie!\n"
  end

  def end_movie
    puts "\n🛑 Shutting down movie theater...\n"
    @popper.off
    @lights.on
    @screen.up
    @projector.off
    @amplifier.off
    @dvd.stop
    @dvd.off
    puts "\n✓ Movie theater is shut down\n"
  end
end

# Client code - much simpler!
theater = HomeTheaterFacade.new
theater.watch_movie("Inception")
theater.end_movie

# ========================================
# 2. COMPUTER STARTUP FACADE
# ========================================

puts "\n2. Computer Startup Facade:"

class CPU
  def freeze
    puts "CPU: Freezing"
  end

  def jump(position)
    puts "CPU: Jumping to position #{position}"
  end

  def execute
    puts "CPU: Executing"
  end
end

class Memory
  def load(position, data)
    puts "Memory: Loading data '#{data}' at position #{position}"
  end
end

class HardDrive
  def read(lba, size)
    puts "HardDrive: Reading #{size} bytes from sector #{lba}"
    "boot data"
  end
end

# Facade
class ComputerFacade
  def initialize
    @cpu = CPU.new
    @memory = Memory.new
    @hard_drive = HardDrive.new
  end

  def start
    puts "\n💻 Starting computer...\n"
    @cpu.freeze
    boot_data = @hard_drive.read(0, 1024)
    @memory.load(0, boot_data)
    @cpu.jump(0)
    @cpu.execute
    puts "\n✓ Computer started successfully!\n"
  end
end

computer = ComputerFacade.new
computer.start

# ========================================
# 3. ONLINE SHOPPING FACADE
# ========================================

puts "\n3. Online Shopping Facade:"

class Inventory
  def check_availability(product_id)
    puts "Inventory: Checking availability of product ##{product_id}"
    true
  end

  def reserve(product_id)
    puts "Inventory: Reserving product ##{product_id}"
  end
end

class PaymentGateway
  def charge(amount, card)
    puts "Payment: Charging $#{amount} to card #{card}"
    { success: true, transaction_id: rand(1000) }
  end
end

class Shipping
  def calculate_cost(address)
    puts "Shipping: Calculating cost to #{address}"
    9.99
  end

  def schedule_delivery(address, product_id)
    puts "Shipping: Scheduling delivery of product ##{product_id} to #{address}"
    "Delivery scheduled for #{Date.today + 3}"
  end
end

class NotificationService
  def send_confirmation(email, order_details)
    puts "Notification: Sending confirmation to #{email}"
    puts "  Order details: #{order_details}"
  end
end

# Facade
class OnlineShopFacade
  def initialize
    @inventory = Inventory.new
    @payment = PaymentGateway.new
    @shipping = Shipping.new
    @notifications = NotificationService.new
  end

  def place_order(product_id, customer_email, address, card_number)
    puts "\n🛒 Processing order...\n"

    # Check inventory
    unless @inventory.check_availability(product_id)
      puts "❌ Product out of stock"
      return false
    end

    # Reserve product
    @inventory.reserve(product_id)

    # Calculate shipping
    shipping_cost = @shipping.calculate_cost(address)
    total = 99.99 + shipping_cost

    # Process payment
    payment_result = @payment.charge(total, card_number)
    unless payment_result[:success]
      puts "❌ Payment failed"
      return false
    end

    # Schedule delivery
    delivery_date = @shipping.schedule_delivery(address, product_id)

    # Send confirmation
    order_details = {
      product_id: product_id,
      total: total,
      delivery_date: delivery_date,
      transaction_id: payment_result[:transaction_id]
    }
    @notifications.send_confirmation(customer_email, order_details)

    puts "\n✅ Order placed successfully!\n"
    true
  end
end

shop = OnlineShopFacade.new
shop.place_order(12345, "customer@example.com", "123 Main St", "4111-1111-1111-1111")

# ========================================
# 4. BANK ACCOUNT FACADE
# ========================================

puts "\n4. Bank Account Facade:"

class AccountNumberCheck
  def validate(account_number)
    puts "Validation: Checking account number #{account_number}"
    account_number.length == 12
  end
end

class SecurityCodeCheck
  def validate(code)
    puts "Security: Verifying security code"
    code.length == 4
  end
end

class FundsCheck
  def have_enough_funds(balance, amount)
    puts "Funds: Checking if balance $#{balance} >= $#{amount}"
    balance >= amount
  end
end

class AccountManager
  def deduct(amount)
    puts "Account: Deducting $#{amount}"
  end

  def add(amount)
    puts "Account: Adding $#{amount}"
  end
end

# Facade
class BankAccountFacade
  def initialize(account_number, security_code, balance)
    @account_number = account_number
    @security_code = security_code
    @balance = balance

    @account_check = AccountNumberCheck.new
    @security_check = SecurityCodeCheck.new
    @funds_check = FundsCheck.new
    @account_manager = AccountManager.new
  end

  def withdraw(amount)
    puts "\n💵 Withdrawing $#{amount}...\n"

    if @account_check.validate(@account_number) &&
       @security_check.validate(@security_code) &&
       @funds_check.have_enough_funds(@balance, amount)

      @account_manager.deduct(amount)
      @balance -= amount
      puts "\n✅ Withdrawal successful! New balance: $#{@balance}\n"
      true
    else
      puts "\n❌ Withdrawal failed!\n"
      false
    end
  end

  def deposit(amount)
    puts "\n💵 Depositing $#{amount}...\n"

    if @account_check.validate(@account_number) &&
       @security_check.validate(@security_code)

      @account_manager.add(amount)
      @balance += amount
      puts "\n✅ Deposit successful! New balance: $#{@balance}\n"
      true
    else
      puts "\n❌ Deposit failed!\n"
      false
    end
  end
end

account = BankAccountFacade.new("123456789012", "1234", 1000)
account.withdraw(100)
account.deposit(500)

# ========================================
# 5. EMAIL SENDING FACADE
# ========================================

puts "\n5. Email Sending Facade:"

class EmailValidator
  def validate(email)
    puts "Validator: Checking email format"
    email.include?('@')
  end
end

class EmailTemplate
  def load(template_name)
    puts "Template: Loading #{template_name}"
    "<html><body>{{content}}</body></html>"
  end

  def render(template, data)
    puts "Template: Rendering with data"
    template.gsub('{{content}}', data[:content])
  end
end

class SMTPClient
  def connect(server)
    puts "SMTP: Connecting to #{server}"
  end

  def send(to, subject, body)
    puts "SMTP: Sending email to #{to}"
    puts "  Subject: #{subject}"
  end

  def disconnect
    puts "SMTP: Disconnecting"
  end
end

# Facade
class EmailServiceFacade
  def initialize
    @validator = EmailValidator.new
    @template = EmailTemplate.new
    @smtp = SMTPClient.new
  end

  def send_welcome_email(email, name)
    puts "\n📧 Sending welcome email...\n"

    return false unless @validator.validate(email)

    template = @template.load('welcome')
    body = @template.render(template, content: "Welcome, #{name}!")

    @smtp.connect('smtp.example.com')
    @smtp.send(email, 'Welcome!', body)
    @smtp.disconnect

    puts "\n✅ Email sent successfully!\n"
    true
  end
end

email_service = EmailServiceFacade.new
email_service.send_welcome_email("user@example.com", "John")

# ========================================
# SUMMARY
# ========================================

puts "=" * 50
puts "FACADE PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Provide simplified interface to complex subsystem"
puts "• Hide complexity behind a simple interface"
puts "• Define higher-level interface for ease of use"
puts "\nWHEN TO USE:"
puts "• Want simple interface to complex subsystem"
puts "• Many dependencies between clients and implementation classes"
puts "• Want to layer your subsystems"
puts "• Need to decouple subsystem from clients"
puts "\nBENEFITS:"
puts "✓ Simplifies interface for clients"
puts "✓ Decouples subsystem from clients"
puts "✓ Promotes weak coupling"
puts "✓ Easier to use, understand, and test"
puts "✓ Doesn't prevent access to subsystem if needed"
puts "\nDRAWBACKS:"
puts "✗ Facade can become god object coupled to all classes"
puts "✗ Can hide too much complexity"
puts "\nFACADE VS ADAPTER:"
puts "• Facade: Simplifies complex interface"
puts "• Adapter: Makes incompatible interfaces compatible"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Home theater control"
puts "• Computer startup sequence"
puts "• Online shopping checkout"
puts "• Complex API wrappers"
puts "• Framework initialization"
puts "=" * 50
