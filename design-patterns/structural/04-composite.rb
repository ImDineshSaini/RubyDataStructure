# ========================================
# COMPOSITE PATTERN
# ========================================
# Composes objects into tree structures to represent part-whole hierarchies.
# Lets clients treat individual objects and compositions uniformly.

puts "=" * 50
puts "COMPOSITE PATTERN"
puts "=" * 50

# ========================================
# 1. PROBLEM WITHOUT COMPOSITE
# ========================================

puts "\n1. Problem - Different Treatment:"

# BAD: Need to check type and handle differently
class FileBad
  attr_reader :name, :size

  def initialize(name, size)
    @name = name
    @size = size
  end
end

class FolderBad
  attr_reader :name
  attr_accessor :children

  def initialize(name)
    @name = name
    @children = []
  end

  def add(item)
    @children << item
  end

  def size
    @children.sum do |child|
      child.is_a?(FolderBad) ? child.size : child.size
    end
  end
end

# Client needs to know the difference
folder = FolderBad.new("root")
folder.add(FileBad.new("file1.txt", 100))
subfolder = FolderBad.new("subfolder")
subfolder.add(FileBad.new("file2.txt", 200))
folder.add(subfolder)

puts "Without composite (client handles types):"
puts "Total size: #{folder.size} bytes"

# ========================================
# 2. COMPOSITE PATTERN SOLUTION
# ========================================

puts "\n2. Composite Pattern:"

# Component interface
class FileSystemComponent
  def name
    raise NotImplementedError
  end

  def size
    raise NotImplementedError
  end

  def display(indent = 0)
    raise NotImplementedError
  end

  # Default implementations for composite-specific methods
  def add(component)
    raise "Cannot add to a leaf"
  end

  def remove(component)
    raise "Cannot remove from a leaf"
  end

  def children
    []
  end
end

# Leaf
class File < FileSystemComponent
  attr_reader :name, :size

  def initialize(name, size)
    @name = name
    @size = size
  end

  def display(indent = 0)
    puts "#{' ' * indent}📄 #{@name} (#{@size} bytes)"
  end
end

# Composite
class Folder < FileSystemComponent
  attr_reader :name

  def initialize(name)
    @name = name
    @children = []
  end

  def add(component)
    @children << component
  end

  def remove(component)
    @children.delete(component)
  end

  def children
    @children
  end

  def size
    @children.sum(&:size)
  end

  def display(indent = 0)
    puts "#{' ' * indent}📁 #{@name}"
    @children.each { |child| child.display(indent + 2) }
  end
end

# Client code - treats leaves and composites uniformly
puts "Using composite pattern:"
root = Folder.new("root")
root.add(File.new("readme.txt", 1000))
root.add(File.new("license.txt", 500))

docs = Folder.new("docs")
docs.add(File.new("manual.pdf", 5000))
docs.add(File.new("guide.pdf", 3000))
root.add(docs)

src = Folder.new("src")
src.add(File.new("main.rb", 2000))
src.add(File.new("utils.rb", 1500))

lib = Folder.new("lib")
lib.add(File.new("helper.rb", 800))
src.add(lib)
root.add(src)

root.display
puts "\nTotal size: #{root.size} bytes"

# ========================================
# 3. ORGANIZATION HIERARCHY
# ========================================

puts "\n3. Organization Hierarchy:"

class Employee
  attr_reader :name, :position, :salary

  def initialize(name, position, salary)
    @name = name
    @position = position
    @salary = salary
  end

  def display(indent = 0)
    raise NotImplementedError
  end

  def total_salary
    raise NotImplementedError
  end

  def add(employee)
    raise "Cannot add subordinate to individual contributor"
  end

  def remove(employee)
    raise "Cannot remove subordinate from individual contributor"
  end
end

class IndividualContributor < Employee
  def display(indent = 0)
    puts "#{' ' * indent}👤 #{@name} - #{@position} ($#{@salary})"
  end

  def total_salary
    @salary
  end
end

class Manager < Employee
  def initialize(name, position, salary)
    super
    @subordinates = []
  end

  def add(employee)
    @subordinates << employee
  end

  def remove(employee)
    @subordinates.delete(employee)
  end

  def display(indent = 0)
    puts "#{' ' * indent}👔 #{@name} - #{@position} ($#{@salary})"
    @subordinates.each { |sub| sub.display(indent + 2) }
  end

  def total_salary
    @salary + @subordinates.sum(&:total_salary)
  end
end

puts "Company hierarchy:"
ceo = Manager.new("Alice", "CEO", 200000)

cto = Manager.new("Bob", "CTO", 150000)
dev1 = IndividualContributor.new("Charlie", "Senior Developer", 100000)
dev2 = IndividualContributor.new("David", "Developer", 80000)
cto.add(dev1)
cto.add(dev2)

cfo = Manager.new("Eve", "CFO", 150000)
acc1 = IndividualContributor.new("Frank", "Accountant", 70000)
acc2 = IndividualContributor.new("Grace", "Financial Analyst", 75000)
cfo.add(acc1)
cfo.add(acc2)

ceo.add(cto)
ceo.add(cfo)

ceo.display
puts "\nTotal payroll: $#{ceo.total_salary}"

# ========================================
# 4. UI COMPONENTS
# ========================================

puts "\n4. UI Component Tree:"

class UIComponent
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def render(indent = 0)
    raise NotImplementedError
  end

  def add(component)
    raise "Cannot add child to primitive component"
  end

  def remove(component)
    raise "Cannot remove child from primitive component"
  end
end

class Button < UIComponent
  def render(indent = 0)
    puts "#{' ' * indent}<Button>#{@name}</Button>"
  end
end

class Label < UIComponent
  def render(indent = 0)
    puts "#{' ' * indent}<Label>#{@name}</Label>"
  end
end

class TextBox < UIComponent
  def render(indent = 0)
    puts "#{' ' * indent}<TextBox>#{@name}</TextBox>"
  end
end

class Panel < UIComponent
  def initialize(name)
    super
    @children = []
  end

  def add(component)
    @children << component
  end

  def remove(component)
    @children.delete(component)
  end

  def render(indent = 0)
    puts "#{' ' * indent}<Panel name='#{@name}'>"
    @children.each { |child| child.render(indent + 2) }
    puts "#{' ' * indent}</Panel>"
  end
end

puts "UI component tree:"
main_panel = Panel.new("MainPanel")
main_panel.add(Label.new("Welcome"))

login_panel = Panel.new("LoginPanel")
login_panel.add(Label.new("Username:"))
login_panel.add(TextBox.new("username_input"))
login_panel.add(Label.new("Password:"))
login_panel.add(TextBox.new("password_input"))
login_panel.add(Button.new("Login"))

main_panel.add(login_panel)
main_panel.add(Button.new("Help"))

main_panel.render

# ========================================
# 5. MENU SYSTEM
# ========================================

puts "\n5. Menu System:"

class MenuComponent
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def display(indent = 0)
    raise NotImplementedError
  end

  def execute
    raise NotImplementedError
  end

  def add(component)
    raise "Cannot add to menu item"
  end
end

class MenuItem < MenuComponent
  def initialize(name, action)
    super(name)
    @action = action
  end

  def display(indent = 0)
    puts "#{' ' * indent}▪️  #{@name}"
  end

  def execute
    puts "Executing: #{@name}"
    @action.call
  end
end

class Menu < MenuComponent
  def initialize(name)
    super
    @items = []
  end

  def add(component)
    @items << component
  end

  def display(indent = 0)
    puts "#{' ' * indent}📋 #{@name}"
    @items.each { |item| item.display(indent + 2) }
  end

  def execute
    puts "Opening menu: #{@name}"
  end
end

puts "Application menu:"
main_menu = Menu.new("Main Menu")

file_menu = Menu.new("File")
file_menu.add(MenuItem.new("New", -> { puts "  Creating new file..." }))
file_menu.add(MenuItem.new("Open", -> { puts "  Opening file..." }))
file_menu.add(MenuItem.new("Save", -> { puts "  Saving file..." }))
file_menu.add(MenuItem.new("Exit", -> { puts "  Exiting application..." }))

edit_menu = Menu.new("Edit")
edit_menu.add(MenuItem.new("Cut", -> { puts "  Cutting..." }))
edit_menu.add(MenuItem.new("Copy", -> { puts "  Copying..." }))
edit_menu.add(MenuItem.new("Paste", -> { puts "  Pasting..." }))

view_menu = Menu.new("View")
view_menu.add(MenuItem.new("Zoom In", -> { puts "  Zooming in..." }))
view_menu.add(MenuItem.new("Zoom Out", -> { puts "  Zooming out..." }))

main_menu.add(file_menu)
main_menu.add(edit_menu)
main_menu.add(view_menu)

main_menu.display

puts "\nExecuting some actions:"
file_menu.execute
main_menu.add(MenuItem.new("Help", -> { puts "  Showing help..." }))

# ========================================
# 6. GRAPHICS SYSTEM
# ========================================

puts "\n6. Graphics Drawing System:"

class Graphic
  def draw
    raise NotImplementedError
  end

  def add(graphic)
    raise "Cannot add to primitive graphic"
  end

  def remove(graphic)
    raise "Cannot remove from primitive graphic"
  end
end

class Circle < Graphic
  def initialize(radius)
    @radius = radius
  end

  def draw
    puts "  ⭕ Drawing circle with radius #{@radius}"
  end
end

class Rectangle < Graphic
  def initialize(width, height)
    @width = width
    @height = height
  end

  def draw
    puts "  ▭ Drawing rectangle #{@width}x#{@height}"
  end
end

class Triangle < Graphic
  def initialize(base, height)
    @base = base
    @height = height
  end

  def draw
    puts "  △ Drawing triangle base=#{@base}, height=#{@height}"
  end
end

class CompositeGraphic < Graphic
  def initialize(name)
    @name = name
    @children = []
  end

  def add(graphic)
    @children << graphic
  end

  def remove(graphic)
    @children.delete(graphic)
  end

  def draw
    puts "📐 Drawing composite: #{@name}"
    @children.each(&:draw)
  end
end

puts "Drawing complex graphics:"
# Create individual shapes
circle = Circle.new(5)
rect = Rectangle.new(10, 20)
triangle = Triangle.new(8, 12)

# Create composite
drawing = CompositeGraphic.new("My Drawing")
drawing.add(circle)
drawing.add(rect)

# Create nested composite
group = CompositeGraphic.new("Shape Group")
group.add(triangle)
group.add(Circle.new(3))
drawing.add(group)

# Draw everything
drawing.draw

# ========================================
# 7. PRODUCT CATALOG
# ========================================

puts "\n7. Product Catalog:"

class CatalogItem
  def price
    raise NotImplementedError
  end

  def description
    raise NotImplementedError
  end

  def add(item)
    raise "Cannot add to simple product"
  end
end

class Product < CatalogItem
  attr_reader :name, :base_price

  def initialize(name, base_price)
    @name = name
    @base_price = base_price
  end

  def price
    @base_price
  end

  def description
    "#{@name}: $#{@base_price}"
  end
end

class ProductBundle < CatalogItem
  attr_reader :name

  def initialize(name, discount = 0)
    @name = name
    @items = []
    @discount = discount
  end

  def add(item)
    @items << item
  end

  def remove(item)
    @items.delete(item)
  end

  def price
    total = @items.sum(&:price)
    total * (1 - @discount)
  end

  def description
    puts "#{@name} Bundle" + (@discount > 0 ? " (#{@discount * 100}% off)" : "")
    @items.each { |item| puts "  - #{item.description}" }
    puts "  Bundle Total: $#{price.round(2)}"
  end
end

puts "Product catalog:"
laptop = Product.new("Laptop", 1000)
mouse = Product.new("Mouse", 50)
keyboard = Product.new("Keyboard", 100)
monitor = Product.new("Monitor", 300)

# Create office bundle with 10% discount
office_bundle = ProductBundle.new("Office Bundle", 0.10)
office_bundle.add(laptop)
office_bundle.add(mouse)
office_bundle.add(keyboard)
office_bundle.add(monitor)

puts "\nIndividual products:"
puts laptop.description
puts mouse.description

puts "\nBundle:"
office_bundle.description

# Nested bundle
starter_accessories = ProductBundle.new("Starter Accessories", 0.05)
starter_accessories.add(mouse)
starter_accessories.add(keyboard)

complete_setup = ProductBundle.new("Complete Setup", 0.15)
complete_setup.add(laptop)
complete_setup.add(monitor)
complete_setup.add(starter_accessories)

puts "\nNested bundle:"
complete_setup.description

# ========================================
# 8. ARITHMETIC EXPRESSIONS
# ========================================

puts "\n8. Arithmetic Expression Tree:"

class Expression
  def evaluate
    raise NotImplementedError
  end

  def to_s
    raise NotImplementedError
  end
end

class Number < Expression
  def initialize(value)
    @value = value
  end

  def evaluate
    @value
  end

  def to_s
    @value.to_s
  end
end

class Addition < Expression
  def initialize(left, right)
    @left = left
    @right = right
  end

  def evaluate
    @left.evaluate + @right.evaluate
  end

  def to_s
    "(#{@left} + #{@right})"
  end
end

class Subtraction < Expression
  def initialize(left, right)
    @left = left
    @right = right
  end

  def evaluate
    @left.evaluate - @right.evaluate
  end

  def to_s
    "(#{@left} - #{@right})"
  end
end

class Multiplication < Expression
  def initialize(left, right)
    @left = left
    @right = right
  end

  def evaluate
    @left.evaluate * @right.evaluate
  end

  def to_s
    "(#{@left} * #{@right})"
  end
end

# Build expression: ((5 + 3) * (10 - 2))
expr = Multiplication.new(
  Addition.new(Number.new(5), Number.new(3)),
  Subtraction.new(Number.new(10), Number.new(2))
)

puts "Expression: #{expr}"
puts "Result: #{expr.evaluate}"

# More complex: (((2 + 3) * 4) - (10 / 2))
class Division < Expression
  def initialize(left, right)
    @left = left
    @right = right
  end

  def evaluate
    @left.evaluate / @right.evaluate
  end

  def to_s
    "(#{@left} / #{@right})"
  end
end

complex_expr = Subtraction.new(
  Multiplication.new(
    Addition.new(Number.new(2), Number.new(3)),
    Number.new(4)
  ),
  Division.new(Number.new(10), Number.new(2))
)

puts "\nComplex expression: #{complex_expr}"
puts "Result: #{complex_expr.evaluate}"

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "COMPOSITE PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Compose objects into tree structures"
puts "• Represent part-whole hierarchies"
puts "• Treat individual objects and compositions uniformly"
puts "• Let clients ignore difference between compositions and leaves"
puts "\nWHEN TO USE:"
puts "• Represent part-whole hierarchies"
puts "• Want clients to treat all objects uniformly"
puts "• Want to build tree structures"
puts "• Need to work with objects at different levels of abstraction"
puts "\nCOMPONENTS:"
puts "• Component: Interface for all objects"
puts "• Leaf: Primitive object (no children)"
puts "• Composite: Object with children"
puts "• Client: Manipulates objects through component interface"
puts "\nBENEFITS:"
puts "✓ Defines class hierarchies of primitive and composite objects"
puts "✓ Makes client code simple"
puts "✓ Easy to add new components"
puts "✓ Open/Closed Principle"
puts "✓ Uniform treatment of objects"
puts "\nDRAWBACKS:"
puts "✗ Can make design overly general"
puts "✗ Hard to restrict components"
puts "✗ May need runtime type checks"
puts "✗ Overhead for simple structures"
puts "\nREAL-WORLD EXAMPLES:"
puts "• File systems (files and folders)"
puts "• UI component trees"
puts "• Organization hierarchies"
puts "• Menu systems"
puts "• Graphics drawing (shapes and groups)"
puts "• Product bundles in e-commerce"
puts "• Expression trees in compilers"
puts "\nIMPLEMENTATION NOTES:"
puts "• Decide if leaves should implement composite methods"
puts "• Consider child management in component vs composite"
puts "• Trade-off: transparency vs safety"
puts "• Use caching for expensive operations"
puts "=" * 50
