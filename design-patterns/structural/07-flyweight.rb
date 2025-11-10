# ========================================
# FLYWEIGHT PATTERN
# ========================================
# Uses sharing to support large numbers of fine-grained objects efficiently.
# Reduces memory usage by sharing common state between objects.

puts "=" * 50
puts "FLYWEIGHT PATTERN"
puts "=" * 50

# ========================================
# 1. PROBLEM WITHOUT FLYWEIGHT
# ========================================

puts "\n1. Problem - Memory Waste:"

# BAD: Each particle has all data
class ParticleBad
  attr_accessor :x, :y, :velocity_x, :velocity_y
  attr_accessor :color, :sprite_image, :physics_behavior

  def initialize(x, y, color, sprite, physics)
    @x = x
    @y = y
    @velocity_x = rand(-5..5)
    @velocity_y = rand(-5..5)
    @color = color              # Repeats across many particles
    @sprite_image = sprite      # Repeats across many particles
    @physics_behavior = physics # Repeats across many particles
  end

  def draw
    "Drawing #{@color} particle at (#{@x}, #{@y})"
  end
end

puts "Without flyweight (creating 5 particles):"
particles = 5.times.map do |i|
  ParticleBad.new(rand(100), rand(100), "red", "sprite.png", "gravity")
end

puts "Each particle stores color, sprite, and physics"
puts "Memory waste with 10,000 particles would be significant!"

# ========================================
# 2. FLYWEIGHT PATTERN SOLUTION
# ========================================

puts "\n2. Flyweight Pattern:"

# Flyweight - stores intrinsic (shared) state
class ParticleType
  attr_reader :color, :sprite, :physics

  def initialize(color, sprite, physics)
    @color = color
    @sprite = sprite
    @physics = physics
    puts "📦 Creating new particle type: #{color}"
  end

  def draw(x, y, velocity_x, velocity_y)
    "Drawing #{@color} particle at (#{x}, #{y}) moving (#{velocity_x}, #{velocity_y})"
  end
end

# Flyweight factory
class ParticleTypeFactory
  def initialize
    @particle_types = {}
  end

  def get_particle_type(color, sprite, physics)
    key = "#{color}_#{sprite}_#{physics}"

    unless @particle_types[key]
      @particle_types[key] = ParticleType.new(color, sprite, physics)
    end

    @particle_types[key]
  end

  def total_types
    @particle_types.size
  end
end

# Context - stores extrinsic (unique) state
class Particle
  def initialize(x, y, particle_type)
    @x = x
    @y = y
    @velocity_x = rand(-5..5)
    @velocity_y = rand(-5..5)
    @particle_type = particle_type  # Shared flyweight
  end

  def draw
    @particle_type.draw(@x, @y, @velocity_x, @velocity_y)
  end

  def update
    @x += @velocity_x
    @y += @velocity_y
  end
end

puts "Using flyweight pattern:"
factory = ParticleTypeFactory.new

# Create particle types (flyweights)
red_type = factory.get_particle_type("red", "particle.png", "gravity")
blue_type = factory.get_particle_type("blue", "particle.png", "gravity")
red_type_2 = factory.get_particle_type("red", "particle.png", "gravity")  # Reuses existing

puts "Same red type? #{red_type.object_id == red_type_2.object_id}"

# Create many particles sharing the same types
particles = []
1000.times do
  type = rand < 0.5 ? red_type : blue_type
  particles << Particle.new(rand(100), rand(100), type)
end

puts "\nCreated 1000 particles with only #{factory.total_types} shared particle types"
puts particles.first.draw

# ========================================
# 3. TEXT EDITOR (CHARACTER FLYWEIGHTS)
# ========================================

puts "\n3. Text Editor with Character Flyweights:"

# Flyweight - character formatting
class CharacterFormat
  attr_reader :font, :size, :color, :bold, :italic

  def initialize(font, size, color, bold: false, italic: false)
    @font = font
    @size = size
    @color = color
    @bold = bold
    @italic = italic
    puts "  📝 Created format: #{font} #{size}pt #{color} #{bold ? 'bold' : ''} #{italic ? 'italic' : ''}".strip
  end

  def render(char)
    style = []
    style << "bold" if @bold
    style << "italic" if @italic
    style_str = style.empty? ? "" : " (#{style.join(', ')})"
    "#{char}[#{@font} #{@size}pt #{@color}#{style_str}]"
  end
end

# Flyweight factory
class FormatFactory
  def initialize
    @formats = {}
  end

  def get_format(font, size, color, bold: false, italic: false)
    key = "#{font}_#{size}_#{color}_#{bold}_#{italic}"

    unless @formats[key]
      @formats[key] = CharacterFormat.new(font, size, color, bold: bold, italic: italic)
    end

    @formats[key]
  end

  def total_formats
    @formats.size
  end
end

# Context
class Character
  attr_reader :char

  def initialize(char, format)
    @char = char
    @format = format
  end

  def render
    @format.render(@char)
  end
end

puts "Text editor with character flyweights:"
format_factory = FormatFactory.new

# Create different formats
arial_12 = format_factory.get_format("Arial", 12, "black")
arial_12_bold = format_factory.get_format("Arial", 12, "black", bold: true)
times_14 = format_factory.get_format("Times", 14, "blue", italic: true)

# Create characters with shared formats
text = [
  Character.new('H', arial_12_bold),
  Character.new('e', arial_12),
  Character.new('l', arial_12),
  Character.new('l', arial_12),
  Character.new('o', arial_12_bold),
  Character.new('!', times_14)
]

puts "\nRendered text:"
text.each { |c| puts c.render }
puts "\nTotal format objects: #{format_factory.total_formats}"

# ========================================
# 4. TREE RENDERING (FOREST)
# ========================================

puts "\n4. Forest with Tree Flyweights:"

# Flyweight - tree type
class TreeType
  attr_reader :name, :color, :texture

  def initialize(name, color, texture)
    @name = name
    @color = color
    @texture = texture
    puts "  🌲 Created tree type: #{name} (#{color})"
  end

  def render(x, y)
    "Drawing #{@color} #{@name} at (#{x}, #{y}) with texture: #{@texture}"
  end
end

# Flyweight factory
class TreeFactory
  def initialize
    @tree_types = {}
  end

  def get_tree_type(name, color, texture)
    key = "#{name}_#{color}_#{texture}"

    unless @tree_types[key]
      @tree_types[key] = TreeType.new(name, color, texture)
    end

    @tree_types[key]
  end

  def total_types
    @tree_types.size
  end
end

# Context
class Tree
  def initialize(x, y, tree_type)
    @x = x
    @y = y
    @tree_type = tree_type
  end

  def render
    @tree_type.render(@x, @y)
  end
end

# Forest manages trees
class Forest
  def initialize
    @trees = []
    @factory = TreeFactory.new
  end

  def plant_tree(x, y, name, color, texture)
    tree_type = @factory.get_tree_type(name, color, texture)
    tree = Tree.new(x, y, tree_type)
    @trees << tree
  end

  def render
    puts "Rendering forest:"
    @trees.each { |tree| puts "  #{tree.render}" }
    puts "\nForest stats:"
    puts "  Total trees: #{@trees.size}"
    puts "  Unique tree types: #{@factory.total_types}"
    puts "  Memory saved by sharing types!"
  end
end

forest = Forest.new
forest.plant_tree(10, 20, "Oak", "green", "rough_bark.png")
forest.plant_tree(30, 40, "Oak", "green", "rough_bark.png")
forest.plant_tree(50, 60, "Pine", "dark_green", "smooth_bark.png")
forest.plant_tree(70, 80, "Oak", "green", "rough_bark.png")
forest.plant_tree(90, 100, "Birch", "white", "white_bark.png")
forest.plant_tree(110, 120, "Pine", "dark_green", "smooth_bark.png")

forest.render

# ========================================
# 5. ICON CACHE
# ========================================

puts "\n5. Icon Cache Flyweight:"

# Flyweight - icon data
class Icon
  attr_reader :name, :image_data

  def initialize(name, path)
    @name = name
    @image_data = load_image(path)
    puts "  💾 Loaded icon: #{name} from #{path}"
  end

  def render(x, y, size)
    "Rendering #{@name} icon at (#{x}, #{y}) size: #{size}px"
  end

  private

  def load_image(path)
    # Simulate loading image
    "#{path}_image_data_#{rand(1000)}"
  end
end

# Flyweight factory
class IconCache
  def initialize
    @icons = {}
  end

  def get_icon(name, path)
    unless @icons[name]
      @icons[name] = Icon.new(name, path)
    end

    @icons[name]
  end

  def cache_size
    @icons.size
  end
end

# Client
class FileExplorer
  def initialize
    @icon_cache = IconCache.new
    @files = []
  end

  def add_file(name, type, x, y, size)
    icon = case type
    when :document then @icon_cache.get_icon("document", "icons/doc.png")
    when :folder then @icon_cache.get_icon("folder", "icons/folder.png")
    when :image then @icon_cache.get_icon("image", "icons/img.png")
    end

    @files << { name: name, icon: icon, x: x, y: y, size: size }
  end

  def render
    puts "Rendering file explorer:"
    @files.each do |file|
      puts "  #{file[:name]}: #{file[:icon].render(file[:x], file[:y], file[:size])}"
    end
    puts "\nTotal files: #{@files.size}"
    puts "Icons in cache: #{@icon_cache.cache_size}"
  end
end

explorer = FileExplorer.new
explorer.add_file("report.doc", :document, 0, 0, 32)
explorer.add_file("photo.jpg", :image, 0, 40, 32)
explorer.add_file("data.doc", :document, 0, 80, 32)
explorer.add_file("Downloads", :folder, 0, 120, 32)
explorer.add_file("notes.doc", :document, 0, 160, 32)
explorer.add_file("Pictures", :folder, 0, 200, 32)

explorer.render

# ========================================
# 6. CHESS PIECES
# ========================================

puts "\n6. Chess Pieces Flyweight:"

# Flyweight - piece type
class PieceType
  attr_reader :name, :color, :sprite

  def initialize(name, color, sprite)
    @name = name
    @color = color
    @sprite = sprite
    puts "  ♟️  Created piece type: #{color} #{name}"
  end

  def render(row, col)
    "#{@color} #{@name} at (#{row}, #{col})"
  end
end

# Factory
class PieceFactory
  def initialize
    @pieces = {}
  end

  def get_piece(name, color, sprite)
    key = "#{name}_#{color}"

    unless @pieces[key]
      @pieces[key] = PieceType.new(name, color, sprite)
    end

    @pieces[key]
  end

  def total_types
    @pieces.size
  end
end

# Context
class ChessPiece
  def initialize(row, col, piece_type)
    @row = row
    @col = col
    @piece_type = piece_type
  end

  def render
    @piece_type.render(@row, @col)
  end

  def move(new_row, new_col)
    @row = new_row
    @col = new_col
  end
end

# Board
class ChessBoard
  def initialize
    @pieces = []
    @factory = PieceFactory.new
  end

  def add_piece(name, color, row, col, sprite)
    piece_type = @factory.get_piece(name, color, sprite)
    piece = ChessPiece.new(row, col, piece_type)
    @pieces << piece
  end

  def display
    puts "Chess board:"
    @pieces.each { |p| puts "  #{p.render}" }
    puts "\nTotal pieces on board: #{@pieces.size}"
    puts "Unique piece types: #{@factory.total_types}"
  end
end

board = ChessBoard.new

# Add white pieces
board.add_piece("Pawn", "white", 1, 0, "white_pawn.png")
board.add_piece("Pawn", "white", 1, 1, "white_pawn.png")
board.add_piece("Rook", "white", 0, 0, "white_rook.png")
board.add_piece("Knight", "white", 0, 1, "white_knight.png")

# Add black pieces
board.add_piece("Pawn", "black", 6, 0, "black_pawn.png")
board.add_piece("Pawn", "black", 6, 1, "black_pawn.png")
board.add_piece("Rook", "black", 7, 0, "black_rook.png")
board.add_piece("Knight", "black", 7, 1, "black_knight.png")

board.display

# ========================================
# 7. STRING POOL (RUBY-LIKE)
# ========================================

puts "\n7. String Pool Flyweight:"

class StringPool
  def initialize
    @pool = {}
    @stats = { hits: 0, misses: 0 }
  end

  def intern(string)
    if @pool[string]
      @stats[:hits] += 1
      @pool[string]
    else
      @stats[:misses] += 1
      @pool[string] = string.dup.freeze
      @pool[string]
    end
  end

  def size
    @pool.size
  end

  def stats
    @stats
  end
end

pool = StringPool.new

# Simulate many duplicate strings
strings = []
1000.times do
  strings << pool.intern(["hello", "world", "ruby", "flyweight"].sample)
end

puts "String pool stats:"
puts "  Strings created: #{strings.size}"
puts "  Unique strings in pool: #{pool.size}"
puts "  Cache hits: #{pool.stats[:hits]}"
puts "  Cache misses: #{pool.stats[:misses]}"
puts "  Memory saving: #{((pool.stats[:hits].to_f / strings.size) * 100).round(2)}% reuse"

# ========================================
# 8. BULLET POOL (GAME)
# ========================================

puts "\n8. Bullet Pool in Game:"

# Flyweight - bullet type
class BulletType
  attr_reader :damage, :speed, :sprite

  def initialize(name, damage, speed, sprite)
    @name = name
    @damage = damage
    @speed = speed
    @sprite = sprite
    puts "  🔫 Created bullet type: #{name}"
  end

  def render(x, y, direction)
    "#{@name} at (#{x}, #{y}) moving #{direction} speed:#{@speed}"
  end
end

# Factory
class BulletFactory
  def initialize
    @bullet_types = {}
  end

  def get_bullet_type(name, damage, speed, sprite)
    unless @bullet_types[name]
      @bullet_types[name] = BulletType.new(name, damage, speed, sprite)
    end

    @bullet_types[name]
  end

  def total_types
    @bullet_types.size
  end
end

# Context
class Bullet
  def initialize(x, y, direction, bullet_type)
    @x = x
    @y = y
    @direction = direction
    @bullet_type = bullet_type
    @active = true
  end

  def update
    case @direction
    when :up then @y -= @bullet_type.speed
    when :down then @y += @bullet_type.speed
    when :left then @x -= @bullet_type.speed
    when :right then @x += @bullet_type.speed
    end
  end

  def render
    @bullet_type.render(@x, @y, @direction)
  end
end

# Game
class Game
  def initialize
    @bullets = []
    @factory = BulletFactory.new
  end

  def fire_bullet(x, y, direction, type_name)
    bullet_type = case type_name
    when :pistol then @factory.get_bullet_type("Pistol", 10, 5, "pistol.png")
    when :rifle then @factory.get_bullet_type("Rifle", 20, 10, "rifle.png")
    when :shotgun then @factory.get_bullet_type("Shotgun", 15, 3, "shotgun.png")
    end

    @bullets << Bullet.new(x, y, direction, bullet_type)
  end

  def update
    @bullets.each(&:update)
  end

  def render
    puts "Active bullets:"
    @bullets.each { |b| puts "  #{b.render}" }
    puts "\nTotal bullets: #{@bullets.size}"
    puts "Bullet types: #{@factory.total_types}"
  end
end

game = Game.new
game.fire_bullet(10, 20, :up, :pistol)
game.fire_bullet(30, 40, :right, :rifle)
game.fire_bullet(50, 60, :left, :pistol)
game.fire_bullet(70, 80, :down, :shotgun)
game.fire_bullet(90, 100, :up, :pistol)

game.update
game.render

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "FLYWEIGHT PATTERN - SUMMARY"
puts "=" * 50
puts "INTENT:"
puts "• Reduce memory usage with many objects"
puts "• Share common state between objects"
puts "• Support large numbers of fine-grained objects"
puts "\nKEY CONCEPTS:"
puts "• Intrinsic state: Shared, immutable, stored in flyweight"
puts "• Extrinsic state: Unique, varies per context, passed to methods"
puts "• Factory: Manages and reuses flyweight instances"
puts "\nWHEN TO USE:"
puts "• Application uses large number of objects"
puts "• Storage costs are high due to quantity"
puts "• Most object state can be made extrinsic"
puts "• Many objects can be replaced by few shared ones"
puts "• Application doesn't depend on object identity"
puts "\nCOMPONENTS:"
puts "• Flyweight: Stores intrinsic state"
puts "• Flyweight Factory: Creates and manages flyweights"
puts "• Context: Stores extrinsic state"
puts "• Client: Maintains extrinsic state and uses flyweights"
puts "\nBENEFITS:"
puts "✓ Reduces memory usage"
puts "✓ Improves performance (fewer objects)"
puts "✓ Can handle millions of objects"
puts "✓ Centralizes state management"
puts "\nDRAWBACKS:"
puts "✗ Increased complexity"
puts "✗ Runtime cost (computing extrinsic state)"
puts "✗ Code may be harder to understand"
puts "✗ Thread-safety concerns with shared state"
puts "\nREAL-WORLD EXAMPLES:"
puts "• Text editors (character formatting)"
puts "• Game engines (particles, bullets, trees)"
puts "• Graphics systems (colors, fonts, textures)"
puts "• String pools (Ruby symbols, Java String.intern)"
puts "• Icon caches in file explorers"
puts "• Chess/board game pieces"
puts "• Browser DOM nodes with same styling"
puts "\nIMPLEMENTATION TIPS:"
puts "• Make flyweights immutable"
puts "• Use factory to ensure sharing"
puts "• Identify intrinsic vs extrinsic state"
puts "• Extrinsic state passed as method parameters"
puts "• Consider thread-safety for factory"
puts "• Document which state is intrinsic/extrinsic"
puts "\nRUBY SPECIFICS:"
puts "• Use Hash for factory storage"
puts "• Freeze intrinsic state objects"
puts "• Ruby symbols are flyweights"
puts "• Consider using singleton pattern with factory"
puts "=" * 50
