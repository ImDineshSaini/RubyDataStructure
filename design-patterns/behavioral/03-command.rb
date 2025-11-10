# ========================================
# COMMAND PATTERN
# ========================================
# Encapsulates a request as an object, allowing parameterization of clients
# with different requests, queue or log requests, and support undoable operations.

puts "=" * 50
puts "COMMAND PATTERN"
puts "=" * 50

# ========================================
# 1. BASIC COMMAND PATTERN
# ========================================

puts "\n1. Basic Command Pattern:"

# Receiver
class Light
  def on
    puts "Light is ON"
  end

  def off
    puts "Light is OFF"
  end
end

# Command interface
class Command
  def execute
    raise NotImplementedError
  end

  def undo
    raise NotImplementedError
  end
end

# Concrete Commands
class LightOnCommand < Command
  def initialize(light)
    @light = light
  end

  def execute
    @light.on
  end

  def undo
    @light.off
  end
end

class LightOffCommand < Command
  def initialize(light)
    @light = light
  end

  def execute
    @light.off
  end

  def undo
    @light.on
  end
end

# Invoker
class RemoteControl
  def initialize
    @commands = {}
    @history = []
  end

  def set_command(slot, command)
    @commands[slot] = command
  end

  def press_button(slot)
    if @commands[slot]
      @commands[slot].execute
      @history.push(@commands[slot])
    end
  end

  def press_undo
    if @history.any?
      command = @history.pop
      command.undo
    end
  end
end

light = Light.new
light_on = LightOnCommand.new(light)
light_off = LightOffCommand.new(light)

remote = RemoteControl.new
remote.set_command(0, light_on)
remote.set_command(1, light_off)

remote.press_button(0)  # Light ON
remote.press_button(1)  # Light OFF
remote.press_undo       # Light ON (undo)

# ========================================
# 2. TEXT EDITOR WITH UNDO/REDO
# ========================================

puts "\n2. Text Editor with Undo/Redo:"

class TextEditor
  attr_reader :text

  def initialize
    @text = ""
  end

  def write(text)
    @text += text
  end

  def delete(length)
    @text = @text[0...-length]
  end

  def display
    puts "Text: '#{@text}'"
  end
end

class WriteCommand < Command
  def initialize(editor, text)
    @editor = editor
    @text = text
  end

  def execute
    @editor.write(@text)
  end

  def undo
    @editor.delete(@text.length)
  end
end

class DeleteCommand < Command
  def initialize(editor, length)
    @editor = editor
    @length = length
    @deleted_text = nil
  end

  def execute
    @deleted_text = @editor.text[-@length..-1]
    @editor.delete(@length)
  end

  def undo
    @editor.write(@deleted_text) if @deleted_text
  end
end

class EditorInvoker
  def initialize(editor)
    @editor = editor
    @history = []
    @redo_stack = []
  end

  def execute_command(command)
    command.execute
    @history.push(command)
    @redo_stack.clear
  end

  def undo
    if @history.any?
      command = @history.pop
      command.undo
      @redo_stack.push(command)
    end
  end

  def redo
    if @redo_stack.any?
      command = @redo_stack.pop
      command.execute
      @history.push(command)
    end
  end
end

editor = TextEditor.new
invoker = EditorInvoker.new(editor)

invoker.execute_command(WriteCommand.new(editor, "Hello "))
editor.display

invoker.execute_command(WriteCommand.new(editor, "World"))
editor.display

invoker.execute_command(DeleteCommand.new(editor, 5))
editor.display

invoker.undo
editor.display

invoker.redo
editor.display

# ========================================
# 3. MACRO COMMANDS
# ========================================

puts "\n3. Macro Commands:"

class Fan
  def high
    puts "Fan: High speed"
  end

  def off
    puts "Fan: OFF"
  end
end

class TV
  def on
    puts "TV: ON"
  end

  def off
    puts "TV: OFF"
  end
end

class FanHighCommand < Command
  def initialize(fan)
    @fan = fan
  end

  def execute
    @fan.high
  end

  def undo
    @fan.off
  end
end

class TVOnCommand < Command
  def initialize(tv)
    @tv = tv
  end

  def execute
    @tv.on
  end

  def undo
    @tv.off
  end
end

# Macro command - executes multiple commands
class MacroCommand < Command
  def initialize(commands)
    @commands = commands
  end

  def execute
    @commands.each(&:execute)
  end

  def undo
    @commands.reverse_each(&:undo)
  end
end

fan = Fan.new
tv = TV.new

party_mode = MacroCommand.new([
  LightOnCommand.new(light),
  FanHighCommand.new(fan),
  TVOnCommand.new(tv)
])

puts "Activating party mode:"
party_mode.execute

puts "\nDeactivating party mode:"
party_mode.undo

# ========================================
# 4. TRANSACTION SYSTEM
# ========================================

puts "\n4. Transaction System:"

class Account
  attr_reader :balance

  def initialize(balance)
    @balance = balance
  end

  def deposit(amount)
    @balance += amount
    puts "Deposited $#{amount}. Balance: $#{@balance}"
  end

  def withdraw(amount)
    @balance -= amount
    puts "Withdrew $#{amount}. Balance: $#{@balance}"
  end
end

class DepositCommand < Command
  def initialize(account, amount)
    @account = account
    @amount = amount
  end

  def execute
    @account.deposit(@amount)
  end

  def undo
    @account.withdraw(@amount)
  end
end

class WithdrawCommand < Command
  def initialize(account, amount)
    @account = account
    @amount = amount
  end

  def execute
    @account.withdraw(@amount)
  end

  def undo
    @account.deposit(@amount)
  end
end

class TransferCommand < Command
  def initialize(from_account, to_account, amount)
    @withdraw = WithdrawCommand.new(from_account, amount)
    @deposit = DepositCommand.new(to_account, amount)
  end

  def execute
    @withdraw.execute
    @deposit.execute
  end

  def undo
    @deposit.undo
    @withdraw.undo
  end
end

account1 = Account.new(1000)
account2 = Account.new(500)

puts "Initial balances - A1: $#{account1.balance}, A2: $#{account2.balance}"

transfer = TransferCommand.new(account1, account2, 200)
transfer.execute

puts "\nAfter transfer - A1: $#{account1.balance}, A2: $#{account2.balance}"

transfer.undo
puts "\nAfter undo - A1: $#{account1.balance}, A2: $#{account2.balance}"

# ========================================
# 5. JOB QUEUE
# ========================================

puts "\n5. Job Queue:"

class EmailJob < Command
  def initialize(to, subject)
    @to = to
    @subject = subject
  end

  def execute
    puts "Sending email to #{@to}: #{@subject}"
  end

  def undo
    puts "Email cannot be unsent"
  end
end

class ReportJob < Command
  def initialize(report_name)
    @report_name = report_name
  end

  def execute
    puts "Generating report: #{@report_name}"
  end

  def undo
    puts "Deleting report: #{@report_name}"
  end
end

class JobQueue
  def initialize
    @queue = []
  end

  def add_job(command)
    @queue.push(command)
    puts "Job added to queue"
  end

  def process_jobs
    puts "\nProcessing #{@queue.size} jobs:"
    until @queue.empty?
      job = @queue.shift
      job.execute
    end
    puts "All jobs processed"
  end
end

queue = JobQueue.new
queue.add_job(EmailJob.new("user@example.com", "Welcome!"))
queue.add_job(ReportJob.new("Monthly Sales"))
queue.add_job(EmailJob.new("admin@example.com", "Report Ready"))
queue.process_jobs

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "COMMAND PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Encapsulate request as object"
puts "• Parameterize clients with different requests"
puts "• Queue or log requests"
puts "• Support undoable operations"
puts "\nWHEN TO USE:"
puts "• Need to parameterize objects with operations"
puts "• Need to queue operations"
puts "• Need to support undo/redo"
puts "• Need to log changes"
puts "• Need to support transactions"
puts "\nCOMPONENTS:"
puts "• Command: Interface for executing operations"
puts "• ConcreteCommand: Implements execute/undo"
puts "• Invoker: Asks command to carry out request"
puts "• Receiver: Knows how to perform operations"
puts "• Client: Creates commands and sets receiver"
puts "\nBENEFITS:"
puts "✓ Decouples sender from receiver"
puts "✓ Easy to add new commands"
puts "✓ Can assemble commands into composite"
puts "✓ Supports undo/redo"
puts "✓ Supports queueing and logging"
puts "\nDRAWBACKS:"
puts "✗ Increases number of classes"
puts "✗ Can be overkill for simple operations"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Text editor (undo/redo)"
puts "• Remote controls"
puts "• Transaction systems"
puts "• Job queues"
puts "• GUI buttons/menu items"
puts "• Macro recording"
puts "=" * 50
