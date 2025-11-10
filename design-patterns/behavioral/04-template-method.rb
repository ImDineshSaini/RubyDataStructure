# ========================================
# TEMPLATE METHOD PATTERN
# ========================================
# Defines the skeleton of an algorithm in a method, deferring some steps to subclasses.
# Template Method lets subclasses redefine certain steps without changing the algorithm's structure.

puts "=" * 50
puts "TEMPLATE METHOD PATTERN"
puts "=" * 50

# ========================================
# 1. PROBLEM WITHOUT TEMPLATE METHOD
# ========================================

puts "\n1. Problem - Duplicated Code:"

# BAD: Code duplication across similar classes
class CSVReportBad
  def generate
    puts "Opening CSV file..."
    puts "Writing CSV header..."
    puts "Writing CSV data..."
    puts "Closing CSV file..."
    puts "CSV report generated!"
  end
end

class PDFReportBad
  def generate
    puts "Opening PDF file..."
    puts "Writing PDF header..."
    puts "Writing PDF data..."
    puts "Closing PDF file..."
    puts "PDF report generated!"
  end
end

puts "Without template method (code duplication):"
CSVReportBad.new.generate

# ========================================
# 2. TEMPLATE METHOD PATTERN SOLUTION
# ========================================

puts "\n2. Template Method Pattern:"

# Abstract base class with template method
class Report
  # Template method - defines the algorithm skeleton
  def generate
    open_file
    write_header
    write_data
    write_footer
    close_file
    puts "✅ #{file_type} report generated!"
  end

  # Abstract methods to be implemented by subclasses
  def open_file
    raise NotImplementedError, "Subclasses must implement open_file"
  end

  def write_header
    raise NotImplementedError, "Subclasses must implement write_header"
  end

  def write_data
    raise NotImplementedError, "Subclasses must implement write_data"
  end

  def write_footer
    # Hook method - optional override
    # Default implementation does nothing
  end

  def close_file
    raise NotImplementedError, "Subclasses must implement close_file"
  end

  def file_type
    raise NotImplementedError, "Subclasses must implement file_type"
  end
end

class CSVReport < Report
  def open_file
    puts "📂 Opening CSV file..."
  end

  def write_header
    puts "📝 Writing CSV header: ID,Name,Amount"
  end

  def write_data
    puts "📊 Writing CSV data rows..."
  end

  def close_file
    puts "🔒 Closing CSV file"
  end

  def file_type
    "CSV"
  end
end

class PDFReport < Report
  def open_file
    puts "📂 Opening PDF file..."
  end

  def write_header
    puts "📝 Writing PDF title and header"
  end

  def write_data
    puts "📊 Writing PDF formatted data"
  end

  def write_footer
    puts "🔖 Writing PDF footer with page numbers"
  end

  def close_file
    puts "🔒 Closing PDF file"
  end

  def file_type
    "PDF"
  end
end

class HTMLReport < Report
  def open_file
    puts "📂 Creating HTML file..."
  end

  def write_header
    puts "📝 Writing HTML header: <html><head>...</head><body>"
  end

  def write_data
    puts "📊 Writing HTML table data"
  end

  def write_footer
    puts "🔖 Writing HTML footer: </body></html>"
  end

  def close_file
    puts "🔒 Saving HTML file"
  end

  def file_type
    "HTML"
  end
end

puts "Using template method:"
puts "\nCSV Report:"
CSVReport.new.generate

puts "\nPDF Report:"
PDFReport.new.generate

puts "\nHTML Report:"
HTMLReport.new.generate

# ========================================
# 3. DATA MINING
# ========================================

puts "\n3. Data Mining Template:"

class DataMiner
  def mine(path)
    file = open_file(path)
    data = extract_data(file)
    parsed = parse_data(data)
    analyzed = analyze_data(parsed)
    send_report(analyzed)
    close_file(file)
  end

  def open_file(path)
    puts "📂 Opening file: #{path}"
    path
  end

  def close_file(file)
    puts "🔒 Closing file: #{file}"
  end

  def send_report(analysis)
    puts "📧 Sending report: #{analysis}"
  end

  # Abstract methods
  def extract_data(file)
    raise NotImplementedError
  end

  def parse_data(data)
    raise NotImplementedError
  end

  def analyze_data(data)
    raise NotImplementedError
  end
end

class CSVDataMiner < DataMiner
  def extract_data(file)
    puts "   Extracting CSV data..."
    "csv_raw_data"
  end

  def parse_data(data)
    puts "   Parsing CSV rows and columns..."
    { rows: 100, columns: 5 }
  end

  def analyze_data(data)
    puts "   Analyzing CSV statistics..."
    "CSV Analysis: #{data[:rows]} rows processed"
  end
end

class JSONDataMiner < DataMiner
  def extract_data(file)
    puts "   Extracting JSON data..."
    "json_raw_data"
  end

  def parse_data(data)
    puts "   Parsing JSON objects..."
    { objects: 50, nested_depth: 3 }
  end

  def analyze_data(data)
    puts "   Analyzing JSON structure..."
    "JSON Analysis: #{data[:objects]} objects processed"
  end
end

class XMLDataMiner < DataMiner
  def extract_data(file)
    puts "   Extracting XML data..."
    "xml_raw_data"
  end

  def parse_data(data)
    puts "   Parsing XML nodes..."
    { nodes: 200, attributes: 150 }
  end

  def analyze_data(data)
    puts "   Analyzing XML hierarchy..."
    "XML Analysis: #{data[:nodes]} nodes processed"
  end
end

puts "\nMining CSV data:"
CSVDataMiner.new.mine("data.csv")

puts "\nMining JSON data:"
JSONDataMiner.new.mine("data.json")

# ========================================
# 4. GAME AI
# ========================================

puts "\n4. Game AI Template:"

class GameAI
  def turn
    collect_data
    analyze_data
    build_decision
    execute_decision
    puts "🎮 Turn completed!\n"
  end

  # Hook methods - can be overridden
  def collect_data
    puts "📊 Collecting game state data..."
  end

  def analyze_data
    puts "🤔 Analyzing current situation..."
  end

  # Abstract methods
  def build_decision
    raise NotImplementedError
  end

  def execute_decision
    raise NotImplementedError
  end
end

class AggressiveAI < GameAI
  def analyze_data
    super
    puts "   🔥 Focusing on attack opportunities"
  end

  def build_decision
    puts "⚔️  Deciding to attack weakest enemy"
  end

  def execute_decision
    puts "💥 Launching aggressive assault!"
  end
end

class DefensiveAI < GameAI
  def analyze_data
    super
    puts "   🛡️  Evaluating defensive positions"
  end

  def build_decision
    puts "🏰 Deciding to fortify defenses"
  end

  def execute_decision
    puts "🔒 Building defensive structures"
  end
end

class BalancedAI < GameAI
  def analyze_data
    super
    puts "   ⚖️  Balancing offense and defense"
  end

  def build_decision
    puts "🎯 Deciding on balanced strategy"
  end

  def execute_decision
    puts "⚡ Executing tactical maneuver"
  end
end

puts "Aggressive AI turn:"
AggressiveAI.new.turn

puts "Defensive AI turn:"
DefensiveAI.new.turn

puts "Balanced AI turn:"
BalancedAI.new.turn

# ========================================
# 5. TEST FRAMEWORK
# ========================================

puts "\n5. Test Framework Template:"

class TestCase
  def initialize(name)
    @name = name
  end

  def run
    setup
    begin
      run_test
      puts "✅ Test '#{@name}' passed"
    rescue => e
      puts "❌ Test '#{@name}' failed: #{e.message}"
    ensure
      teardown
    end
  end

  # Hook methods
  def setup
    # Default implementation
  end

  def teardown
    # Default implementation
  end

  # Abstract method
  def run_test
    raise NotImplementedError
  end
end

class DatabaseTest < TestCase
  def setup
    puts "🔧 Setting up test database..."
    @connection = "db_connection"
  end

  def run_test
    puts "🧪 Running database tests..."
    puts "   Testing INSERT operation"
    puts "   Testing SELECT operation"
    raise "Connection timeout" if rand > 0.8  # Simulate occasional failure
  end

  def teardown
    puts "🧹 Cleaning up test database..."
    @connection = nil
  end
end

class APITest < TestCase
  def setup
    puts "🔧 Setting up API client..."
    @api_client = "api_connection"
  end

  def run_test
    puts "🧪 Running API tests..."
    puts "   Testing GET endpoint"
    puts "   Testing POST endpoint"
  end

  def teardown
    puts "🧹 Closing API connections..."
    @api_client = nil
  end
end

puts "Running database tests:"
DatabaseTest.new("DB Operations").run

puts "\nRunning API tests:"
APITest.new("API Endpoints").run

# ========================================
# 6. COOKING RECIPE
# ========================================

puts "\n6. Cooking Recipe Template:"

class Recipe
  def prepare
    gather_ingredients
    prepare_ingredients
    cook
    plate
    serve
    puts "🍽️  Enjoy your #{dish_name}!\n"
  end

  def gather_ingredients
    puts "🛒 Gathering ingredients for #{dish_name}..."
  end

  # Hook - optional override
  def prepare_ingredients
    puts "🔪 Basic ingredient preparation"
  end

  # Abstract methods
  def cook
    raise NotImplementedError
  end

  def plate
    raise NotImplementedError
  end

  def dish_name
    raise NotImplementedError
  end

  def serve
    puts "🎁 Serving #{dish_name}"
  end
end

class Pasta < Recipe
  def prepare_ingredients
    super
    puts "   Boiling water for pasta"
    puts "   Chopping vegetables"
  end

  def cook
    puts "👨‍🍳 Cooking pasta al dente"
    puts "   Preparing sauce"
  end

  def plate
    puts "🍝 Plating pasta with sauce on top"
  end

  def dish_name
    "Pasta Primavera"
  end
end

class Steak < Recipe
  def prepare_ingredients
    super
    puts "   Seasoning steak with salt and pepper"
    puts "   Preparing sides"
  end

  def cook
    puts "👨‍🍳 Searing steak to medium-rare"
    puts "   Grilling vegetables"
  end

  def plate
    puts "🥩 Plating steak with vegetables"
  end

  def dish_name
    "Grilled Steak"
  end
end

class Cake < Recipe
  def prepare_ingredients
    super
    puts "   Mixing dry ingredients"
    puts "   Mixing wet ingredients"
  end

  def cook
    puts "👨‍🍳 Baking cake at 350°F for 30 minutes"
    puts "   Preparing frosting"
  end

  def plate
    puts "🎂 Frosting and decorating cake"
  end

  def dish_name
    "Chocolate Cake"
  end
end

puts "Preparing pasta:"
Pasta.new.prepare

puts "Preparing steak:"
Steak.new.prepare

puts "Preparing cake:"
Cake.new.prepare

# ========================================
# 7. WEB SCRAPER
# ========================================

puts "\n7. Web Scraper Template:"

class WebScraper
  def scrape(url)
    page = fetch_page(url)
    content = parse_page(page)
    data = extract_data(content)
    cleaned = clean_data(data)
    save_data(cleaned)
    puts "✅ Scraping completed!\n"
  end

  def fetch_page(url)
    puts "🌐 Fetching page: #{url}"
    "html_content"
  end

  def clean_data(data)
    puts "🧹 Cleaning extracted data..."
    data
  end

  def save_data(data)
    puts "💾 Saving data: #{data}"
  end

  # Abstract methods
  def parse_page(page)
    raise NotImplementedError
  end

  def extract_data(content)
    raise NotImplementedError
  end
end

class ProductScraper < WebScraper
  def parse_page(page)
    puts "📄 Parsing product page HTML..."
    "product_content"
  end

  def extract_data(content)
    puts "🔍 Extracting product details (name, price, rating)..."
    { name: "Product X", price: 99.99, rating: 4.5 }
  end
end

class ArticleScraper < WebScraper
  def parse_page(page)
    puts "📄 Parsing article page HTML..."
    "article_content"
  end

  def extract_data(content)
    puts "🔍 Extracting article text, author, date..."
    { title: "Article Title", author: "John Doe", date: "2025-01-01" }
  end
end

puts "Scraping product:"
ProductScraper.new.scrape("https://example.com/product")

puts "Scraping article:"
ArticleScraper.new.scrape("https://example.com/article")

# ========================================
# 8. BUILD PROCESS
# ========================================

puts "\n8. Build Process Template:"

class Builder
  def build
    clean
    compile
    run_tests
    package
    deploy
    puts "✅ Build completed!\n"
    true
  rescue => e
    puts "❌ Build failed: #{e.message}\n"
    false
  end

  def clean
    puts "🧹 Cleaning build directory..."
  end

  def run_tests
    puts "🧪 Running tests..."
  end

  # Abstract methods
  def compile
    raise NotImplementedError
  end

  def package
    raise NotImplementedError
  end

  def deploy
    raise NotImplementedError
  end
end

class JavaBuilder < Builder
  def compile
    puts "☕ Compiling Java files with javac..."
  end

  def package
    puts "📦 Creating JAR file..."
  end

  def deploy
    puts "🚀 Deploying to application server..."
  end
end

class RubyBuilder < Builder
  def compile
    puts "💎 Checking Ruby syntax..."
  end

  def package
    puts "📦 Creating gem file..."
  end

  def deploy
    puts "🚀 Pushing to RubyGems..."
  end
end

class DockerBuilder < Builder
  def compile
    puts "🐳 Building Docker image..."
  end

  def package
    puts "📦 Tagging Docker image..."
  end

  def deploy
    puts "🚀 Pushing to Docker registry..."
  end

  def run_tests
    super
    puts "   Running integration tests in container"
  end
end

puts "Java build:"
JavaBuilder.new.build

puts "Ruby build:"
RubyBuilder.new.build

puts "Docker build:"
DockerBuilder.new.build

# ========================================
# 9. HOOKS IN TEMPLATE METHOD
# ========================================

puts "\n9. Using Hooks:"

class Document
  def process
    open_document
    pre_process if respond_to?(:pre_process)
    parse_content
    post_process if respond_to?(:post_process)
    save_document
    puts "✅ Document processed!\n"
  end

  def open_document
    puts "📂 Opening document..."
  end

  def save_document
    puts "💾 Saving document..."
  end

  # Hook methods - optional
  # Subclasses can override these if needed

  def parse_content
    raise NotImplementedError
  end
end

class SimpleDocument < Document
  def parse_content
    puts "📄 Parsing simple document content"
  end
end

class ComplexDocument < Document
  def pre_process
    puts "🔧 Pre-processing: Validating document structure"
  end

  def parse_content
    puts "📄 Parsing complex document with multiple sections"
  end

  def post_process
    puts "🎨 Post-processing: Applying formatting and styles"
  end
end

puts "Simple document:"
SimpleDocument.new.process

puts "Complex document:"
ComplexDocument.new.process

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "TEMPLATE METHOD PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Define skeleton of algorithm in base class"
puts "• Let subclasses override specific steps"
puts "• Preserve overall algorithm structure"
puts "• Implement invariant parts once"
puts "\nWHEN TO USE:"
puts "• Common algorithm with varying steps"
puts "• Control subclass extensions at specific points"
puts "• Avoid code duplication in similar algorithms"
puts "• Implement invariant behavior once"
puts "\nCOMPONENTS:"
puts "• Template method: Defines algorithm skeleton"
puts "• Primitive operations: Abstract methods to override"
puts "• Hook operations: Optional methods with default behavior"
puts "• Concrete classes: Implement abstract operations"
puts "\nBENEFITS:"
puts "✓ Code reuse - common code in base class"
puts "✓ Control extension points"
puts "✓ Enforce algorithm structure"
puts "✓ Hollywood Principle: Don't call us, we'll call you"
puts "✓ Eliminate duplicate code"
puts "\nDRAWBACKS:"
puts "✗ Subclasses limited to algorithm structure"
puts "✗ Can violate Liskov Substitution Principle"
puts "✗ More classes for each variant"
puts "✗ Maintenance can be difficult with many steps"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Test frameworks (setup/test/teardown)"
puts "• Build systems (clean/compile/test/package)"
puts "• Data processing pipelines"
puts "• Game AI turn processing"
puts "• Report generation"
puts "• Web scraping workflows"
puts "\nHOOK METHODS:"
puts "• Optional methods with default implementation"
puts "• Subclasses can override if needed"
puts "• Provide extension points without forcing override"
puts "• Use respond_to? to check if hook exists"
puts "=" * 50
