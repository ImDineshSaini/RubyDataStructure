# ========================================
# ADAPTER PATTERN
# ========================================
# Converts the interface of a class into another interface clients expect.
# Allows classes with incompatible interfaces to work together.

puts "=" * 50
puts "ADAPTER PATTERN"
puts "=" * 50

# ========================================
# 1. BASIC ADAPTER EXAMPLE
# ========================================

puts "\n1. Basic Adapter:"

# Target interface that client expects
class MediaPlayer
  def play(audio_type, filename)
    raise NotImplementedError
  end
end

# Adaptee - existing class with incompatible interface
class AdvancedMediaPlayer
  def play_vlc(filename)
    puts "Playing VLC file: #{filename}"
  end

  def play_mp4(filename)
    puts "Playing MP4 file: #{filename}"
  end
end

# Adapter - makes AdvancedMediaPlayer compatible with MediaPlayer interface
class MediaAdapter < MediaPlayer
  def initialize(audio_type)
    @advanced_player = AdvancedMediaPlayer.new
    @audio_type = audio_type
  end

  def play(audio_type, filename)
    if audio_type == :vlc
      @advanced_player.play_vlc(filename)
    elsif audio_type == :mp4
      @advanced_player.play_mp4(filename)
    end
  end
end

# Client code
class AudioPlayer < MediaPlayer
  def play(audio_type, filename)
    if audio_type == :mp3
      puts "Playing MP3 file: #{filename}"
    elsif [:vlc, :mp4].include?(audio_type)
      adapter = MediaAdapter.new(audio_type)
      adapter.play(audio_type, filename)
    else
      puts "Invalid format: #{audio_type}"
    end
  end
end

player = AudioPlayer.new
player.play(:mp3, "song.mp3")
player.play(:vlc, "movie.vlc")
player.play(:mp4, "video.mp4")

# ========================================
# 2. PAYMENT GATEWAY ADAPTER
# ========================================

puts "\n2. Payment Gateway Adapter:"

# Our standard interface
class PaymentProcessor
  def process_payment(amount)
    raise NotImplementedError
  end
end

# Third-party payment systems with different interfaces
class StripeAPI
  def charge_credit_card(card, amount_in_cents)
    puts "Stripe: Charging card #{card} for #{amount_in_cents} cents"
    { success: true, transaction_id: "stripe_#{rand(1000)}" }
  end
end

class PayPalSDK
  def make_payment(email, dollars)
    puts "PayPal: Charging #{email} for $#{dollars}"
    { status: "completed", id: "paypal_#{rand(1000)}" }
  end
end

class SquareAPI
  def process_transaction(amount, customer)
    puts "Square: Processing $#{amount} for customer #{customer}"
    { transaction_complete: true, ref: "square_#{rand(1000)}" }
  end
end

# Adapters for each payment system
class StripeAdapter < PaymentProcessor
  def initialize(card_number)
    @stripe = StripeAPI.new
    @card = card_number
  end

  def process_payment(amount)
    result = @stripe.charge_credit_card(@card, (amount * 100).to_i)
    result[:success]
  end
end

class PayPalAdapter < PaymentProcessor
  def initialize(email)
    @paypal = PayPalSDK.new
    @email = email
  end

  def process_payment(amount)
    result = @paypal.make_payment(@email, amount)
    result[:status] == "completed"
  end
end

class SquareAdapter < PaymentProcessor
  def initialize(customer_id)
    @square = SquareAPI.new
    @customer = customer_id
  end

  def process_payment(amount)
    result = @square.process_transaction(amount, @customer)
    result[:transaction_complete]
  end
end

# Client code - works with any adapter
def checkout(payment_processor, amount)
  if payment_processor.process_payment(amount)
    puts "✓ Payment successful!\n"
  else
    puts "✗ Payment failed!\n"
  end
end

checkout(StripeAdapter.new("4111-1111-1111-1111"), 99.99)
checkout(PayPalAdapter.new("user@example.com"), 149.99)
checkout(SquareAdapter.new("CUST123"), 79.99)

# ========================================
# 3. LOGGER ADAPTER
# ========================================

puts "\n3. Logger Adapter:"

# Our standard logging interface
class Logger
  def log(level, message)
    raise NotImplementedError
  end
end

# Third-party logging libraries
class Log4Ruby
  def write_log(severity, msg, timestamp)
    puts "[Log4Ruby #{timestamp}] #{severity}: #{msg}"
  end
end

class SyslogClient
  def send_message(priority, application, message)
    puts "[Syslog] #{application} (#{priority}): #{message}"
  end
end

# Adapters
class Log4RubyAdapter < Logger
  def initialize
    @log4ruby = Log4Ruby.new
  end

  def log(level, message)
    timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    @log4ruby.write_log(level.to_s.upcase, message, timestamp)
  end
end

class SyslogAdapter < Logger
  def initialize(app_name)
    @syslog = SyslogClient.new
    @app_name = app_name
  end

  def log(level, message)
    priority = { debug: 7, info: 6, warn: 4, error: 3 }[level]
    @syslog.send_message(priority, @app_name, message)
  end
end

# Client code
def log_messages(logger)
  logger.log(:info, "Application started")
  logger.log(:warn, "Low memory warning")
  logger.log(:error, "Failed to connect to database")
end

puts "Using Log4Ruby:"
log_messages(Log4RubyAdapter.new)

puts "\nUsing Syslog:"
log_messages(SyslogAdapter.new("MyApp"))

# ========================================
# 4. DATA FORMAT ADAPTER
# ========================================

puts "\n4. Data Format Adapter:"

# Target interface
class DataReader
  def read_data
    raise NotImplementedError
  end
end

# Existing JSON reader
class JSONReader
  def parse_json(json_string)
    require 'json'
    JSON.parse(json_string)
  end
end

# Existing XML reader (simulated)
class XMLReader
  def parse_xml(xml_string)
    # Simplified XML parsing
    { data: "Parsed from XML: #{xml_string}" }
  end
end

# Adapters
class JSONAdapter < DataReader
  def initialize(json_data)
    @reader = JSONReader.new
    @data = json_data
  end

  def read_data
    @reader.parse_json(@data)
  end
end

class XMLAdapter < DataReader
  def initialize(xml_data)
    @reader = XMLReader.new
    @data = xml_data
  end

  def read_data
    @reader.parse_xml(@data)
  end
end

# Client code
def process_data(reader)
  data = reader.read_data
  puts "Processed data: #{data}"
end

json_data = '{"name": "John", "age": 30}'
xml_data = '<person><name>Jane</name><age>25</age></person>'

puts "Reading JSON:"
process_data(JSONAdapter.new(json_data))

puts "\nReading XML:"
process_data(XMLAdapter.new(xml_data))

# ========================================
# 5. LEGACY DATABASE ADAPTER
# ========================================

puts "\n5. Legacy Database Adapter:"

# Modern interface
class Database
  def find(id)
    raise NotImplementedError
  end

  def save(record)
    raise NotImplementedError
  end
end

# Legacy database with old interface
class LegacyDatabase
  def get_record_by_id(id)
    puts "Legacy: Fetching record ##{id}"
    { id: id, legacy: true, data: "Old data" }
  end

  def insert_record(data)
    puts "Legacy: Inserting record #{data}"
    true
  end
end

# Adapter
class LegacyDatabaseAdapter < Database
  def initialize
    @legacy_db = LegacyDatabase.new
  end

  def find(id)
    @legacy_db.get_record_by_id(id)
  end

  def save(record)
    @legacy_db.insert_record(record)
  end
end

# Client code
db = LegacyDatabaseAdapter.new
record = db.find(123)
puts "Found: #{record}"
db.save({ name: "New Record" })

# ========================================
# 6. TEMPERATURE SENSOR ADAPTER
# ========================================

puts "\n6. Temperature Sensor Adapter:"

# Standard interface
class TemperatureSensor
  def get_temperature_celsius
    raise NotImplementedError
  end
end

# US sensor returns Fahrenheit
class FahrenheitSensor
  def read_temperature
    rand(60..100)  # Fahrenheit
  end
end

# UK sensor returns Celsius
class CelsiusSensor
  def get_temp
    rand(15..38)  # Celsius
  end
end

# Adapters
class FahrenheitAdapter < TemperatureSensor
  def initialize
    @sensor = FahrenheitSensor.new
  end

  def get_temperature_celsius
    fahrenheit = @sensor.read_temperature
    celsius = ((fahrenheit - 32) * 5.0 / 9.0).round(1)
    puts "Fahrenheit sensor: #{fahrenheit}°F = #{celsius}°C"
    celsius
  end
end

class CelsiusAdapter < TemperatureSensor
  def initialize
    @sensor = CelsiusSensor.new
  end

  def get_temperature_celsius
    celsius = @sensor.get_temp
    puts "Celsius sensor: #{celsius}°C"
    celsius
  end
end

# Climate control system
class ClimateControl
  def initialize(sensors)
    @sensors = sensors
  end

  def get_average_temperature
    temps = @sensors.map(&:get_temperature_celsius)
    average = (temps.sum / temps.size.to_f).round(1)
    puts "Average temperature: #{average}°C\n"
    average
  end
end

sensors = [FahrenheitAdapter.new, CelsiusAdapter.new, FahrenheitAdapter.new]
climate = ClimateControl.new(sensors)
climate.get_average_temperature

# ========================================
# SUMMARY
# ========================================

puts "=" * 50
puts "ADAPTER PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Convert interface of class into another interface"
puts "• Allow incompatible interfaces to work together"
puts "• Wrap existing class with new interface"
puts "\nWHEN TO USE:"
puts "• Want to use existing class but interface doesn't match"
puts "• Create reusable class that cooperates with unrelated classes"
puts "• Need to use several subclasses but impractical to adapt by subclassing"
puts "• Integrate third-party libraries"
puts "\nTWO TYPES:"
puts "• Class Adapter: Uses inheritance (multiple inheritance)"
puts "• Object Adapter: Uses composition (preferred in Ruby)"
puts "\nBENEFITS:"
puts "✓ Single Responsibility Principle"
puts "✓ Open/Closed Principle"
puts "✓ Reuse existing code without modification"
puts "✓ Flexibility to introduce new adapters"
puts "\nDRAWBACKS:"
puts "✗ Increases overall complexity"
puts "✗ Sometimes simpler to just change the class"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Payment gateway integration"
puts "• Legacy system integration"
puts "• Third-party API wrappers"
puts "• Data format converters"
puts "• Hardware device drivers"
puts "=" * 50
