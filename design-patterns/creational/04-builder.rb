# ========================================
# BUILDER PATTERN
# ========================================
# Separates the construction of a complex object from its representation,
# allowing the same construction process to create various representations.

puts "=" * 50
puts "BUILDER PATTERN"
puts "=" * 50

# ========================================
# 1. PROBLEM WITHOUT BUILDER
# ========================================

puts "\n1. Problem - Complex Constructor:"

# BAD: Constructor with many parameters
class ComputerBad
  attr_reader :cpu, :ram, :storage, :gpu, :wifi, :bluetooth

  def initialize(cpu, ram, storage, gpu = nil, wifi = false, bluetooth = false)
    @cpu = cpu
    @ram = ram
    @storage = storage
    @gpu = gpu
    @wifi = wifi
    @bluetooth = bluetooth
  end

  def specs
    puts "CPU: #{@cpu}, RAM: #{@ram}GB, Storage: #{@storage}GB"
    puts "GPU: #{@gpu || 'Integrated'}"
    puts "WiFi: #{@wifi ? 'Yes' : 'No'}, Bluetooth: #{@bluetooth ? 'Yes' : 'No'}"
  end
end

# Confusing constructor calls
pc1 = ComputerBad.new("Intel i7", 16, 512, "RTX 3080", true, true)
pc2 = ComputerBad.new("AMD Ryzen", 32, 1024)  # What are the defaults?

puts "PC 1:"
pc1.specs

# ========================================
# 2. BASIC BUILDER
# ========================================

puts "\n2. Basic Builder Pattern:"

class Computer
  attr_reader :cpu, :ram, :storage, :gpu, :wifi, :bluetooth

  def initialize(builder)
    @cpu = builder.cpu
    @ram = builder.ram
    @storage = builder.storage
    @gpu = builder.gpu
    @wifi = builder.wifi
    @bluetooth = builder.bluetooth
  end

  def specs
    puts "\n--- Computer Specs ---"
    puts "CPU: #{@cpu}"
    puts "RAM: #{@ram}GB"
    puts "Storage: #{@storage}GB"
    puts "GPU: #{@gpu || 'Integrated'}"
    puts "WiFi: #{@wifi ? 'Yes' : 'No'}"
    puts "Bluetooth: #{@bluetooth ? 'Yes' : 'No'}"
  end
end

class ComputerBuilder
  attr_accessor :cpu, :ram, :storage, :gpu, :wifi, :bluetooth

  def initialize
    # Set defaults
    @cpu = "Intel i5"
    @ram = 8
    @storage = 256
    @gpu = nil
    @wifi = false
    @bluetooth = false
  end

  def set_cpu(cpu)
    @cpu = cpu
    self  # Return self for method chaining
  end

  def set_ram(ram)
    @ram = ram
    self
  end

  def set_storage(storage)
    @storage = storage
    self
  end

  def set_gpu(gpu)
    @gpu = gpu
    self
  end

  def add_wifi
    @wifi = true
    self
  end

  def add_bluetooth
    @bluetooth = true
    self
  end

  def build
    Computer.new(self)
  end
end

# Clean, fluent interface
gaming_pc = ComputerBuilder.new
  .set_cpu("Intel i9")
  .set_ram(32)
  .set_storage(2048)
  .set_gpu("RTX 4090")
  .add_wifi
  .add_bluetooth
  .build

gaming_pc.specs

office_pc = ComputerBuilder.new
  .set_cpu("Intel i5")
  .set_ram(16)
  .set_storage(512)
  .add_wifi
  .build

office_pc.specs

# ========================================
# 3. BUILDER WITH BLOCK
# ========================================

puts "\n3. Builder with Block (Ruby Style):"

class User
  attr_reader :name, :email, :age, :address, :phone

  def initialize(builder)
    @name = builder.name
    @email = builder.email
    @age = builder.age
    @address = builder.address
    @phone = builder.phone
  end

  def self.build
    builder = UserBuilder.new
    yield(builder) if block_given?
    builder.create
  end

  def to_s
    "User: #{@name}, #{@email}, Age: #{@age}, #{@address}, #{@phone}"
  end
end

class UserBuilder
  attr_accessor :name, :email, :age, :address, :phone

  def create
    raise "Name is required" unless @name
    raise "Email is required" unless @email

    User.new(self)
  end
end

# Ruby-style builder with block
user = User.build do |u|
  u.name = "John Doe"
  u.email = "john@example.com"
  u.age = 30
  u.address = "123 Main St"
  u.phone = "555-0100"
end

puts user

# ========================================
# 4. HTML BUILDER
# ========================================

puts "\n4. HTML Builder:"

class HtmlElement
  attr_accessor :name, :text

  def initialize(name, text = "")
    @name = name
    @text = text
    @elements = []
  end

  def add_child(element)
    @elements << element
  end

  def to_s(indent = 0)
    lines = []
    lines << "#{' ' * indent}<#{@name}>"
    lines << "#{' ' * (indent + 2)}#{@text}" unless @text.empty?

    @elements.each do |element|
      lines << element.to_s(indent + 2)
    end

    lines << "#{' ' * indent}</#{@name}>"
    lines.join("\n")
  end
end

class HtmlBuilder
  def initialize(root_name)
    @root = HtmlElement.new(root_name)
  end

  def add_child(name, text = "")
    element = HtmlElement.new(name, text)
    @root.add_child(element)
    self
  end

  def add_child_fluent(name, text = "")
    add_child(name, text)
  end

  def build
    @root
  end

  def to_s
    @root.to_s
  end
end

# Building HTML
html = HtmlBuilder.new("div")
  .add_child("h1", "Welcome")
  .add_child("p", "This is a paragraph")
  .add_child("p", "Another paragraph")
  .build

puts "\nGenerated HTML:"
puts html

# ========================================
# 5. QUERY BUILDER
# ========================================

puts "\n5. SQL Query Builder:"

class Query
  attr_reader :sql

  def initialize(table)
    @table = table
    @conditions = []
    @order = nil
    @limit = nil
  end

  def where(condition)
    @conditions << condition
    self
  end

  def order_by(column)
    @order = column
    self
  end

  def limit(count)
    @limit = count
    self
  end

  def to_sql
    sql = "SELECT * FROM #{@table}"

    unless @conditions.empty?
      sql += " WHERE " + @conditions.join(" AND ")
    end

    sql += " ORDER BY #{@order}" if @order
    sql += " LIMIT #{@limit}" if @limit

    sql
  end
end

# Fluent query building
query = Query.new("users")
  .where("age > 18")
  .where("active = true")
  .order_by("created_at DESC")
  .limit(10)

puts "\nGenerated SQL:"
puts query.to_sql

# ========================================
# 6. EMAIL BUILDER
# ========================================

puts "\n6. Email Builder:"

class Email
  attr_reader :from, :to, :subject, :body, :attachments

  def initialize(builder)
    @from = builder.from
    @to = builder.to
    @subject = builder.subject
    @body = builder.body
    @attachments = builder.attachments
  end

  def send
    puts "\n--- Sending Email ---"
    puts "From: #{@from}"
    puts "To: #{@to.join(', ')}"
    puts "Subject: #{@subject}"
    puts "Body: #{@body}"
    puts "Attachments: #{@attachments.join(', ')}" unless @attachments.empty?
    puts "Email sent successfully!"
  end
end

class EmailBuilder
  attr_accessor :from, :to, :subject, :body, :attachments

  def initialize
    @to = []
    @attachments = []
  end

  def from(address)
    @from = address
    self
  end

  def to(address)
    @to << address
    self
  end

  def subject(subject)
    @subject = subject
    self
  end

  def body(body)
    @body = body
    self
  end

  def attach(file)
    @attachments << file
    self
  end

  def build
    raise "From address is required" unless @from
    raise "At least one recipient is required" if @to.empty?

    Email.new(self)
  end
end

email = EmailBuilder.new
  .from("sender@example.com")
  .to("recipient1@example.com")
  .to("recipient2@example.com")
  .subject("Meeting Tomorrow")
  .body("Don't forget about tomorrow's meeting at 10 AM")
  .attach("agenda.pdf")
  .attach("slides.pptx")
  .build

email.send

# ========================================
# 7. PIZZA BUILDER
# ========================================

puts "\n7. Pizza Builder:"

class Pizza
  attr_reader :size, :crust, :cheese, :toppings, :sauce

  def initialize(builder)
    @size = builder.size
    @crust = builder.crust
    @cheese = builder.cheese
    @toppings = builder.toppings
    @sauce = builder.sauce
  end

  def description
    puts "\n🍕 Pizza Order:"
    puts "Size: #{@size}"
    puts "Crust: #{@crust}"
    puts "Cheese: #{@cheese}"
    puts "Sauce: #{@sauce}"
    puts "Toppings: #{@toppings.join(', ')}"
  end

  def price
    base = case @size
           when :small then 8
           when :medium then 12
           when :large then 16
           end

    base + (@toppings.length * 1.5)
  end
end

class PizzaBuilder
  attr_accessor :size, :crust, :cheese, :sauce, :toppings

  def initialize
    @size = :medium
    @crust = "regular"
    @cheese = "mozzarella"
    @sauce = "tomato"
    @toppings = []
  end

  def size(size)
    @size = size
    self
  end

  def crust(type)
    @crust = type
    self
  end

  def cheese(type)
    @cheese = type
    self
  end

  def sauce(type)
    @sauce = type
    self
  end

  def add_topping(topping)
    @toppings << topping
    self
  end

  def build
    Pizza.new(self)
  end
end

# Build different pizzas
supreme = PizzaBuilder.new
  .size(:large)
  .crust("thick")
  .add_topping("pepperoni")
  .add_topping("sausage")
  .add_topping("mushrooms")
  .add_topping("onions")
  .add_topping("bell peppers")
  .build

supreme.description
puts "Price: $#{supreme.price}"

margherita = PizzaBuilder.new
  .size(:small)
  .crust("thin")
  .sauce("white")
  .add_topping("basil")
  .add_topping("tomatoes")
  .build

margherita.description
puts "Price: $#{margherita.price}"

# ========================================
# 8. DIRECTOR PATTERN
# ========================================

puts "\n8. Director Pattern:"

class CarBuilder
  attr_accessor :make, :model, :year, :color, :engine, :transmission

  def build
    {
      make: @make,
      model: @model,
      year: @year,
      color: @color,
      engine: @engine,
      transmission: @transmission
    }
  end
end

class CarDirector
  def initialize(builder)
    @builder = builder
  end

  def construct_sports_car
    @builder.make = "Ferrari"
    @builder.model = "F8"
    @builder.year = 2024
    @builder.color = "Red"
    @builder.engine = "V8 Twin-Turbo"
    @builder.transmission = "7-Speed Dual-Clutch"
    @builder.build
  end

  def construct_family_car
    @builder.make = "Toyota"
    @builder.model = "Camry"
    @builder.year = 2024
    @builder.color = "Silver"
    @builder.engine = "2.5L 4-Cylinder"
    @builder.transmission = "8-Speed Automatic"
    @builder.build
  end

  def construct_electric_car
    @builder.make = "Tesla"
    @builder.model = "Model 3"
    @builder.year = 2024
    @builder.color = "White"
    @builder.engine = "Dual Motor Electric"
    @builder.transmission = "Single-Speed Direct Drive"
    @builder.build
  end
end

builder = CarBuilder.new
director = CarDirector.new(builder)

puts "\nBuilding cars with director:"
sports_car = director.construct_sports_car
puts "Sports Car: #{sports_car}"

family_car = director.construct_family_car
puts "Family Car: #{family_car}"

electric_car = director.construct_electric_car
puts "Electric Car: #{electric_car}"

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "BUILDER PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Separate construction from representation"
puts "• Construct complex objects step by step"
puts "• Same construction process, different representations"
puts "\nWHEN TO USE:"
puts "• Object construction is complex"
puts "• Need different representations of object"
puts "• Want to isolate construction code"
puts "• Telescoping constructor anti-pattern"
puts "\nBENEFITS:"
puts "✓ Control construction process step by step"
puts "✓ Reuse same construction code"
puts "✓ Isolate complex construction code"
puts "✓ Single Responsibility Principle"
puts "✓ Fluent interface (method chaining)"
puts "\nDRAWBACKS:"
puts "✗ Increases overall code complexity"
puts "✗ More classes to maintain"
puts "\nREAL-WORLD EXAMPLES:"
puts "• StringBuilder in Java/C#"
puts "• SQL Query builders"
puts "• HTML/XML builders"
puts "• Configuration objects"
puts "• Test data builders"
puts "=" * 50
