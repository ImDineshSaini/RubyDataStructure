# ========================================
# INTERFACE SEGREGATION PRINCIPLE (ISP)
# ========================================
# "Clients should not be forced to depend on interfaces they don't use."
# Many specific interfaces are better than one general-purpose interface.

puts "=" * 50
puts "INTERFACE SEGREGATION PRINCIPLE"
puts "=" * 50

# ========================================
# 1. VIOLATION OF ISP
# ========================================

puts "\n1. ISP Violation (Fat Interface):"

# BAD: One big interface with all methods
module WorkerBad
  def work
    raise NotImplementedError
  end

  def eat
    raise NotImplementedError
  end

  def sleep
    raise NotImplementedError
  end
end

class HumanWorker
  include WorkerBad

  def work
    puts "Human working"
  end

  def eat
    puts "Human eating"
  end

  def sleep
    puts "Human sleeping"
  end
end

class RobotWorker
  include WorkerBad

  def work
    puts "Robot working"
  end

  def eat
    # Robots don't eat - forced to implement unused method!
    raise "Robots don't eat"
  end

  def sleep
    # Robots don't sleep - forced to implement unused method!
    raise "Robots don't sleep"
  end
end

puts "Human worker:"
human = HumanWorker.new
human.work
human.eat
human.sleep

puts "\nRobot worker (violates ISP):"
robot = RobotWorker.new
robot.work

begin
  robot.eat  # Error!
rescue => e
  puts "Error: #{e.message}"
end

puts "\nProblem: Robot forced to implement methods it doesn't use"

# ========================================
# 2. FOLLOWING ISP
# ========================================

puts "\n2. Following ISP (Segregated Interfaces):"

# GOOD: Separate interfaces
module Workable
  def work
    raise NotImplementedError
  end
end

module Eatable
  def eat
    raise NotImplementedError
  end
end

module Sleepable
  def sleep
    raise NotImplementedError
  end
end

module Chargeable
  def charge
    raise NotImplementedError
  end
end

class Human
  include Workable
  include Eatable
  include Sleepable

  def work
    puts "Human working"
  end

  def eat
    puts "Human eating"
  end

  def sleep
    puts "Human sleeping"
  end
end

class Robot
  include Workable
  include Chargeable

  def work
    puts "Robot working"
  end

  def charge
    puts "Robot charging"
  end
end

puts "Human:"
human = Human.new
human.work
human.eat
human.sleep

puts "\nRobot:"
robot = Robot.new
robot.work
robot.charge

puts "\n✓ Each class only implements methods it needs"

# ========================================
# 3. PRINTER EXAMPLE
# ========================================

puts "\n3. Printer Example:"

# BAD: Fat interface
module MultiFunctionDeviceBad
  def print(document)
    raise NotImplementedError
  end

  def scan(document)
    raise NotImplementedError
  end

  def fax(document)
    raise NotImplementedError
  end

  def photocopy(document)
    raise NotImplementedError
  end
end

class OldPrinter
  include MultiFunctionDeviceBad

  def print(document)
    puts "Printing: #{document}"
  end

  def scan(document)
    raise "This printer can't scan"  # Forced to implement!
  end

  def fax(document)
    raise "This printer can't fax"  # Forced to implement!
  end

  def photocopy(document)
    raise "This printer can't photocopy"  # Forced to implement!
  end
end

# GOOD: Segregated interfaces
module Printable
  def print(document)
    raise NotImplementedError
  end
end

module Scannable
  def scan(document)
    raise NotImplementedError
  end
end

module Faxable
  def fax(document)
    raise NotImplementedError
  end
end

class SimplePrinter
  include Printable

  def print(document)
    puts "Printing: #{document}"
  end
end

class AllInOnePrinter
  include Printable
  include Scannable
  include Faxable

  def print(document)
    puts "All-in-One: Printing #{document}"
  end

  def scan(document)
    puts "All-in-One: Scanning #{document}"
  end

  def fax(document)
    puts "All-in-One: Faxing #{document}"
  end
end

puts "Simple Printer:"
simple = SimplePrinter.new
simple.print("document.pdf")

puts "\nAll-in-One Printer:"
allinone = AllInOnePrinter.new
allinone.print("document.pdf")
allinone.scan("photo.jpg")
allinone.fax("contract.pdf")

# ========================================
# 4. PAYMENT PROCESSING
# ========================================

puts "\n4. Payment Processing:"

# BAD: Fat interface
module PaymentProcessorBad
  def process_credit_card(details)
    raise NotImplementedError
  end

  def process_paypal(details)
    raise NotImplementedError
  end

  def process_bitcoin(details)
    raise NotImplementedError
  end

  def process_bank_transfer(details)
    raise NotImplementedError
  end
end

# GOOD: Segregated interfaces
module CreditCardProcessor
  def process_credit_card(details)
    raise NotImplementedError
  end
end

module PayPalProcessor
  def process_paypal(details)
    raise NotImplementedError
  end
end

module CryptoProcessor
  def process_crypto(details)
    raise NotImplementedError
  end
end

class OnlineStore
  include CreditCardProcessor
  include PayPalProcessor

  def process_credit_card(details)
    puts "Processing credit card: #{details}"
  end

  def process_paypal(details)
    puts "Processing PayPal: #{details}"
  end
end

class CryptoExchange
  include CryptoProcessor

  def process_crypto(details)
    puts "Processing cryptocurrency: #{details}"
  end
end

puts "Online Store:"
store = OnlineStore.new
store.process_credit_card("1234-5678-9012-3456")
store.process_paypal("user@example.com")

puts "\nCrypto Exchange:"
exchange = CryptoExchange.new
exchange.process_crypto("BTC: 1A2B3C4D")

# ========================================
# 5. BIRD INTERFACE
# ========================================

puts "\n5. Bird Interface:"

# BAD: All birds must implement all methods
module BirdBad
  def fly
    raise NotImplementedError
  end

  def swim
    raise NotImplementedError
  end

  def walk
    raise NotImplementedError
  end
end

# GOOD: Segregated abilities
module Flyable
  def fly
    raise NotImplementedError
  end
end

module Swimmable
  def swim
    raise NotImplementedError
  end
end

module Walkable
  def walk
    raise NotImplementedError
  end
end

class Eagle
  include Flyable
  include Walkable

  def fly
    puts "Eagle flying high"
  end

  def walk
    puts "Eagle walking"
  end
end

class Penguin
  include Swimmable
  include Walkable

  def swim
    puts "Penguin swimming"
  end

  def walk
    puts "Penguin waddling"
  end
end

class Duck
  include Flyable
  include Swimmable
  include Walkable

  def fly
    puts "Duck flying"
  end

  def swim
    puts "Duck swimming"
  end

  def walk
    puts "Duck walking"
  end
end

puts "Eagle:"
eagle = Eagle.new
eagle.fly
eagle.walk

puts "\nPenguin:"
penguin = Penguin.new
penguin.swim
penguin.walk

puts "\nDuck:"
duck = Duck.new
duck.fly
duck.swim
duck.walk

# ========================================
# 6. DATABASE CONNECTION
# ========================================

puts "\n6. Database Connection:"

# BAD: Monolithic interface
module DatabaseBad
  def connect
    raise NotImplementedError
  end

  def execute_query
    raise NotImplementedError
  end

  def begin_transaction
    raise NotImplementedError
  end

  def commit
    raise NotImplementedError
  end

  def rollback
    raise NotImplementedError
  end

  def create_backup
    raise NotImplementedError
  end

  def restore_backup
    raise NotImplementedError
  end
end

# GOOD: Segregated interfaces
module Connectable
  def connect
    raise NotImplementedError
  end

  def disconnect
    raise NotImplementedError
  end
end

module Queryable
  def execute_query(sql)
    raise NotImplementedError
  end
end

module Transactional
  def begin_transaction
    raise NotImplementedError
  end

  def commit
    raise NotImplementedError
  end

  def rollback
    raise NotImplementedError
  end
end

module Backupable
  def create_backup
    raise NotImplementedError
  end

  def restore_backup
    raise NotImplementedError
  end
end

class ReadOnlyDatabase
  include Connectable
  include Queryable

  def connect
    puts "Read-only: Connected"
  end

  def disconnect
    puts "Read-only: Disconnected"
  end

  def execute_query(sql)
    puts "Read-only: Executing #{sql}"
  end
end

class FullDatabase
  include Connectable
  include Queryable
  include Transactional
  include Backupable

  def connect
    puts "Full DB: Connected"
  end

  def disconnect
    puts "Full DB: Disconnected"
  end

  def execute_query(sql)
    puts "Full DB: Executing #{sql}"
  end

  def begin_transaction
    puts "Full DB: Transaction started"
  end

  def commit
    puts "Full DB: Committed"
  end

  def rollback
    puts "Full DB: Rolled back"
  end

  def create_backup
    puts "Full DB: Backup created"
  end

  def restore_backup
    puts "Full DB: Backup restored"
  end
end

puts "Read-Only Database:"
readonly = ReadOnlyDatabase.new
readonly.connect
readonly.execute_query("SELECT * FROM users")
readonly.disconnect

puts "\nFull Database:"
fulldb = FullDatabase.new
fulldb.connect
fulldb.begin_transaction
fulldb.execute_query("INSERT INTO users VALUES (...)")
fulldb.commit
fulldb.create_backup

# ========================================
# 7. ROLE-BASED INTERFACES
# ========================================

puts "\n7. Role-Based Interfaces:"

module Readable
  def read
    raise NotImplementedError
  end
end

module Writable
  def write(content)
    raise NotImplementedError
  end
end

module Deletable
  def delete
    raise NotImplementedError
  end
end

class Viewer
  include Readable

  def read
    puts "Viewer: Reading content"
  end
end

class Editor
  include Readable
  include Writable

  def read
    puts "Editor: Reading content"
  end

  def write(content)
    puts "Editor: Writing #{content}"
  end
end

class Admin
  include Readable
  include Writable
  include Deletable

  def read
    puts "Admin: Reading content"
  end

  def write(content)
    puts "Admin: Writing #{content}"
  end

  def delete
    puts "Admin: Deleting content"
  end
end

puts "Viewer:"
viewer = Viewer.new
viewer.read

puts "\nEditor:"
editor = Editor.new
editor.read
editor.write("new content")

puts "\nAdmin:"
admin = Admin.new
admin.read
admin.write("admin content")
admin.delete

# ========================================
# 8. EVENT HANDLERS
# ========================================

puts "\n8. Event Handlers:"

module ClickHandler
  def on_click
    raise NotImplementedError
  end
end

module HoverHandler
  def on_hover
    raise NotImplementedError
  end
end

module DragHandler
  def on_drag
    raise NotImplementedError
  end

  def on_drop
    raise NotImplementedError
  end
end

class Button
  include ClickHandler
  include HoverHandler

  def on_click
    puts "Button clicked"
  end

  def on_hover
    puts "Button hovered"
  end
end

class DraggableItem
  include ClickHandler
  include DragHandler

  def on_click
    puts "Item clicked"
  end

  def on_drag
    puts "Item being dragged"
  end

  def on_drop
    puts "Item dropped"
  end
end

puts "Button:"
button = Button.new
button.on_click
button.on_hover

puts "\nDraggable Item:"
item = DraggableItem.new
item.on_click
item.on_drag
item.on_drop

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "INTERFACE SEGREGATION PRINCIPLE - SUMMARY"
puts "=" * 50
puts "KEY CONCEPTS:"
puts "• Clients shouldn't depend on unused interfaces"
puts "• Many specific interfaces > one general interface"
puts "• Keep interfaces focused and cohesive"
puts "• Use composition to combine interfaces"
puts "\nRECOGNIZING VIOLATIONS:"
puts "✗ Fat interfaces with many methods"
puts "✗ Implementing methods that throw NotImplementedError"
puts "✗ Implementing no-op methods"
puts "✗ One interface for multiple client types"
puts "\nHOW TO FOLLOW ISP:"
puts "✓ Create role-specific interfaces"
puts "✓ Use Ruby modules for interface segregation"
puts "✓ Group related methods together"
puts "✓ Let classes include only what they need"
puts "\nBENEFITS:"
puts "• More flexible and maintainable code"
puts "• Easier to implement classes"
puts "• Better separation of concerns"
puts "• Reduced coupling"
puts "• Easier testing"
puts "\nIN RUBY:"
puts "• Use modules for interfaces"
puts "• Mix in only needed behaviors"
puts "• Composition over inheritance"
puts "• Duck typing helps naturally"
puts "=" * 50
