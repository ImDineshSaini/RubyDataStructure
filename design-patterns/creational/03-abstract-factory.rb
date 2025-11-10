# ========================================
# ABSTRACT FACTORY PATTERN
# ========================================
# Provides an interface for creating families of related or dependent objects
# without specifying their concrete classes.

puts "=" * 50
puts "ABSTRACT FACTORY PATTERN"
puts "=" * 50

# ========================================
# 1. PROBLEM WITHOUT ABSTRACT FACTORY
# ========================================

puts "\n1. Problem - Mixing Product Families:"

# Without abstract factory, we might mix incompatible products
class WindowsButton
  def render
    "Rendering Windows button"
  end
end

class MacButton
  def render
    "Rendering Mac button"
  end
end

# Easy to create incompatible combinations!
# button = WindowsButton.new
# checkbox = MacCheckbox.new  # Oops! Mixed Windows and Mac!

# ========================================
# 2. ABSTRACT FACTORY SOLUTION
# ========================================

puts "\n2. Abstract Factory Solution:"

# Abstract products
class Button
  def render
    raise NotImplementedError
  end
end

class Checkbox
  def render
    raise NotImplementedError
  end
end

class TextField
  def render
    raise NotImplementedError
  end
end

# Windows family
class WindowsButton < Button
  def render
    "🪟 Windows Button"
  end
end

class WindowsCheckbox < Checkbox
  def render
    "🪟 Windows Checkbox"
  end
end

class WindowsTextField < TextField
  def render
    "🪟 Windows TextField"
  end
end

# Mac family
class MacButton < Button
  def render
    "🍎 Mac Button"
  end
end

class MacCheckbox < Checkbox
  def render
    "🍎 Mac Checkbox"
  end
end

class MacTextField < TextField
  def render
    "🍎 Mac TextField"
  end
end

# Linux family
class LinuxButton < Button
  def render
    "🐧 Linux Button"
  end
end

class LinuxCheckbox < Checkbox
  def render
    "🐧 Linux Checkbox"
  end
end

class LinuxTextField < TextField
  def render
    "🐧 Linux TextField"
  end
end

# Abstract Factory
class GUIFactory
  def create_button
    raise NotImplementedError
  end

  def create_checkbox
    raise NotImplementedError
  end

  def create_text_field
    raise NotImplementedError
  end
end

# Concrete Factories
class WindowsFactory < GUIFactory
  def create_button
    WindowsButton.new
  end

  def create_checkbox
    WindowsCheckbox.new
  end

  def create_text_field
    WindowsTextField.new
  end
end

class MacFactory < GUIFactory
  def create_button
    MacButton.new
  end

  def create_checkbox
    MacCheckbox.new
  end

  def create_text_field
    MacTextField.new
  end
end

class LinuxFactory < GUIFactory
  def create_button
    LinuxButton.new
  end

  def create_checkbox
    LinuxCheckbox.new
  end

  def create_text_field
    LinuxTextField.new
  end
end

# Client code
class Application
  def initialize(factory)
    @factory = factory
  end

  def create_ui
    button = @factory.create_button
    checkbox = @factory.create_checkbox
    text_field = @factory.create_text_field

    puts "Creating UI:"
    puts "  #{button.render}"
    puts "  #{checkbox.render}"
    puts "  #{text_field.render}"
  end
end

puts "Windows Application:"
app = Application.new(WindowsFactory.new)
app.create_ui

puts "\nMac Application:"
app = Application.new(MacFactory.new)
app.create_ui

puts "\nLinux Application:"
app = Application.new(LinuxFactory.new)
app.create_ui

# ========================================
# 3. FURNITURE FACTORY EXAMPLE
# ========================================

puts "\n3. Furniture Factory:"

# Abstract products
class Chair
  def sit_on
    raise NotImplementedError
  end
end

class Sofa
  def lie_on
    raise NotImplementedError
  end
end

class CoffeeTable
  def put_on
    raise NotImplementedError
  end
end

# Victorian family
class VictorianChair < Chair
  def sit_on
    "Sitting on Victorian chair 🪑"
  end
end

class VictorianSofa < Sofa
  def lie_on
    "Lying on Victorian sofa 🛋️"
  end
end

class VictorianCoffeeTable < CoffeeTable
  def put_on
    "Putting coffee on Victorian table ☕"
  end
end

# Modern family
class ModernChair < Chair
  def sit_on
    "Sitting on modern chair 💺"
  end
end

class ModernSofa < Sofa
  def lie_on
    "Lying on modern sofa 🛋️"
  end
end

class ModernCoffeeTable < CoffeeTable
  def put_on
    "Putting coffee on modern table ☕"
  end
end

# Art Deco family
class ArtDecoChair < Chair
  def sit_on
    "Sitting on Art Deco chair ✨"
  end
end

class ArtDecoSofa < Sofa
  def lie_on
    "Lying on Art Deco sofa ✨"
  end
end

class ArtDecoCoffeeTable < CoffeeTable
  def put_on
    "Putting coffee on Art Deco table ☕"
  end
end

# Abstract Factory
class FurnitureFactory
  def create_chair
    raise NotImplementedError
  end

  def create_sofa
    raise NotImplementedError
  end

  def create_coffee_table
    raise NotImplementedError
  end
end

# Concrete Factories
class VictorianFactory < FurnitureFactory
  def create_chair
    VictorianChair.new
  end

  def create_sofa
    VictorianSofa.new
  end

  def create_coffee_table
    VictorianCoffeeTable.new
  end
end

class ModernFactory < FurnitureFactory
  def create_chair
    ModernChair.new
  end

  def create_sofa
    ModernSofa.new
  end

  def create_coffee_table
    ModernCoffeeTable.new
  end
end

class ArtDecoFactory < FurnitureFactory
  def create_chair
    ArtDecoChair.new
  end

  def create_sofa
    ArtDecoSofa.new
  end

  def create_coffee_table
    ArtDecoCoffeeTable.new
  end
end

def furnish_room(factory)
  chair = factory.create_chair
  sofa = factory.create_sofa
  table = factory.create_coffee_table

  puts chair.sit_on
  puts sofa.lie_on
  puts table.put_on
end

puts "Victorian Style:"
furnish_room(VictorianFactory.new)

puts "\nModern Style:"
furnish_room(ModernFactory.new)

puts "\nArt Deco Style:"
furnish_room(ArtDecoFactory.new)

# ========================================
# 4. DOCUMENT CREATOR
# ========================================

puts "\n4. Document Creator:"

# Abstract products
class Document
  def create
    raise NotImplementedError
  end
end

class Header
  def render
    raise NotImplementedError
  end
end

class Footer
  def render
    raise NotImplementedError
  end
end

# PDF family
class PDFDocument < Document
  def create
    "Creating PDF document 📄"
  end
end

class PDFHeader < Header
  def render
    "PDF Header with logo"
  end
end

class PDFFooter < Footer
  def render
    "PDF Footer with page numbers"
  end
end

# HTML family
class HTMLDocument < Document
  def create
    "Creating HTML document 🌐"
  end
end

class HTMLHeader < Header
  def render
    "<header>HTML Header</header>"
  end
end

class HTMLFooter < Footer
  def render
    "<footer>HTML Footer</footer>"
  end
end

# Word family
class WordDocument < Document
  def create
    "Creating Word document 📝"
  end
end

class WordHeader < Header
  def render
    "Word Header with styles"
  end
end

class WordFooter < Footer
  def render
    "Word Footer with metadata"
  end
end

# Abstract Factory
class DocumentFactory
  def create_document
    raise NotImplementedError
  end

  def create_header
    raise NotImplementedError
  end

  def create_footer
    raise NotImplementedError
  end
end

# Concrete Factories
class PDFFactory < DocumentFactory
  def create_document
    PDFDocument.new
  end

  def create_header
    PDFHeader.new
  end

  def create_footer
    PDFFooter.new
  end
end

class HTMLFactory < DocumentFactory
  def create_document
    HTMLDocument.new
  end

  def create_header
    HTMLHeader.new
  end

  def create_footer
    HTMLFooter.new
  end
end

class WordFactory < DocumentFactory
  def create_document
    WordDocument.new
  end

  def create_header
    WordHeader.new
  end

  def create_footer
    WordFooter.new
  end
end

def create_document_with_layout(factory)
  doc = factory.create_document
  header = factory.create_header
  footer = factory.create_footer

  puts doc.create
  puts "  #{header.render}"
  puts "  #{footer.render}"
end

puts "PDF Creation:"
create_document_with_layout(PDFFactory.new)

puts "\nHTML Creation:"
create_document_with_layout(HTMLFactory.new)

puts "\nWord Creation:"
create_document_with_layout(WordFactory.new)

# ========================================
# 5. DATABASE CONNECTION FACTORY
# ========================================

puts "\n5. Database Connection Factory:"

# Abstract products
class Connection
  def connect
    raise NotImplementedError
  end
end

class Query
  def execute(sql)
    raise NotImplementedError
  end
end

class Transaction
  def begin
    raise NotImplementedError
  end

  def commit
    raise NotImplementedError
  end
end

# MySQL family
class MySQLConnection < Connection
  def connect
    "MySQL: Connected to database"
  end
end

class MySQLQuery < Query
  def execute(sql)
    "MySQL: Executing #{sql}"
  end
end

class MySQLTransaction < Transaction
  def begin
    "MySQL: Transaction started"
  end

  def commit
    "MySQL: Transaction committed"
  end
end

# PostgreSQL family
class PostgreSQLConnection < Connection
  def connect
    "PostgreSQL: Connected to database"
  end
end

class PostgreSQLQuery < Query
  def execute(sql)
    "PostgreSQL: Executing #{sql}"
  end
end

class PostgreSQLTransaction < Transaction
  def begin
    "PostgreSQL: Transaction started"
  end

  def commit
    "PostgreSQL: Transaction committed"
  end
end

# Abstract Factory
class DatabaseFactory
  def create_connection
    raise NotImplementedError
  end

  def create_query
    raise NotImplementedError
  end

  def create_transaction
    raise NotImplementedError
  end
end

# Concrete Factories
class MySQLFactory < DatabaseFactory
  def create_connection
    MySQLConnection.new
  end

  def create_query
    MySQLQuery.new
  end

  def create_transaction
    MySQLTransaction.new
  end
end

class PostgreSQLFactory < DatabaseFactory
  def create_connection
    PostgreSQLConnection.new
  end

  def create_query
    PostgreSQLQuery.new
  end

  def create_transaction
    PostgreSQLTransaction.new
  end
end

class DatabaseClient
  def initialize(factory)
    @connection = factory.create_connection
    @query = factory.create_query
    @transaction = factory.create_transaction
  end

  def execute
    puts @connection.connect
    puts @transaction.begin
    puts @query.execute("SELECT * FROM users")
    puts @transaction.commit
  end
end

puts "MySQL Client:"
client = DatabaseClient.new(MySQLFactory.new)
client.execute

puts "\nPostgreSQL Client:"
client = DatabaseClient.new(PostgreSQLFactory.new)
client.execute

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "ABSTRACT FACTORY PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Create families of related objects"
puts "• Ensure compatibility within families"
puts "• Hide concrete classes from client"
puts "\nWHEN TO USE:"
puts "• System should be independent of how products are created"
puts "• System should work with multiple families of products"
puts "• Family of related products designed to be used together"
puts "• Want to enforce using products from same family"
puts "\nBENEFITS:"
puts "✓ Isolates concrete classes"
puts "✓ Makes exchanging product families easy"
puts "✓ Promotes consistency among products"
puts "✓ Supports Open/Closed Principle"
puts "\nDRAWBACKS:"
puts "✗ Difficult to support new product types"
puts "✗ Increases overall code complexity"
puts "\nDIFFERENCE FROM FACTORY METHOD:"
puts "• Factory Method: Creates one product"
puts "• Abstract Factory: Creates families of products"
puts "\nREAL-WORLD EXAMPLES:"
puts "• UI toolkits (Windows, Mac, Linux)"
puts "• Document formats (PDF, HTML, Word)"
puts "• Database drivers (MySQL, PostgreSQL)"
puts "• Cross-platform apps"
puts "=" * 50
