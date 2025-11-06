# ========================================
# OBSERVER PATTERN
# ========================================
# Defines a one-to-many dependency between objects so that when one object
# changes state, all its dependents are notified automatically.

puts "=" * 50
puts "OBSERVER PATTERN"
puts "=" * 50

# ========================================
# 1. BASIC OBSERVER PATTERN
# ========================================

class Subject
  def initialize
    @observers = []
  end

  def attach(observer)
    @observers << observer
    puts "Observer attached: #{observer.class}"
  end

  def detach(observer)
    @observers.delete(observer)
    puts "Observer detached: #{observer.class}"
  end

  def notify(data)
    @observers.each { |observer| observer.update(data) }
  end
end

class ConcreteObserverA
  def update(data)
    puts "Observer A received: #{data}"
  end
end

class ConcreteObserverB
  def update(data)
    puts "Observer B received: #{data}"
  end
end

puts "\n1. Basic Observer Pattern:"
subject = Subject.new
observer_a = ConcreteObserverA.new
observer_b = ConcreteObserverB.new

subject.attach(observer_a)
subject.attach(observer_b)

subject.notify("Hello Observers!")

subject.detach(observer_a)
subject.notify("Observer A was removed")

# ========================================
# 2. USING RUBY'S OBSERVABLE MODULE
# ========================================

require 'observer'

class NewsAgency
  include Observable

  def initialize
    @latest_news = nil
  end

  def add_news(news)
    @latest_news = news
    changed  # Mark as changed
    notify_observers(news)  # Notify all observers
  end

  attr_reader :latest_news
end

class NewsSubscriber
  def initialize(name)
    @name = name
  end

  def update(news)
    puts "#{@name} received news: #{news}"
  end
end

puts "\n2. Using Ruby's Observable Module:"
agency = NewsAgency.new

subscriber1 = NewsSubscriber.new("Subscriber 1")
subscriber2 = NewsSubscriber.new("Subscriber 2")

agency.add_observer(subscriber1)
agency.add_observer(subscriber2)

agency.add_news("Breaking: Ruby 4.0 released!")
agency.add_news("Update: Performance improvements")

# ========================================
# 3. PRACTICAL EXAMPLE: STOCK MARKET
# ========================================

class Stock
  attr_reader :symbol, :price

  def initialize(symbol, price)
    @symbol = symbol
    @price = price
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def remove_observer(observer)
    @observers.delete(observer)
  end

  def price=(new_price)
    old_price = @price
    @price = new_price
    notify_observers(old_price, new_price)
  end

  private

  def notify_observers(old_price, new_price)
    @observers.each do |observer|
      observer.price_changed(self, old_price, new_price)
    end
  end
end

class Investor
  def initialize(name)
    @name = name
  end

  def price_changed(stock, old_price, new_price)
    change = new_price - old_price
    percentage = ((change / old_price) * 100).round(2)

    puts "#{@name} notified: #{stock.symbol} changed from $#{old_price} to $#{new_price} (#{percentage}%)"
  end
end

class PriceAlert
  def initialize(symbol, threshold)
    @symbol = symbol
    @threshold = threshold
  end

  def price_changed(stock, old_price, new_price)
    if new_price > @threshold
      puts "⚠️  ALERT: #{stock.symbol} exceeded threshold! Current: $#{new_price}, Threshold: $#{@threshold}"
    end
  end
end

puts "\n3. Stock Market Example:"
apple_stock = Stock.new("AAPL", 150.0)

investor1 = Investor.new("John")
investor2 = Investor.new("Jane")
alert = PriceAlert.new("AAPL", 160.0)

apple_stock.add_observer(investor1)
apple_stock.add_observer(investor2)
apple_stock.add_observer(alert)

apple_stock.price = 155.0
apple_stock.price = 165.0

# ========================================
# 4. EVENT-DRIVEN SYSTEM
# ========================================

class EventManager
  def initialize
    @listeners = Hash.new { |h, k| h[k] = [] }
  end

  def subscribe(event_type, listener)
    @listeners[event_type] << listener
    puts "Subscribed to #{event_type}: #{listener.class}"
  end

  def unsubscribe(event_type, listener)
    @listeners[event_type].delete(listener)
  end

  def emit(event_type, data)
    @listeners[event_type].each do |listener|
      listener.call(data)
    end
  end
end

puts "\n4. Event-Driven System:"
event_manager = EventManager.new

# Subscribe to user.login event
event_manager.subscribe('user.login', proc do |data|
  puts "Logger: User #{data[:username]} logged in at #{data[:time]}"
end)

event_manager.subscribe('user.login', proc do |data|
  puts "Analytics: Track login for #{data[:username]}"
end)

event_manager.subscribe('user.login', proc do |data|
  puts "Email: Send welcome email to #{data[:email]}"
end)

# Emit event
event_manager.emit('user.login', {
  username: 'john_doe',
  email: 'john@example.com',
  time: Time.now
})

# ========================================
# 5. OBSERVABLE MODEL (like Active Record)
# ========================================

module Observable
  def observers
    @observers ||= []
  end

  def add_observer(observer)
    observers << observer unless observers.include?(observer)
  end

  def remove_observer(observer)
    observers.delete(observer)
  end

  def notify_observers(event, *args)
    observers.each do |observer|
      observer.send(event, *args) if observer.respond_to?(event)
    end
  end
end

class User
  include Observable

  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  def save
    # Save logic...
    notify_observers(:after_save, self)
  end

  def destroy
    # Delete logic...
    notify_observers(:after_destroy, self)
  end
end

class UserLogger
  def after_save(user)
    puts "LOG: User #{user.name} was saved"
  end

  def after_destroy(user)
    puts "LOG: User #{user.name} was destroyed"
  end
end

class EmailNotifier
  def after_save(user)
    puts "EMAIL: Confirmation sent to #{user.email}"
  end
end

class AnalyticsTracker
  def after_save(user)
    puts "ANALYTICS: User creation tracked"
  end

  def after_destroy(user)
    puts "ANALYTICS: User deletion tracked"
  end
end

puts "\n5. Observable Model:"
user = User.new("Alice", "alice@example.com")

logger = UserLogger.new
email_notifier = EmailNotifier.new
analytics = AnalyticsTracker.new

user.add_observer(logger)
user.add_observer(email_notifier)
user.add_observer(analytics)

puts "\nSaving user:"
user.save

puts "\nDestroying user:"
user.destroy

# ========================================
# 6. PRACTICAL EXAMPLE: UI COMPONENTS
# ========================================

class DataModel
  attr_reader :data

  def initialize
    @data = []
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def add_item(item)
    @data << item
    notify_observers(:item_added, item)
  end

  def remove_item(item)
    @data.delete(item)
    notify_observers(:item_removed, item)
  end

  def update_item(old_item, new_item)
    index = @data.index(old_item)
    @data[index] = new_item if index
    notify_observers(:item_updated, old_item, new_item)
  end

  private

  def notify_observers(event, *args)
    @observers.each { |observer| observer.update(event, *args) }
  end
end

class ListView
  def update(event, *args)
    case event
    when :item_added
      puts "ListView: Added '#{args[0]}' to list"
    when :item_removed
      puts "ListView: Removed '#{args[0]}' from list"
    when :item_updated
      puts "ListView: Updated '#{args[0]}' to '#{args[1]}'"
    end
  end
end

class ChartView
  def update(event, *args)
    case event
    when :item_added
      puts "ChartView: Redrawn chart with new item '#{args[0]}'"
    when :item_removed
      puts "ChartView: Redrawn chart without '#{args[0]}'"
    when :item_updated
      puts "ChartView: Updated data point"
    end
  end
end

puts "\n6. UI Components Example:"
model = DataModel.new
list_view = ListView.new
chart_view = ChartView.new

model.add_observer(list_view)
model.add_observer(chart_view)

puts "\nAdding items:"
model.add_item("Item 1")
model.add_item("Item 2")

puts "\nRemoving item:"
model.remove_item("Item 1")

puts "\nUpdating item:"
model.update_item("Item 2", "Item 2 Updated")

# ========================================
# 7. ASYNC OBSERVER WITH THREADS
# ========================================

class AsyncSubject
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def notify_async(data)
    threads = []
    @observers.each do |observer|
      threads << Thread.new do
        observer.update(data)
      end
    end
    threads.each(&:join)
  end
end

class SlowObserver
  def initialize(name, delay)
    @name = name
    @delay = delay
  end

  def update(data)
    sleep(@delay)
    puts "#{@name} processed: #{data} (after #{@delay}s)"
  end
end

puts "\n7. Async Observer (with threads):"
async_subject = AsyncSubject.new
async_subject.add_observer(SlowObserver.new("Fast Observer", 0.5))
async_subject.add_observer(SlowObserver.new("Slow Observer", 1.0))

puts "Notifying observers asynchronously..."
start_time = Time.now
async_subject.notify_async("Important Data")
end_time = Time.now
puts "Total time: #{(end_time - start_time).round(2)}s (should be ~1s due to parallelism)"

# ========================================
# ADVANTAGES AND DISADVANTAGES
# ========================================

puts "\n" + "=" * 50
puts "OBSERVER PATTERN - PROS & CONS"
puts "=" * 50
puts "ADVANTAGES:"
puts "✓ Loose coupling between subject and observers"
puts "✓ Dynamic relationships at runtime"
puts "✓ Broadcast communication"
puts "✓ Open/Closed principle support"
puts "\nDISADVANTAGES:"
puts "✗ Unexpected updates and cascading effects"
puts "✗ Memory leaks if observers not properly removed"
puts "✗ No guarantee of notification order"
puts "✗ Difficult to debug complex chains"
puts "\nUSE CASES:"
puts "• Event handling systems"
puts "• MVC architecture (Model notifies View)"
puts "• Pub/Sub messaging systems"
puts "• Real-time data feeds"
puts "• UI component synchronization"
puts "=" * 50
