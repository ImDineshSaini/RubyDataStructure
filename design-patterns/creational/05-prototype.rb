# ========================================
# PROTOTYPE PATTERN
# ========================================
# Creates new objects by copying an existing object (the prototype)
# rather than creating new instances from scratch.

puts "=" * 50
puts "PROTOTYPE PATTERN"
puts "=" * 50

# ========================================
# 1. BASIC PROTOTYPE WITH CLONE
# ========================================

puts "\n1. Basic Prototype using clone:"

class Sheep
  attr_accessor :name, :category, :color

  def initialize(name, category, color)
    @name = name
    @category = category
    @color = color
  end

  def clone
    Sheep.new(@name, @category, @color)
  end

  def to_s
    "Sheep[name=#{@name}, category=#{@category}, color=#{@color}]"
  end
end

original = Sheep.new("Dolly", "Mountain Sheep", "White")
puts "Original: #{original}"

cloned = original.clone
cloned.name = "Molly"
puts "Cloned: #{cloned}"
puts "Original unchanged: #{original}"

# ========================================
# 2. DEEP COPY VS SHALLOW COPY
# ========================================

puts "\n2. Deep Copy vs Shallow Copy:"

class Address
  attr_accessor :street, :city

  def initialize(street, city)
    @street = street
    @city = city
  end

  def to_s
    "#{@street}, #{@city}"
  end
end

class Person
  attr_accessor :name, :address

  def initialize(name, address)
    @name = name
    @address = address
  end

  # Shallow copy - references are shared
  def shallow_copy
    Person.new(@name, @address)
  end

  # Deep copy - creates new objects
  def deep_copy
    Person.new(@name, Address.new(@address.street, @address.city))
  end

  def to_s
    "Person[name=#{@name}, address=#{@address}]"
  end
end

original = Person.new("John", Address.new("123 Main St", "NYC"))
puts "Original: #{original}"

# Shallow copy - address is shared!
shallow = original.shallow_copy
shallow.name = "Jane"
shallow.address.city = "LA"  # This changes original's address too!
puts "\nAfter shallow copy modification:"
puts "Shallow: #{shallow}"
puts "Original: #{original} (address changed!)"

# Deep copy - completely independent
original = Person.new("John", Address.new("123 Main St", "NYC"))
deep = original.deep_copy
deep.name = "Bob"
deep.address.city = "Boston"
puts "\nAfter deep copy modification:"
puts "Deep: #{deep}"
puts "Original: #{original} (unchanged)"

# ========================================
# 3. USING RUBY'S DUP AND CLONE
# ========================================

puts "\n3. Using Ruby's dup and clone:"

class Product
  attr_accessor :name, :price
  attr_reader :created_at

  def initialize(name, price)
    @name = name
    @price = price
    @created_at = Time.now
    freeze_price if price > 1000
  end

  def freeze_price
    @price.freeze
  end

  def to_s
    "Product[name=#{@name}, price=#{@price}, created=#{@created_at}]"
  end
end

product = Product.new("Laptop", 1500)
puts "Original: #{product}"

# dup - doesn't copy frozen state
duped = product.dup
duped.name = "Desktop"
puts "Duped: #{duped}"

# clone - copies frozen state
cloned = product.clone
cloned.name = "Tablet"
puts "Cloned: #{cloned}"

# ========================================
# 4. PROTOTYPE REGISTRY
# ========================================

puts "\n4. Prototype Registry:"

class Shape
  attr_accessor :color, :x, :y

  def initialize
    @color = "white"
    @x = 0
    @y = 0
  end

  def clone
    raise NotImplementedError
  end
end

class Circle < Shape
  attr_accessor :radius

  def initialize
    super
    @radius = 10
  end

  def clone
    circle = Circle.new
    circle.color = @color
    circle.x = @x
    circle.y = @y
    circle.radius = @radius
    circle
  end

  def to_s
    "Circle[color=#{@color}, x=#{@x}, y=#{@y}, radius=#{@radius}]"
  end
end

class Rectangle < Shape
  attr_accessor :width, :height

  def initialize
    super
    @width = 20
    @height = 10
  end

  def clone
    rect = Rectangle.new
    rect.color = @color
    rect.x = @x
    rect.y = @y
    rect.width = @width
    rect.height = @height
    rect
  end

  def to_s
    "Rectangle[color=#{@color}, x=#{@x}, y=#{@y}, w=#{@width}, h=#{@height}]"
  end
end

# Prototype registry
class ShapeRegistry
  def initialize
    @prototypes = {}
    load_prototypes
  end

  def register(key, prototype)
    @prototypes[key] = prototype
  end

  def get(key)
    @prototypes[key]&.clone
  end

  private

  def load_prototypes
    # Pre-configured prototypes
    red_circle = Circle.new
    red_circle.color = "red"
    red_circle.radius = 15
    register(:red_circle, red_circle)

    blue_rect = Rectangle.new
    blue_rect.color = "blue"
    blue_rect.width = 30
    blue_rect.height = 20
    register(:blue_rect, blue_rect)
  end
end

registry = ShapeRegistry.new

# Clone from registry
circle1 = registry.get(:red_circle)
circle1.x = 10
circle1.y = 20
puts "Circle 1: #{circle1}"

circle2 = registry.get(:red_circle)
circle2.x = 30
circle2.y = 40
puts "Circle 2: #{circle2}"

rect = registry.get(:blue_rect)
rect.x = 50
rect.y = 60
puts "Rectangle: #{rect}"

# ========================================
# 5. DOCUMENT TEMPLATES
# ========================================

puts "\n5. Document Templates:"

class Document
  attr_accessor :title, :content, :header, :footer, :styles

  def initialize
    @title = ""
    @content = ""
    @header = ""
    @footer = ""
    @styles = {}
  end

  def clone
    doc = Document.new
    doc.title = @title
    doc.content = @content
    doc.header = @header
    doc.footer = @footer
    doc.styles = @styles.dup
    doc
  end

  def to_s
    "Document[title=#{@title}, header=#{@header}, footer=#{@footer}]"
  end
end

# Create template
template = Document.new
template.header = "Company Logo"
template.footer = "© 2024 Company Inc."
template.styles = { font: "Arial", size: 12 }

puts "Template: #{template}"

# Clone for different documents
invoice = template.clone
invoice.title = "Invoice #001"
invoice.content = "Invoice details..."
puts "Invoice: #{invoice}"

report = template.clone
report.title = "Monthly Report"
report.content = "Report data..."
puts "Report: #{report}"

# ========================================
# 6. GAME CHARACTERS
# ========================================

puts "\n6. Game Characters:"

class GameCharacter
  attr_accessor :name, :health, :mana, :level, :equipment

  def initialize
    @name = "Warrior"
    @health = 100
    @mana = 50
    @level = 1
    @equipment = []
  end

  def clone
    char = self.class.new
    char.name = @name
    char.health = @health
    char.mana = @mana
    char.level = @level
    char.equipment = @equipment.dup  # Shallow copy of array
    char
  end

  def to_s
    "#{@name}[HP=#{@health}, MP=#{@mana}, Lvl=#{@level}, Equipment=#{@equipment.join(', ')}]"
  end
end

class Warrior < GameCharacter
  def initialize
    super
    @name = "Warrior"
    @health = 150
    @mana = 30
    @equipment = ["Sword", "Shield"]
  end
end

class Mage < GameCharacter
  def initialize
    super
    @name = "Mage"
    @health = 80
    @mana = 120
    @equipment = ["Staff", "Robe"]
  end
end

class Archer < GameCharacter
  def initialize
    super
    @name = "Archer"
    @health = 100
    @mana = 60
    @equipment = ["Bow", "Arrows"]
  end
end

# Create character templates
warrior_template = Warrior.new
mage_template = Mage.new

puts "Creating characters from templates:"

# Clone warriors
warrior1 = warrior_template.clone
warrior1.name = "Aragorn"
warrior1.level = 10
puts warrior1

warrior2 = warrior_template.clone
warrior2.name = "Conan"
warrior2.level = 15
puts warrior2

# Clone mages
mage1 = mage_template.clone
mage1.name = "Gandalf"
mage1.level = 20
puts mage1

# ========================================
# 7. CONFIGURATION CLONING
# ========================================

puts "\n7. Configuration Cloning:"

class ServerConfig
  attr_accessor :host, :port, :database, :cache_size, :timeout

  def initialize
    @host = "localhost"
    @port = 8080
    @database = "myapp_dev"
    @cache_size = 1024
    @timeout = 30
  end

  def clone
    config = ServerConfig.new
    config.host = @host
    config.port = @port
    config.database = @database
    config.cache_size = @cache_size
    config.timeout = @timeout
    config
  end

  def to_s
    "Config[#{@host}:#{@port}, DB=#{@database}, Cache=#{@cache_size}MB, Timeout=#{@timeout}s]"
  end
end

# Base configuration
base_config = ServerConfig.new
puts "Base config: #{base_config}"

# Clone for different environments
dev_config = base_config.clone
dev_config.database = "myapp_dev"
dev_config.cache_size = 512
puts "Dev config: #{dev_config}"

staging_config = base_config.clone
staging_config.host = "staging.example.com"
staging_config.database = "myapp_staging"
staging_config.cache_size = 2048
puts "Staging config: #{staging_config}"

prod_config = base_config.clone
prod_config.host = "prod.example.com"
prod_config.port = 443
prod_config.database = "myapp_prod"
prod_config.cache_size = 4096
prod_config.timeout = 60
puts "Prod config: #{prod_config}"

# ========================================
# 8. USING MARSHAL FOR DEEP COPY
# ========================================

puts "\n8. Deep Copy using Marshal:"

class ComplexObject
  attr_accessor :name, :data, :nested

  def initialize(name)
    @name = name
    @data = { values: [1, 2, 3], metadata: { created: Time.now } }
    @nested = { level1: { level2: { level3: "deep" } } }
  end

  def deep_clone
    Marshal.load(Marshal.dump(self))
  end

  def to_s
    "ComplexObject[name=#{@name}, nested=#{@nested}]"
  end
end

original = ComplexObject.new("Original")
puts "Original: #{original}"

# Deep clone using Marshal
deep_copy = original.deep_clone
deep_copy.name = "Copy"
deep_copy.nested[:level1][:level2][:level3] = "modified"

puts "Deep copy: #{deep_copy}"
puts "Original (unchanged): #{original}"

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "PROTOTYPE PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Create objects by cloning existing instances"
puts "• Avoid expensive creation from scratch"
puts "• Specify new objects by copying prototypes"
puts "\nWHEN TO USE:"
puts "• Object creation is expensive"
puts "• Similar objects are needed with slight variations"
puts "• Want to avoid subclass explosion"
puts "• Compose objects at runtime"
puts "\nIMPLEMENTATION IN RUBY:"
puts "• Use clone() or dup() methods"
puts "• Implement custom clone for deep copy"
puts "• Use Marshal for complete deep copy"
puts "• Be aware of frozen objects"
puts "\nDEEP VS SHALLOW COPY:"
puts "• Shallow: Copies object, references shared"
puts "• Deep: Copies object and all nested objects"
puts "• dup: Shallow copy, doesn't copy frozen state"
puts "• clone: Shallow copy, copies frozen state"
puts "• Marshal: True deep copy of everything"
puts "\nBENEFITS:"
puts "✓ Reduces object creation cost"
puts "✓ Simplifies object creation"
puts "✓ Hides concrete classes"
puts "✓ Allows configuration at runtime"
puts "\nDRAWBACKS:"
puts "✗ Deep copying can be complex"
puts "✗ Circular references can be problematic"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Document templates"
puts "• Game character creation"
puts "• Configuration cloning"
puts "• Graphics editor shapes"
puts "=" * 50
