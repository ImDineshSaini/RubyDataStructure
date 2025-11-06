# ========================================
# SINGLETON PATTERN
# ========================================
# Ensures a class has only one instance and provides a global point of access to it.
# Use when exactly one instance of a class is needed.

puts "=" * 50
puts "SINGLETON PATTERN"
puts "=" * 50

# ========================================
# 1. BASIC SINGLETON (using Ruby's Singleton module)
# ========================================

require 'singleton'

class DatabaseConnection
  include Singleton

  attr_accessor :connection_string

  def initialize
    @connection_string = "mysql://localhost:3306"
    puts "Database connection created: #{@connection_string}"
  end

  def query(sql)
    "Executing: #{sql}"
  end
end

puts "\n1. Basic Singleton:"
db1 = DatabaseConnection.instance
db2 = DatabaseConnection.instance

puts "db1 object_id: #{db1.object_id}"
puts "db2 object_id: #{db2.object_id}"
puts "Same instance? #{db1 == db2}"

# This will raise an error:
# DatabaseConnection.new # NoMethodError

# ========================================
# 2. MANUAL SINGLETON IMPLEMENTATION
# ========================================

class Logger
  @instance = nil

  private_class_method :new

  def self.instance
    @instance ||= new
  end

  def log(message)
    timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    puts "[#{timestamp}] #{message}"
  end
end

puts "\n2. Manual Singleton:"
logger1 = Logger.instance
logger2 = Logger.instance

puts "logger1 object_id: #{logger1.object_id}"
puts "logger2 object_id: #{logger2.object_id}"
puts "Same instance? #{logger1 == logger2}"

logger1.log("Application started")
logger2.log("User logged in")

# ========================================
# 3. THREAD-SAFE SINGLETON
# ========================================

class ConfigurationManager
  @instance = nil
  @mutex = Mutex.new

  private_class_method :new

  def self.instance
    return @instance if @instance

    @mutex.synchronize do
      @instance ||= new
    end
  end

  def initialize
    @config = {}
    load_config
  end

  def get(key)
    @config[key]
  end

  def set(key, value)
    @config[key] = value
  end

  private

  def load_config
    @config = {
      app_name: "MyApp",
      version: "1.0.0",
      debug: true
    }
  end
end

puts "\n3. Thread-Safe Singleton:"
config1 = ConfigurationManager.instance
config2 = ConfigurationManager.instance

puts "config1 object_id: #{config1.object_id}"
puts "config2 object_id: #{config2.object_id}"
puts "App Name: #{config1.get(:app_name)}"
puts "Version: #{config2.get(:version)}"

# ========================================
# 4. SINGLETON WITH STATE
# ========================================

class ApplicationState
  include Singleton

  attr_accessor :current_user, :session_id

  def initialize
    @current_user = nil
    @session_id = nil
    @settings = {}
  end

  def login(username)
    @current_user = username
    @session_id = SecureRandom.hex(16)
    puts "User '#{username}' logged in with session #{@session_id}"
  end

  def logout
    puts "User '#{@current_user}' logged out"
    @current_user = nil
    @session_id = nil
  end

  def set_setting(key, value)
    @settings[key] = value
  end

  def get_setting(key)
    @settings[key]
  end

  def logged_in?
    !@current_user.nil?
  end
end

require 'securerandom'

puts "\n4. Singleton with State:"
app_state = ApplicationState.instance
app_state.login("john_doe")
app_state.set_setting(:theme, "dark")

# Access from different part of app
other_reference = ApplicationState.instance
puts "Current user: #{other_reference.current_user}"
puts "Theme: #{other_reference.get_setting(:theme)}"
puts "Logged in? #{other_reference.logged_in?}"

app_state.logout

# ========================================
# 5. PRACTICAL EXAMPLE: CACHE MANAGER
# ========================================

class CacheManager
  include Singleton

  def initialize
    @cache = {}
    @max_size = 100
  end

  def get(key)
    if @cache.key?(key)
      puts "Cache HIT: #{key}"
      @cache[key]
    else
      puts "Cache MISS: #{key}"
      nil
    end
  end

  def set(key, value)
    # Simple cache eviction if full
    @cache.shift if @cache.size >= @max_size
    @cache[key] = value
    puts "Cached: #{key}"
  end

  def clear
    @cache.clear
    puts "Cache cleared"
  end

  def size
    @cache.size
  end

  def stats
    {
      size: @cache.size,
      max_size: @max_size,
      keys: @cache.keys
    }
  end
end

puts "\n5. Cache Manager Example:"
cache = CacheManager.instance
cache.set("user:1", { name: "Alice", age: 30 })
cache.set("user:2", { name: "Bob", age: 25 })

puts "Stats: #{cache.stats}"

user1 = cache.get("user:1")
puts "Retrieved: #{user1}"

cache.get("user:999")

# ========================================
# 6. ANTI-PATTERNS AND PROBLEMS
# ========================================

puts "\n6. Singleton Anti-Patterns and Problems:"
puts "Issues with Singleton:"
puts "- Global state can lead to hidden dependencies"
puts "- Difficult to test (hard to mock/stub)"
puts "- Violates Single Responsibility Principle"
puts "- Can cause issues in multithreaded environments"
puts "- Makes code tightly coupled"

# Example of testing difficulty
class NotificationService
  include Singleton

  def send_email(to, message)
    # In real app, would send actual email
    puts "Sending email to #{to}: #{message}"
    # Hard to test without actually sending emails
  end
end

# Better approach: Dependency Injection
class UserService
  def initialize(notifier = NotificationService.instance)
    @notifier = notifier
  end

  def register_user(email)
    # Register user logic...
    @notifier.send_email(email, "Welcome!")
  end
end

puts "\nUsing Singleton with Dependency Injection:"
service = UserService.new
service.register_user("alice@example.com")

# In tests, we can pass a mock:
# service = UserService.new(MockNotifier.new)

# ========================================
# 7. ALTERNATIVES TO SINGLETON
# ========================================

puts "\n7. Alternatives to Singleton:"

# Alternative 1: Module with class methods
module Settings
  @config = {
    api_key: "secret123",
    timeout: 30
  }

  def self.get(key)
    @config[key]
  end

  def self.set(key, value)
    @config[key] = value
  end
end

puts "Settings (Module approach):"
puts "API Key: #{Settings.get(:api_key)}"
Settings.set(:timeout, 60)
puts "Timeout: #{Settings.get(:timeout)}"

# Alternative 2: Dependency Injection Container
class Container
  def initialize
    @services = {}
  end

  def register(name, service)
    @services[name] = service
  end

  def get(name)
    @services[name]
  end
end

puts "\nDependency Injection Container:"
container = Container.new
container.register(:logger, Logger.instance)
container.register(:cache, CacheManager.instance)

logger = container.get(:logger)
logger.log("Using DI container")

# ========================================
# 8. REAL-WORLD USE CASES
# ========================================

puts "\n8. Real-World Use Cases:"

# Use Case 1: Database Connection Pool
class ConnectionPool
  include Singleton

  def initialize
    @pool = []
    @max_connections = 5
    @in_use = []
  end

  def get_connection
    if @pool.empty? && @in_use.size < @max_connections
      create_connection
    elsif !@pool.empty?
      conn = @pool.shift
      @in_use << conn
      conn
    else
      nil # Pool exhausted
    end
  end

  def release_connection(conn)
    @in_use.delete(conn)
    @pool << conn
  end

  private

  def create_connection
    conn = "Connection-#{rand(1000)}"
    @in_use << conn
    puts "Created new connection: #{conn}"
    conn
  end
end

puts "\nConnection Pool:"
pool = ConnectionPool.instance
conn1 = pool.get_connection
conn2 = pool.get_connection
puts "Got connections: #{conn1}, #{conn2}"
pool.release_connection(conn1)
puts "Released: #{conn1}"

# Use Case 2: Application Configuration
class AppConfig
  include Singleton

  def initialize
    load_from_file
  end

  def database_url
    @config[:database_url]
  end

  def api_endpoint
    @config[:api_endpoint]
  end

  def feature_enabled?(feature)
    @config[:features]&.include?(feature)
  end

  private

  def load_from_file
    # In real app, would load from YAML/JSON
    @config = {
      database_url: "postgres://localhost/myapp",
      api_endpoint: "https://api.example.com",
      features: [:search, :notifications]
    }
  end
end

puts "\nApplication Configuration:"
config = AppConfig.instance
puts "Database: #{config.database_url}"
puts "Search enabled? #{config.feature_enabled?(:search)}"

# ========================================
# WHEN TO USE SINGLETON
# ========================================

puts "\n" + "=" * 50
puts "WHEN TO USE SINGLETON"
puts "=" * 50
puts "✓ Device drivers and hardware interfaces"
puts "✓ Logging systems"
puts "✓ Configuration management"
puts "✓ Connection pools"
puts "✓ Cache managers"
puts "✓ Thread pools"
puts "\nWHEN TO AVOID:"
puts "✗ When you need multiple instances later"
puts "✗ In unit tests (hard to mock)"
puts "✗ When causing global state issues"
puts "✗ Consider dependency injection instead"
puts "=" * 50
