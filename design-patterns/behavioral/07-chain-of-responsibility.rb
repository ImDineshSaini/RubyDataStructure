# ========================================
# CHAIN OF RESPONSIBILITY PATTERN
# ========================================
# Passes requests along a chain of handlers. Each handler decides either to process
# the request or to pass it to the next handler in the chain.

puts "=" * 50
puts "CHAIN OF RESPONSIBILITY PATTERN"
puts "=" * 50

# ========================================
# 1. PROBLEM WITHOUT CHAIN
# ========================================

puts "\n1. Problem - Tight Coupling:"

# BAD: Client needs to know all handlers
class SupportSystemBad
  def handle_request(request)
    if request[:level] == :basic
      puts "Junior support handles basic request"
    elsif request[:level] == :intermediate
      puts "Senior support handles intermediate request"
    elsif request[:level] == :critical
      puts "Manager handles critical request"
    else
      puts "CEO handles request"
    end
  end
end

system = SupportSystemBad.new
system.handle_request(level: :critical)

puts "\nProblem: Tight coupling, hard to add new handlers"

# ========================================
# 2. CHAIN OF RESPONSIBILITY SOLUTION
# ========================================

puts "\n2. Chain of Responsibility Pattern:"

# Handler base class
class SupportHandler
  attr_accessor :next_handler

  def initialize(next_handler = nil)
    @next_handler = next_handler
  end

  def handle(request)
    if can_handle?(request)
      process(request)
    elsif @next_handler
      puts "  → Passing to next handler..."
      @next_handler.handle(request)
    else
      puts "  ❌ No handler could process the request"
    end
  end

  def can_handle?(request)
    raise NotImplementedError
  end

  def process(request)
    raise NotImplementedError
  end
end

# Concrete handlers
class JuniorSupport < SupportHandler
  def can_handle?(request)
    request[:level] == :basic
  end

  def process(request)
    puts "👨‍💼 Junior Support: Handling basic request - #{request[:description]}"
  end
end

class SeniorSupport < SupportHandler
  def can_handle?(request)
    request[:level] == :intermediate
  end

  def process(request)
    puts "👔 Senior Support: Handling intermediate request - #{request[:description]}"
  end
end

class Manager < SupportHandler
  def can_handle?(request)
    request[:level] == :critical
  end

  def process(request)
    puts "👨‍💼 Manager: Handling critical request - #{request[:description]}"
  end
end

class CEO < SupportHandler
  def can_handle?(request)
    request[:level] == :emergency
  end

  def process(request)
    puts "👨‍⚖️ CEO: Handling emergency request - #{request[:description]}"
  end
end

# Build the chain
junior = JuniorSupport.new
senior = SeniorSupport.new(junior)
manager = Manager.new(senior)
ceo = CEO.new(manager)

puts "Support request chain:"
ceo.handle(level: :basic, description: "Password reset")
ceo.handle(level: :critical, description: "Server down")
ceo.handle(level: :emergency, description: "Data breach")

# ========================================
# 3. EXPENSE APPROVAL CHAIN
# ========================================

puts "\n3. Expense Approval Chain:"

class Approver
  attr_accessor :next_approver

  def initialize(name, limit)
    @name = name
    @limit = limit
    @next_approver = nil
  end

  def approve(amount, description)
    if amount <= @limit
      puts "✅ #{@name} approved $#{amount} for: #{description}"
      true
    elsif @next_approver
      puts "   #{@name} cannot approve $#{amount} (limit: $#{@limit})"
      @next_approver.approve(amount, description)
    else
      puts "❌ No one can approve $#{amount} for: #{description}"
      false
    end
  end
end

# Create approval chain
team_lead = Approver.new("Team Lead", 1000)
manager = Approver.new("Manager", 5000)
director = Approver.new("Director", 20000)
vp = Approver.new("VP", 50000)
ceo = Approver.new("CEO", Float::INFINITY)

# Link the chain
team_lead.next_approver = manager
manager.next_approver = director
director.next_approver = vp
vp.next_approver = ceo

puts "Expense approvals:"
team_lead.approve(500, "Office supplies")
team_lead.approve(3000, "New laptop")
team_lead.approve(15000, "Team offsite")
team_lead.approve(75000, "Enterprise software")

# ========================================
# 4. AUTHENTICATION CHAIN
# ========================================

puts "\n4. Authentication Chain:"

class AuthenticationHandler
  attr_accessor :next_handler

  def authenticate(credentials)
    if check(credentials)
      true
    elsif @next_handler
      @next_handler.authenticate(credentials)
    else
      false
    end
  end

  def check(credentials)
    raise NotImplementedError
  end
end

class UsernamePasswordAuth < AuthenticationHandler
  def check(credentials)
    if credentials[:username] && credentials[:password]
      puts "✓ Username/Password authentication succeeded"
      true
    else
      puts "✗ Username/Password authentication failed"
      false
    end
  end
end

class TwoFactorAuth < AuthenticationHandler
  def check(credentials)
    if credentials[:otp_code]
      puts "✓ Two-factor authentication succeeded"
      true
    else
      puts "✗ Two-factor authentication failed - trying next..."
      false
    end
  end
end

class BiometricAuth < AuthenticationHandler
  def check(credentials)
    if credentials[:fingerprint]
      puts "✓ Biometric authentication succeeded"
      true
    else
      puts "✗ Biometric authentication failed - trying next..."
      false
    end
  end
end

class APIKeyAuth < AuthenticationHandler
  def check(credentials)
    if credentials[:api_key]
      puts "✓ API Key authentication succeeded"
      true
    else
      puts "✗ API Key authentication failed - trying next..."
      false
    end
  end
end

# Build authentication chain
username_password = UsernamePasswordAuth.new
two_factor = TwoFactorAuth.new
biometric = BiometricAuth.new
api_key = APIKeyAuth.new

username_password.next_handler = two_factor
two_factor.next_handler = biometric
biometric.next_handler = api_key

puts "\nAttempt 1 (username/password):"
username_password.authenticate(username: "alice", password: "pass123")

puts "\nAttempt 2 (fingerprint only):"
username_password.authenticate(fingerprint: "alice_print")

puts "\nAttempt 3 (API key):"
username_password.authenticate(api_key: "abc123xyz")

# ========================================
# 5. LOGGING CHAIN (MULTIPLE HANDLERS)
# ========================================

puts "\n5. Logging Chain (Multiple Handlers Process):"

class Logger
  DEBUG = 1
  INFO = 2
  WARNING = 3
  ERROR = 4

  attr_accessor :next_logger
  attr_reader :level

  def initialize(level)
    @level = level
    @next_logger = nil
  end

  def log(message, severity)
    if severity >= @level
      write(message, severity)
    end

    # Always pass to next logger (all interested handlers process)
    @next_logger.log(message, severity) if @next_logger
  end

  def write(message, severity)
    raise NotImplementedError
  end
end

class ConsoleLogger < Logger
  def write(message, severity)
    severity_name = severity_to_string(severity)
    puts "📺 Console: [#{severity_name}] #{message}"
  end

  def severity_to_string(severity)
    case severity
    when DEBUG then "DEBUG"
    when INFO then "INFO"
    when WARNING then "WARNING"
    when ERROR then "ERROR"
    end
  end
end

class FileLogger < Logger
  def write(message, severity)
    severity_name = severity_to_string(severity)
    puts "📄 File: Writing [#{severity_name}] #{message} to file.log"
  end

  def severity_to_string(severity)
    case severity
    when DEBUG then "DEBUG"
    when INFO then "INFO"
    when WARNING then "WARNING"
    when ERROR then "ERROR"
    end
  end
end

class EmailLogger < Logger
  def write(message, severity)
    severity_name = severity_to_string(severity)
    puts "📧 Email: Sending alert [#{severity_name}] #{message} to admin@example.com"
  end

  def severity_to_string(severity)
    case severity
    when DEBUG then "DEBUG"
    when INFO then "INFO"
    when WARNING then "WARNING"
    when ERROR then "ERROR"
    end
  end
end

# Build logging chain
console = ConsoleLogger.new(Logger::DEBUG)  # Logs everything
file = FileLogger.new(Logger::INFO)          # Logs INFO and above
email = EmailLogger.new(Logger::ERROR)       # Only ERROR

console.next_logger = file
file.next_logger = email

puts "Logging messages:"
console.log("Application started", Logger::INFO)
console.log("User logged in", Logger::DEBUG)
console.log("Memory usage high", Logger::WARNING)
console.log("Database connection failed", Logger::ERROR)

# ========================================
# 6. HTTP MIDDLEWARE CHAIN
# ========================================

puts "\n6. HTTP Middleware Chain:"

class Middleware
  attr_accessor :next_middleware

  def call(request)
    if handle(request)
      @next_middleware&.call(request)
    else
      puts "   Request blocked by #{self.class.name}"
    end
  end

  def handle(request)
    raise NotImplementedError
  end
end

class AuthenticationMiddleware < Middleware
  def handle(request)
    if request[:auth_token]
      puts "✓ Authentication passed"
      true
    else
      puts "✗ Authentication failed - no token"
      false
    end
  end
end

class AuthorizationMiddleware < Middleware
  def handle(request)
    if request[:user_role] == :admin
      puts "✓ Authorization passed"
      true
    else
      puts "✗ Authorization failed - insufficient permissions"
      false
    end
  end
end

class RateLimitMiddleware < Middleware
  def initialize
    super()
    @request_count = 0
    @limit = 5
  end

  def handle(request)
    @request_count += 1
    if @request_count <= @limit
      puts "✓ Rate limit ok (#{@request_count}/#{@limit})"
      true
    else
      puts "✗ Rate limit exceeded"
      false
    end
  end
end

class ValidationMiddleware < Middleware
  def handle(request)
    if request[:data] && request[:data].is_a?(Hash)
      puts "✓ Request validation passed"
      true
    else
      puts "✗ Request validation failed"
      false
    end
  end
end

class RequestHandler < Middleware
  def handle(request)
    puts "🎯 Request successfully processed: #{request[:path]}"
    true
  end
end

# Build middleware chain
auth = AuthenticationMiddleware.new
authz = AuthorizationMiddleware.new
rate_limit = RateLimitMiddleware.new
validation = ValidationMiddleware.new
handler = RequestHandler.new

auth.next_middleware = authz
authz.next_middleware = rate_limit
rate_limit.next_middleware = validation
validation.next_middleware = handler

puts "Request 1 (valid admin):"
auth.call(
  auth_token: "abc123",
  user_role: :admin,
  path: "/api/users",
  data: { name: "Alice" }
)

puts "\nRequest 2 (unauthorized):"
auth.call(
  auth_token: "abc123",
  user_role: :user,
  path: "/api/admin",
  data: {}
)

# ========================================
# 7. VALIDATION CHAIN
# ========================================

puts "\n7. Validation Chain:"

class Validator
  attr_accessor :next_validator

  def validate(data)
    errors = check(data)

    if @next_validator
      errors += @next_validator.validate(data)
    end

    errors
  end

  def check(data)
    raise NotImplementedError
  end
end

class EmailValidator < Validator
  def check(data)
    if data[:email] && data[:email] =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      []
    else
      ["Invalid email format"]
    end
  end
end

class PasswordValidator < Validator
  def check(data)
    errors = []
    if data[:password].nil? || data[:password].length < 8
      errors << "Password must be at least 8 characters"
    end
    if data[:password] && !data[:password].match?(/[A-Z]/)
      errors << "Password must contain uppercase letter"
    end
    errors
  end
end

class AgeValidator < Validator
  def check(data)
    if data[:age] && data[:age] >= 18
      []
    else
      ["Must be 18 or older"]
    end
  end
end

# Build validation chain
email_validator = EmailValidator.new
password_validator = PasswordValidator.new
age_validator = AgeValidator.new

email_validator.next_validator = password_validator
password_validator.next_validator = age_validator

puts "Validation test 1 (valid data):"
errors = email_validator.validate(
  email: "alice@example.com",
  password: "SecurePass123",
  age: 25
)
puts errors.empty? ? "✅ Valid" : "❌ Errors: #{errors.join(', ')}"

puts "\nValidation test 2 (invalid data):"
errors = email_validator.validate(
  email: "invalid-email",
  password: "weak",
  age: 16
)
puts errors.empty? ? "✅ Valid" : "❌ Errors: #{errors.join(', ')}"

# ========================================
# 8. EVENT PROCESSING CHAIN
# ========================================

puts "\n8. Event Processing Chain:"

class EventProcessor
  attr_accessor :next_processor

  def process(event)
    if interested?(event)
      handle(event)
    end

    @next_processor&.process(event)
  end

  def interested?(event)
    raise NotImplementedError
  end

  def handle(event)
    raise NotImplementedError
  end
end

class ErrorEventProcessor < EventProcessor
  def interested?(event)
    event[:type] == :error
  end

  def handle(event)
    puts "🚨 Error Processor: Logging error - #{event[:message]}"
  end
end

class WarningEventProcessor < EventProcessor
  def interested?(event)
    event[:type] == :warning
  end

  def handle(event)
    puts "⚠️  Warning Processor: Sending alert - #{event[:message]}"
  end
end

class AuditEventProcessor < EventProcessor
  def interested?(event)
    event[:user_id]
  end

  def handle(event)
    puts "📝 Audit Processor: Recording action by user #{event[:user_id]}"
  end
end

class MetricsEventProcessor < EventProcessor
  def interested?(event)
    true  # Interested in all events
  end

  def handle(event)
    puts "📊 Metrics Processor: Incrementing counter for #{event[:type]}"
  end
end

# Build event processing chain
error = ErrorEventProcessor.new
warning = WarningEventProcessor.new
audit = AuditEventProcessor.new
metrics = MetricsEventProcessor.new

error.next_processor = warning
warning.next_processor = audit
audit.next_processor = metrics

puts "Processing events:"
error.process(type: :error, message: "Connection timeout", user_id: 123)

puts "\n"
error.process(type: :warning, message: "High memory usage", user_id: 456)

puts "\n"
error.process(type: :info, message: "User login", user_id: 789)

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "CHAIN OF RESPONSIBILITY - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Pass request along chain of handlers"
puts "• Each handler decides to process or pass"
puts "• Decouple sender from receiver"
puts "• Multiple objects may handle request"
puts "\nWHEN TO USE:"
puts "• Multiple objects can handle request"
puts "• Handler not known in advance"
puts "• Set of handlers specified dynamically"
puts "• Want to issue request without specifying receiver"
puts "\nCOMPONENTS:"
puts "• Handler: Interface for handling requests"
puts "• Concrete Handler: Processes requests it's responsible for"
puts "• Client: Initiates request to chain"
puts "• Chain: Linked list of handlers"
puts "\nTWO MAIN VARIANTS:"
puts "1. Single handler processes (stops after first match)"
puts "   - Expense approval"
puts "   - Authentication"
puts "   - Support escalation"
puts "2. Multiple handlers process (all interested handlers)"
puts "   - Logging"
puts "   - Event processing"
puts "   - Middleware"
puts "\nBENEFITS:"
puts "✓ Decouples sender and receiver"
puts "✓ Single Responsibility Principle"
puts "✓ Open/Closed Principle"
puts "✓ Control order of handling"
puts "✓ Can add/remove handlers at runtime"
puts "✓ Flexible responsibility assignment"
puts "\nDRAWBACKS:"
puts "✗ Request might go unhandled"
puts "✗ Hard to observe runtime characteristics"
puts "✗ Can impact performance (long chain)"
puts "✗ Debugging can be difficult"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Support ticket escalation"
puts "• Expense approval workflow"
puts "• HTTP middleware (Express, Rack)"
puts "• Event bubbling in UI frameworks"
puts "• Logging frameworks (multiple handlers)"
puts "• Spam filters"
puts "• Try-catch exception handling"
puts "• Authentication/Authorization chains"
puts "\nIMPLEMENTATION TIPS:"
puts "• Consider default handler at end of chain"
puts "• Decide: stop after first or process all?"
puts "• Keep handlers focused (single responsibility)"
puts "• Make chain configuration easy"
puts "• Consider circular chain detection"
puts "=" * 50
