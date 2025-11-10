# ========================================
# STATE PATTERN
# ========================================
# Allows an object to alter its behavior when its internal state changes.
# The object will appear to change its class.

puts "=" * 50
puts "STATE PATTERN"
puts "=" * 50

# ========================================
# 1. PROBLEM WITHOUT STATE PATTERN
# ========================================

puts "\n1. Problem - Conditional Hell:"

# BAD: Using conditionals for different states
class VendingMachineBad
  attr_accessor :state

  def initialize
    @state = :idle
    @balance = 0
  end

  def insert_coin(amount)
    if @state == :idle
      @balance += amount
      @state = :has_money
      puts "Coin inserted. Balance: $#{@balance}"
    elsif @state == :has_money
      @balance += amount
      puts "Coin inserted. Balance: $#{@balance}"
    else
      puts "Cannot insert coin in current state"
    end
  end

  def select_product
    if @state == :has_money && @balance >= 1
      @state = :dispensing
      puts "Product selected"
    elsif @state == :has_money
      puts "Insufficient balance"
    else
      puts "Insert coin first"
    end
  end

  # Complex conditionals for each method...
end

puts "Problems: Hard to maintain, violates Open/Closed Principle"

# ========================================
# 2. STATE PATTERN SOLUTION
# ========================================

puts "\n2. State Pattern:"

# State interface
class State
  def insert_coin(machine, amount)
    raise NotImplementedError
  end

  def select_product(machine)
    raise NotImplementedError
  end

  def dispense(machine)
    raise NotImplementedError
  end
end

# Concrete States
class IdleState < State
  def insert_coin(machine, amount)
    machine.balance += amount
    machine.state = HasMoneyState.new
    puts "Coin inserted. Balance: $#{machine.balance}"
  end

  def select_product(machine)
    puts "Please insert coin first"
  end

  def dispense(machine)
    puts "Cannot dispense in idle state"
  end
end

class HasMoneyState < State
  def insert_coin(machine, amount)
    machine.balance += amount
    puts "Coin inserted. Balance: $#{machine.balance}"
  end

  def select_product(machine)
    if machine.balance >= machine.product_price
      machine.state = DispensingState.new
      puts "Product selected. Dispensing..."
      machine.dispense
    else
      puts "Insufficient balance. Need $#{machine.product_price - machine.balance} more"
    end
  end

  def dispense(machine)
    puts "Select product first"
  end
end

class DispensingState < State
  def insert_coin(machine, amount)
    puts "Already dispensing product"
  end

  def select_product(machine)
    puts "Already dispensing product"
  end

  def dispense(machine)
    puts "Dispensing product..."
    machine.balance -= machine.product_price

    if machine.balance > 0
      puts "Returning change: $#{machine.balance}"
      machine.balance = 0
    end

    machine.state = IdleState.new
    puts "Ready for next customer"
  end
end

# Context
class VendingMachine
  attr_accessor :state, :balance
  attr_reader :product_price

  def initialize
    @state = IdleState.new
    @balance = 0
    @product_price = 1.5
  end

  def insert_coin(amount)
    @state.insert_coin(self, amount)
  end

  def select_product
    @state.select_product(self)
  end

  def dispense
    @state.dispense(self)
  end
end

machine = VendingMachine.new
machine.insert_coin(0.5)
machine.select_product  # Insufficient
machine.insert_coin(1.0)
machine.select_product  # Should work

# ========================================
# 3. DOCUMENT WORKFLOW
# ========================================

puts "\n3. Document Workflow:"

# States
class DocumentState
  def publish(doc)
    puts "Cannot publish from #{self.class}"
  end

  def approve(doc)
    puts "Cannot approve from #{self.class}"
  end

  def reject(doc)
    puts "Cannot reject from #{self.class}"
  end
end

class DraftState < DocumentState
  def submit_for_review(doc)
    doc.state = ReviewState.new
    puts "Document submitted for review"
  end
end

class ReviewState < DocumentState
  def approve(doc)
    doc.state = PublishedState.new
    puts "Document approved and published"
  end

  def reject(doc)
    doc.state = DraftState.new
    puts "Document rejected, back to draft"
  end
end

class PublishedState < DocumentState
  def archive(doc)
    doc.state = ArchivedState.new
    puts "Document archived"
  end
end

class ArchivedState < DocumentState
  def restore(doc)
    doc.state = PublishedState.new
    puts "Document restored to published"
  end
end

class Document
  attr_accessor :state, :content

  def initialize(content)
    @content = content
    @state = DraftState.new
  end

  def submit_for_review
    @state.submit_for_review(self)
  end

  def approve
    @state.approve(self)
  end

  def reject
    @state.reject(self)
  end

  def archive
    @state.archive(self)
  end

  def restore
    @state.restore(self)
  end
end

puts "\nDocument Workflow:"
doc = Document.new("Article content")
doc.submit_for_review
doc.approve
doc.archive

# ========================================
# 4. TCP CONNECTION
# ========================================

puts "\n4. TCP Connection States:"

class TCPState
  def open(connection); end
  def close(connection); end
  def acknowledge(connection); end
end

class ClosedState < TCPState
  def open(connection)
    connection.state = ListenState.new
    puts "TCP: Opening connection..."
  end
end

class ListenState < TCPState
  def acknowledge(connection)
    connection.state = EstablishedState.new
    puts "TCP: Connection established"
  end

  def close(connection)
    connection.state = ClosedState.new
    puts "TCP: Connection closed"
  end
end

class EstablishedState < TCPState
  def close(connection)
    connection.state = CloseWaitState.new
    puts "TCP: Closing connection..."
  end

  def send_data(connection, data)
    puts "TCP: Sending data: #{data}"
  end
end

class CloseWaitState < TCPState
  def close(connection)
    connection.state = ClosedState.new
    puts "TCP: Connection fully closed"
  end
end

class TCPConnection
  attr_accessor :state

  def initialize
    @state = ClosedState.new
  end

  def open
    @state.open(self)
  end

  def close
    @state.close(self)
  end

  def acknowledge
    @state.acknowledge(self)
  end

  def send_data(data)
    @state.send_data(self, data) if @state.respond_to?(:send_data)
  end
end

puts "\nTCP Connection:"
tcp = TCPConnection.new
tcp.open
tcp.acknowledge
tcp.send_data("Hello World")
tcp.close
tcp.close

# ========================================
# 5. PLAYER STATES IN GAME
# ========================================

puts "\n5. Game Player States:"

class PlayerState
  def move(player); end
  def jump(player); end
  def duck(player); end
end

class StandingState < PlayerState
  def move(player)
    player.state = RunningState.new
    puts "Player started running"
  end

  def jump(player)
    player.state = JumpingState.new
    puts "Player jumped"
  end

  def duck(player)
    player.state = DuckingState.new
    puts "Player ducking"
  end
end

class RunningState < PlayerState
  def move(player)
    puts "Already running"
  end

  def jump(player)
    player.state = JumpingState.new
    puts "Player jumped while running"
  end

  def stop(player)
    player.state = StandingState.new
    puts "Player stopped"
  end
end

class JumpingState < PlayerState
  def land(player)
    player.state = StandingState.new
    puts "Player landed"
  end
end

class DuckingState < PlayerState
  def stand(player)
    player.state = StandingState.new
    puts "Player stood up"
  end
end

class Player
  attr_accessor :state

  def initialize
    @state = StandingState.new
  end

  def move
    @state.move(self)
  end

  def jump
    @state.jump(self)
  end

  def duck
    @state.duck(self)
  end

  def stop
    @state.stop(self) if @state.respond_to?(:stop)
  end

  def land
    @state.land(self) if @state.respond_to?(:land)
  end

  def stand
    @state.stand(self) if @state.respond_to?(:stand)
  end
end

puts "\nGame Player:"
player = Player.new
player.move
player.jump
player.land
player.duck
player.stand

# ========================================
# 6. ORDER PROCESSING
# ========================================

puts "\n6. Order Processing:"

class OrderState
  def pay(order); end
  def ship(order); end
  def deliver(order); end
  def cancel(order); end
end

class NewOrderState < OrderState
  def pay(order)
    order.state = PaidState.new
    puts "Order #{order.id} paid"
  end

  def cancel(order)
    order.state = CancelledState.new
    puts "Order #{order.id} cancelled"
  end
end

class PaidState < OrderState
  def ship(order)
    order.state = ShippedState.new
    puts "Order #{order.id} shipped"
  end

  def cancel(order)
    order.state = RefundedState.new
    puts "Order #{order.id} refunded"
  end
end

class ShippedState < OrderState
  def deliver(order)
    order.state = DeliveredState.new
    puts "Order #{order.id} delivered"
  end
end

class DeliveredState < OrderState
  def return_order(order)
    order.state = ReturnedState.new
    puts "Order #{order.id} returned"
  end
end

class CancelledState < OrderState
end

class RefundedState < OrderState
end

class ReturnedState < OrderState
end

class Order
  attr_accessor :state
  attr_reader :id

  def initialize(id)
    @id = id
    @state = NewOrderState.new
  end

  def pay
    @state.pay(self)
  end

  def ship
    @state.ship(self)
  end

  def deliver
    @state.deliver(self)
  end

  def cancel
    @state.cancel(self)
  end

  def return_order
    @state.return_order(self) if @state.respond_to?(:return_order)
  end
end

puts "\nOrder Processing:"
order = Order.new(12345)
order.pay
order.ship
order.deliver

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "STATE PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Allow object to alter behavior when state changes"
puts "• Object appears to change its class"
puts "• Encapsulate state-specific behavior"
puts "\nWHEN TO USE:"
puts "• Object behavior depends on its state"
puts "• Operations have large conditional statements"
puts "• State transitions are complex"
puts "• Want to avoid duplication across states"
puts "\nCOMPONENTS:"
puts "• Context: Maintains current state"
puts "• State: Interface for state-specific behavior"
puts "• ConcreteState: Implements behavior for each state"
puts "\nBENEFITS:"
puts "✓ Localizes state-specific behavior"
puts "✓ Makes state transitions explicit"
puts "✓ Eliminates large conditionals"
puts "✓ Easy to add new states"
puts "✓ Protects Context from inconsistent states"
puts "\nDRAWBACKS:"
puts "✗ Increases number of classes"
puts "✗ Can be overkill for simple state machines"
puts "\nSTATE VS STRATEGY:"
puts "• State: Changes behavior based on internal state"
puts "• Strategy: Behavior chosen by client"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Vending machines"
puts "• TCP connections"
puts "• Document workflows"
puts "• Game character states"
puts "• Order processing"
puts "• Media players"
puts "=" * 50
