# ========================================
# PROXY PATTERN
# ========================================
# Provides a surrogate or placeholder for another object to control access to it.
# Creates a representative object that controls access to the real object.

puts "=" * 50
puts "PROXY PATTERN"
puts "=" * 50

# ========================================
# 1. VIRTUAL PROXY (LAZY INITIALIZATION)
# ========================================

puts "\n1. Virtual Proxy - Lazy Loading:"

# Real object - expensive to create
class HighResolutionImage
  def initialize(filename)
    @filename = filename
    load_image
  end

  def display
    puts "📺 Displaying high-resolution image: #{@filename}"
  end

  private

  def load_image
    puts "🔄 Loading high-resolution image from disk: #{@filename}"
    puts "   This is expensive... loading 50MB file..."
    sleep(0.5)  # Simulate loading time
    puts "✅ Image loaded!"
  end
end

# Proxy - delays creation until needed
class ImageProxy
  def initialize(filename)
    @filename = filename
    @real_image = nil
  end

  def display
    # Load real image only when needed
    @real_image ||= HighResolutionImage.new(@filename)
    @real_image.display
  end
end

puts "Without proxy:"
image1 = HighResolutionImage.new("photo1.jpg")
puts "Doing other work..."
image1.display

puts "\nWith proxy (lazy loading):"
image2 = ImageProxy.new("photo2.jpg")
puts "Doing other work (image not loaded yet)..."
image2.display
puts "Displaying again (already loaded):"
image2.display

# ========================================
# 2. PROTECTION PROXY (ACCESS CONTROL)
# ========================================

puts "\n2. Protection Proxy - Access Control:"

class BankAccount
  attr_reader :balance

  def initialize(balance = 0)
    @balance = balance
  end

  def deposit(amount)
    @balance += amount
    puts "✅ Deposited $#{amount}. New balance: $#{@balance}"
  end

  def withdraw(amount)
    if amount <= @balance
      @balance -= amount
      puts "✅ Withdrew $#{amount}. New balance: $#{@balance}"
    else
      puts "❌ Insufficient funds!"
    end
  end

  def transfer(amount, to_account)
    if amount <= @balance
      @balance -= amount
      to_account.deposit(amount)
      puts "✅ Transferred $#{amount}"
    else
      puts "❌ Insufficient funds for transfer!"
    end
  end
end

class BankAccountProxy
  def initialize(account, user_role)
    @account = account
    @user_role = user_role
  end

  def deposit(amount)
    @account.deposit(amount)
  end

  def withdraw(amount)
    if @user_role == :owner || @user_role == :admin
      @account.withdraw(amount)
    else
      puts "🔒 Access denied: Only account owner can withdraw"
    end
  end

  def transfer(amount, to_account)
    if @user_role == :owner || @user_role == :admin
      @account.transfer(amount, to_account)
    else
      puts "🔒 Access denied: Only account owner can transfer"
    end
  end

  def balance
    if @user_role == :owner || @user_role == :admin || @user_role == :viewer
      @account.balance
    else
      puts "🔒 Access denied: Cannot view balance"
      nil
    end
  end
end

account = BankAccount.new(1000)

puts "Owner access:"
owner_proxy = BankAccountProxy.new(account, :owner)
owner_proxy.withdraw(100)
puts "Balance: $#{owner_proxy.balance}"

puts "\nGuest access:"
guest_proxy = BankAccountProxy.new(account, :guest)
guest_proxy.withdraw(100)
guest_proxy.balance

puts "\nViewer access:"
viewer_proxy = BankAccountProxy.new(account, :viewer)
viewer_proxy.withdraw(50)
puts "Balance: $#{viewer_proxy.balance}"

# ========================================
# 3. REMOTE PROXY
# ========================================

puts "\n3. Remote Proxy - Network Communication:"

class RemoteServer
  def process_request(data)
    puts "🖥️  Server processing: #{data}"
    "Result: #{data.upcase}"
  end

  def get_data(id)
    puts "🖥️  Server fetching data for ID: #{id}"
    { id: id, value: "Data #{id}", timestamp: Time.now }
  end
end

class RemoteServerProxy
  def initialize
    @server = nil
  end

  def process_request(data)
    connect unless connected?
    puts "📡 Sending request through proxy..."
    @server.process_request(data)
  end

  def get_data(id)
    connect unless connected?
    puts "📡 Fetching data through proxy..."
    @server.get_data(id)
  end

  private

  def connect
    puts "🔌 Establishing connection to remote server..."
    @server = RemoteServer.new
    puts "✅ Connected!"
  end

  def connected?
    !@server.nil?
  end
end

proxy = RemoteServerProxy.new
result1 = proxy.process_request("hello")
puts "Received: #{result1}"

data = proxy.get_data(123)
puts "Received: #{data}"

# ========================================
# 4. CACHING PROXY
# ========================================

puts "\n4. Caching Proxy:"

class Database
  def query(sql)
    puts "🗄️  Executing expensive database query: #{sql}"
    sleep(0.3)  # Simulate query time
    "Results for: #{sql}"
  end
end

class DatabaseProxy
  def initialize
    @database = Database.new
    @cache = {}
  end

  def query(sql)
    if @cache.key?(sql)
      puts "💾 Cache hit! Returning cached results"
      @cache[sql]
    else
      puts "❌ Cache miss. Querying database..."
      result = @database.query(sql)
      @cache[sql] = result
      result
    end
  end

  def clear_cache
    @cache.clear
    puts "🧹 Cache cleared"
  end
end

db_proxy = DatabaseProxy.new

puts "First query:"
result1 = db_proxy.query("SELECT * FROM users")

puts "\nSame query again (cached):"
result2 = db_proxy.query("SELECT * FROM users")

puts "\nDifferent query:"
result3 = db_proxy.query("SELECT * FROM products")

puts "\nFirst query again (still cached):"
result4 = db_proxy.query("SELECT * FROM users")

# ========================================
# 5. LOGGING PROXY
# ========================================

puts "\n5. Logging Proxy:"

class PaymentService
  def process_payment(amount, card_number)
    puts "💳 Processing payment of $#{amount}"
    { status: :success, transaction_id: rand(10000) }
  end

  def refund(transaction_id)
    puts "💵 Processing refund for transaction #{transaction_id}"
    { status: :refunded }
  end
end

class LoggingPaymentProxy
  def initialize
    @service = PaymentService.new
    @log = []
  end

  def process_payment(amount, card_number)
    log_entry = {
      action: :payment,
      amount: amount,
      card: "****#{card_number[-4..]}", # Mask card number
      timestamp: Time.now
    }

    puts "📝 Logging payment request..."
    result = @service.process_payment(amount, card_number)

    log_entry[:result] = result
    @log << log_entry

    result
  end

  def refund(transaction_id)
    log_entry = {
      action: :refund,
      transaction_id: transaction_id,
      timestamp: Time.now
    }

    puts "📝 Logging refund request..."
    result = @service.refund(transaction_id)

    log_entry[:result] = result
    @log << log_entry

    result
  end

  def show_logs
    puts "\n📋 Transaction Log:"
    @log.each_with_index do |entry, i|
      puts "#{i + 1}. #{entry[:action].upcase} at #{entry[:timestamp]}"
      puts "   #{entry.reject { |k, _| k == :timestamp || k == :action }}"
    end
  end
end

payment_proxy = LoggingPaymentProxy.new
payment_proxy.process_payment(100, "1234567890123456")
payment_proxy.process_payment(50, "9876543210987654")
payment_proxy.refund(1234)
payment_proxy.show_logs

# ========================================
# 6. SMART REFERENCE PROXY
# ========================================

puts "\n6. Smart Reference Proxy - Reference Counting:"

class LargeObject
  def initialize(name)
    @name = name
    puts "🏗️  Creating large object: #{@name}"
  end

  def operation
    puts "🔧 Performing operation on #{@name}"
  end

  def close
    puts "🗑️  Destroying #{@name}"
  end
end

class SmartReference
  @@references = Hash.new(0)

  def initialize(name)
    @name = name
    @object = nil
  end

  def acquire
    if @@references[@name] == 0
      @object = LargeObject.new(@name)
    end
    @@references[@name] += 1
    puts "📌 Reference count for #{@name}: #{@@references[@name]}"
    @object
  end

  def release
    @@references[@name] -= 1
    puts "📌 Reference count for #{@name}: #{@@references[@name]}"

    if @@references[@name] == 0
      @object.close if @object
      @object = nil
    end
  end

  def operation
    acquire unless @object
    @object.operation
  end
end

puts "Creating smart references:"
ref1 = SmartReference.new("SharedResource")
obj1 = ref1.acquire

ref2 = SmartReference.new("SharedResource")
obj2 = ref2.acquire

ref1.operation
ref2.operation

puts "\nReleasing references:"
ref1.release
ref2.release

# ========================================
# 7. COPY-ON-WRITE PROXY
# ========================================

puts "\n7. Copy-on-Write Proxy:"

class Document
  attr_reader :content

  def initialize(content)
    @content = content
    puts "📄 Created document: #{content[0..30]}..."
  end

  def content=(new_content)
    @content = new_content
  end

  def display
    puts "📖 Document content: #{@content}"
  end
end

class DocumentProxy
  def initialize(document)
    @original = document
    @copy = nil
  end

  def content
    @copy ? @copy.content : @original.content
  end

  def content=(new_content)
    unless @copy
      puts "✏️  Creating copy for modification..."
      @copy = Document.new(@original.content)
    end
    @copy.content = new_content
  end

  def display
    (@copy || @original).display
  end
end

original = Document.new("This is the original document with important content")

puts "\nCreating proxy:"
proxy1 = DocumentProxy.new(original)
proxy2 = DocumentProxy.new(original)

puts "\nReading (no copy created):"
proxy1.display
proxy2.display

puts "\nModifying proxy1 (creates copy):"
proxy1.content = "Modified content by proxy1"

puts "\nDisplaying both:"
proxy1.display
proxy2.display
original.display

# ========================================
# 8. VALIDATION PROXY
# ========================================

puts "\n8. Validation Proxy:"

class EmailService
  def send_email(to, subject, body)
    puts "📧 Sending email to #{to}"
    puts "   Subject: #{subject}"
    puts "   Body: #{body[0..50]}..."
    { sent: true, message_id: rand(10000) }
  end
end

class ValidatingEmailProxy
  def initialize
    @service = EmailService.new
  end

  def send_email(to, subject, body)
    errors = validate(to, subject, body)

    if errors.empty?
      puts "✅ Validation passed"
      @service.send_email(to, subject, body)
    else
      puts "❌ Validation failed:"
      errors.each { |error| puts "   - #{error}" }
      { sent: false, errors: errors }
    end
  end

  private

  def validate(to, subject, body)
    errors = []
    errors << "Invalid email format" unless to =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    errors << "Subject cannot be empty" if subject.nil? || subject.strip.empty?
    errors << "Body cannot be empty" if body.nil? || body.strip.empty?
    errors << "Body too short (min 10 characters)" if body && body.length < 10
    errors
  end
end

email_proxy = ValidatingEmailProxy.new

puts "Valid email:"
email_proxy.send_email("user@example.com", "Hello", "This is a valid message body")

puts "\nInvalid email:"
email_proxy.send_email("invalid-email", "", "Hi")

# ========================================
# 9. SYNCHRONIZATION PROXY
# ========================================

puts "\n9. Thread-Safe Proxy:"

class Counter
  attr_accessor :count

  def initialize
    @count = 0
  end

  def increment
    @count += 1
  end

  def decrement
    @count -= 1
  end
end

class SynchronizedCounterProxy
  def initialize
    @counter = Counter.new
    @mutex = Mutex.new
  end

  def count
    @mutex.synchronize { @counter.count }
  end

  def increment
    @mutex.synchronize do
      puts "🔒 Locked: incrementing..."
      @counter.increment
      puts "   Count: #{@counter.count}"
    end
  end

  def decrement
    @mutex.synchronize do
      puts "🔒 Locked: decrementing..."
      @counter.decrement
      puts "   Count: #{@counter.count}"
    end
  end
end

puts "Thread-safe counter:"
counter_proxy = SynchronizedCounterProxy.new

threads = 3.times.map do |i|
  Thread.new do
    2.times do
      counter_proxy.increment
      sleep(0.01)
    end
  end
end

threads.each(&:join)
puts "Final count: #{counter_proxy.count}"

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "PROXY PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Provide surrogate/placeholder for another object"
puts "• Control access to the real object"
puts "• Add additional functionality without changing real object"
puts "\nTYPES OF PROXIES:"
puts "1. Virtual Proxy - Lazy initialization of expensive objects"
puts "2. Protection Proxy - Access control and permissions"
puts "3. Remote Proxy - Represent object in different address space"
puts "4. Caching Proxy - Cache results to avoid duplicate work"
puts "5. Logging Proxy - Log access and operations"
puts "6. Smart Reference - Reference counting, resource management"
puts "7. Copy-on-Write - Defer copying until modification"
puts "8. Validation Proxy - Validate input before forwarding"
puts "9. Synchronization Proxy - Thread-safe access"
puts "\nWHEN TO USE:"
puts "• Need lazy initialization (virtual proxy)"
puts "• Need access control (protection proxy)"
puts "• Object is in remote location (remote proxy)"
puts "• Need to add functionality without changing object"
puts "• Want to cache expensive operations"
puts "\nBENEFITS:"
puts "✓ Controls access to object"
puts "✓ Can add functionality transparently"
puts "✓ Can defer object creation"
puts "✓ Open/Closed Principle"
puts "✓ Can introduce caching, logging, etc."
puts "✓ Works with client code unchanged"
puts "\nDRAWBACKS:"
puts "✗ Increased complexity"
puts "✗ Response time might increase"
puts "✗ Additional indirection"
puts "✗ May be overkill for simple objects"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Lazy-loaded images in web browsers"
puts "• ORM frameworks (database access)"
puts "• Security proxies for access control"
puts "• Network proxies (forward/reverse)"
puts "• Caching proxies (CDNs, web caches)"
puts "• Logging wrappers"
puts "• Smart pointers in C++"
puts "\nPROXY VS DECORATOR:"
puts "• Proxy: Controls access to object"
puts "• Decorator: Adds new responsibilities"
puts "• Proxy: Often creates real object itself"
puts "• Decorator: Wraps existing object"
puts "=" * 50
