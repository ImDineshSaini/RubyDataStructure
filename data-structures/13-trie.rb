# ========================================
# TRIES (PREFIX TREES) IN RUBY
# ========================================
# A Trie is a tree-like data structure used for storing strings.
# Excellent for prefix matching, autocomplete, and dictionary operations.

puts "=" * 50
puts "TRIES (PREFIX TREES) IN RUBY"
puts "=" * 50

# ========================================
# 1. BASIC TRIE IMPLEMENTATION
# ========================================

puts "\n1. Basic Trie Implementation:"

class TrieNode
  attr_accessor :children, :is_end_of_word

  def initialize
    @children = {}
    @is_end_of_word = false
  end
end

class Trie
  def initialize
    @root = TrieNode.new
  end

  # Insert a word - O(m) where m is word length
  def insert(word)
    node = @root

    word.each_char do |char|
      node.children[char] ||= TrieNode.new
      node = node.children[char]
    end

    node.is_end_of_word = true
  end

  # Search for exact word - O(m)
  def search(word)
    node = @root

    word.each_char do |char|
      return false unless node.children[char]
      node = node.children[char]
    end

    node.is_end_of_word
  end

  # Check if prefix exists - O(m)
  def starts_with(prefix)
    node = @root

    prefix.each_char do |char|
      return false unless node.children[char]
      node = node.children[char]
    end

    true
  end

  # Delete a word - O(m)
  def delete(word)
    delete_helper(@root, word, 0)
  end

  private

  def delete_helper(node, word, index)
    return false if node.nil?

    # Base case: reached end of word
    if index == word.length
      return false unless node.is_end_of_word

      node.is_end_of_word = false

      # Delete node if it has no children
      return node.children.empty?
    end

    char = word[index]
    child = node.children[char]

    should_delete = delete_helper(child, word, index + 1)

    if should_delete
      node.children.delete(char)
      return node.children.empty? && !node.is_end_of_word
    end

    false
  end
end

puts "Basic Trie operations:"
trie = Trie.new
words = ["cat", "car", "card", "care", "careful", "dog", "dodge", "door"]

words.each { |word| trie.insert(word) }

puts "Search 'car': #{trie.search('car')}"
puts "Search 'cars': #{trie.search('cars')}"
puts "Starts with 'car': #{trie.starts_with('car')}"
puts "Starts with 'cat': #{trie.starts_with('cat')}"
puts "Starts with 'do': #{trie.starts_with('do')}"

trie.delete('car')
puts "\nAfter deleting 'car':"
puts "Search 'car': #{trie.search('car')}"
puts "Search 'card': #{trie.search('card')}"

# ========================================
# 2. TRIE WITH AUTOCOMPLETE
# ========================================

puts "\n2. Trie with Autocomplete:"

class AutocompleteTrie < Trie
  # Get all words with given prefix
  def autocomplete(prefix)
    node = @root

    # Navigate to prefix node
    prefix.each_char do |char|
      return [] unless node.children[char]
      node = node.children[char]
    end

    # Collect all words from this node
    results = []
    collect_words(node, prefix, results)
    results
  end

  private

  def collect_words(node, current_word, results)
    results << current_word if node.is_end_of_word

    node.children.each do |char, child_node|
      collect_words(child_node, current_word + char, results)
    end
  end
end

puts "Autocomplete functionality:"
ac_trie = AutocompleteTrie.new

words = %w[
  apple apply application appreciate
  banana band bandana
  cat car card care careful carrot
]

words.each { |word| ac_trie.insert(word) }

puts "\nAutocomplete 'app':"
puts ac_trie.autocomplete('app').inspect

puts "\nAutocomplete 'car':"
puts ac_trie.autocomplete('car').inspect

puts "\nAutocomplete 'ban':"
puts ac_trie.autocomplete('ban').inspect

# ========================================
# 3. TRIE WITH WORD COUNT
# ========================================

puts "\n3. Trie with Word Count:"

class CountingTrieNode
  attr_accessor :children, :count

  def initialize
    @children = {}
    @count = 0  # Number of times word ends here
  end
end

class CountingTrie
  def initialize
    @root = CountingTrieNode.new
  end

  def insert(word)
    node = @root

    word.each_char do |char|
      node.children[char] ||= CountingTrieNode.new
      node = node.children[char]
    end

    node.count += 1
  end

  def count(word)
    node = @root

    word.each_char do |char|
      return 0 unless node.children[char]
      node = node.children[char]
    end

    node.count
  end

  def total_words_with_prefix(prefix)
    node = @root

    prefix.each_char do |char|
      return 0 unless node.children[char]
      node = node.children[char]
    end

    count_all_words(node)
  end

  private

  def count_all_words(node)
    total = node.count

    node.children.each_value do |child|
      total += count_all_words(child)
    end

    total
  end
end

puts "Counting Trie:"
counting_trie = CountingTrie.new

text = "the cat and the dog and the cat"
text.split.each { |word| counting_trie.insert(word) }

puts "Count 'cat': #{counting_trie.count('cat')}"
puts "Count 'the': #{counting_trie.count('the')}"
puts "Count 'dog': #{counting_trie.count('dog')}"
puts "Count 'and': #{counting_trie.count('and')}"
puts "Total words starting with 'th': #{counting_trie.total_words_with_prefix('th')}"

# ========================================
# 4. TRIE FOR LONGEST PREFIX
# ========================================

puts "\n4. Finding Longest Common Prefix:"

class PrefixTrie < Trie
  def longest_common_prefix
    return "" if @root.children.empty?

    prefix = ""
    node = @root

    while node.children.size == 1 && !node.is_end_of_word
      char = node.children.keys.first
      prefix += char
      node = node.children[char]
    end

    prefix
  end
end

puts "Longest common prefix:"
prefix_trie = PrefixTrie.new

# Words with common prefix "flow"
["flower", "flow", "flight"].each { |word| prefix_trie.insert(word) }
puts "Words: flower, flow, flight"
puts "Longest common prefix: '#{prefix_trie.longest_common_prefix}'"

prefix_trie2 = PrefixTrie.new
["dog", "racecar", "car"].each { |word| prefix_trie2.insert(word) }
puts "\nWords: dog, racecar, car"
puts "Longest common prefix: '#{prefix_trie2.longest_common_prefix}'"

# ========================================
# 5. SPELL CHECKER USING TRIE
# ========================================

puts "\n5. Spell Checker with Suggestions:"

class SpellChecker
  def initialize
    @trie = AutocompleteTrie.new
  end

  def add_word(word)
    @trie.insert(word.downcase)
  end

  def is_correct?(word)
    @trie.search(word.downcase)
  end

  def suggest(word)
    word = word.downcase
    return [word] if is_correct?(word)

    suggestions = []

    # Try removing each character
    word.length.times do |i|
      modified = word[0...i] + word[i+1..]
      suggestions += @trie.autocomplete(modified)
    end

    # Try replacing each character
    word.length.times do |i|
      ('a'..'z').each do |char|
        modified = word[0...i] + char + word[i+1..]
        suggestions += @trie.autocomplete(modified)
      end
    end

    suggestions.uniq.first(5)
  end
end

puts "Spell checker:"
checker = SpellChecker.new

dictionary = %w[hello world ruby programming language developer code test]
dictionary.each { |word| checker.add_word(word) }

puts "\nCheck 'hello': #{checker.is_correct?('hello')}"
puts "Check 'helo': #{checker.is_correct?('helo')}"

puts "\nSuggestions for 'helo':"
puts checker.suggest('helo').inspect

puts "\nSuggestions for 'wrld':"
puts checker.suggest('wrld').inspect

# ========================================
# 6. WORD SEARCH BOARD (PRACTICAL APPLICATION)
# ========================================

puts "\n6. Word Search in Grid:"

class WordSearchTrie
  def initialize(words)
    @trie = Trie.new
    words.each { |word| @trie.insert(word) }
  end

  def find_words(board)
    found = []
    rows = board.length
    cols = board[0].length

    rows.times do |i|
      cols.times do |j|
        dfs(board, i, j, @trie.instance_variable_get(:@root), "", found)
      end
    end

    found.uniq
  end

  private

  def dfs(board, i, j, node, current_word, found)
    return if i < 0 || i >= board.length || j < 0 || j >= board[0].length
    return if board[i][j] == '#'  # Already visited

    char = board[i][j]
    return unless node.children[char]

    current_word += char
    node = node.children[char]

    found << current_word if node.is_end_of_word

    # Mark as visited
    temp = board[i][j]
    board[i][j] = '#'

    # Explore all 4 directions
    [[0,1], [1,0], [0,-1], [-1,0]].each do |di, dj|
      dfs(board, i + di, j + dj, node, current_word, found)
    end

    # Restore cell
    board[i][j] = temp
  end
end

board = [
  ['o', 'a', 'a', 'n'],
  ['e', 't', 'a', 'e'],
  ['i', 'h', 'k', 'r'],
  ['i', 'f', 'l', 'v']
]

words = ['oath', 'eat', 'rain', 'hklf', 'hf']

puts "Word search board:"
board.each { |row| puts row.join(' ') }

search = WordSearchTrie.new(words)
found = search.find_words(board)

puts "\nWords to find: #{words.inspect}"
puts "Found words: #{found.inspect}"

# ========================================
# 7. CONTACT LIST (PRACTICAL)
# ========================================

puts "\n7. Contact List with Trie:"

class Contact
  attr_accessor :name, :phone, :email

  def initialize(name, phone, email)
    @name = name
    @phone = phone
    @email = email
  end

  def to_s
    "#{@name} - #{@phone} (#{@email})"
  end
end

class ContactTrieNode
  attr_accessor :children, :contacts

  def initialize
    @children = {}
    @contacts = []
  end
end

class ContactList
  def initialize
    @root = ContactTrieNode.new
  end

  def add_contact(name, phone, email)
    contact = Contact.new(name, phone, email)
    node = @root

    name.downcase.each_char do |char|
      node.children[char] ||= ContactTrieNode.new
      node = node.children[char]
      node.contacts << contact
    end
  end

  def search(prefix)
    node = @root

    prefix.downcase.each_char do |char|
      return [] unless node.children[char]
      node = node.children[char]
    end

    node.contacts.uniq
  end
end

puts "Contact list:"
contacts = ContactList.new

contacts.add_contact("Alice", "555-1234", "alice@example.com")
contacts.add_contact("Bob", "555-5678", "bob@example.com")
contacts.add_contact("Alice Smith", "555-9012", "asmith@example.com")
contacts.add_contact("Charlie", "555-3456", "charlie@example.com")
contacts.add_contact("Alex", "555-7890", "alex@example.com")

puts "\nSearch 'al':"
contacts.search('al').each { |c| puts "  #{c}" }

puts "\nSearch 'ali':"
contacts.search('ali').each { |c| puts "  #{c}" }

puts "\nSearch 'ch':"
contacts.search('ch').each { |c| puts "  #{c}" }

# ========================================
# 8. IP ROUTING TABLE
# ========================================

puts "\n8. IP Routing Table (Binary Trie):"

class IPTrieNode
  attr_accessor :children, :gateway

  def initialize
    @children = {}
    @gateway = nil
  end
end

class IPRoutingTable
  def initialize
    @root = IPTrieNode.new
  end

  def add_route(ip_prefix, gateway)
    node = @root

    ip_prefix.each_char do |bit|
      node.children[bit] ||= IPTrieNode.new
      node = node.children[bit]
    end

    node.gateway = gateway
  end

  def find_route(ip_binary)
    node = @root
    last_gateway = nil

    ip_binary.each_char do |bit|
      break unless node.children[bit]

      node = node.children[bit]
      last_gateway = node.gateway if node.gateway
    end

    last_gateway || "default"
  end
end

puts "IP Routing table:"
routing = IPRoutingTable.new

# Add routes (binary representation)
routing.add_route("10", "Gateway A")
routing.add_route("101", "Gateway B")
routing.add_route("1010", "Gateway C")

puts "Route for '10': #{routing.find_route('10')}"
puts "Route for '101': #{routing.find_route('101')}"
puts "Route for '1010': #{routing.find_route('1010')}"
puts "Route for '10101': #{routing.find_route('10101')}"  # Longest prefix match
puts "Route for '11': #{routing.find_route('11')}"

# ========================================
# TIME COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY ANALYSIS"
puts "=" * 50
puts "Let m = length of word, n = number of words, k = alphabet size"
puts "\nOperations:"
puts "  Insert:                O(m)"
puts "  Search:                O(m)"
puts "  Starts with:           O(m)"
puts "  Delete:                O(m)"
puts "  Autocomplete:          O(p + n) where p = prefix length"
puts "  Space:                 O(ALPHABET_SIZE * m * n)"
puts "\nOptimizations:"
puts "  • Use HashMap for sparse children (instead of array)"
puts "  • Compress paths (Radix tree/Patricia trie)"
puts "  • Limit autocomplete results"
puts "=" * 50

# ========================================
# PRACTICE PROBLEMS
# ========================================

puts "\nPRACTICE PROBLEMS:"
puts "1. Implement case-insensitive Trie"
puts "2. Add method to count total words in Trie"
puts "3. Find all words with specific length"
puts "4. Implement wildcard search (. matches any char)"
puts "5. Replace word in Trie"
puts "6. Implement reverse Trie for suffix matching"
puts "7. Find shortest unique prefix for each word"
puts "8. Serialize and deserialize Trie"
puts "9. Implement Trie with weighted words (frequency)"
puts "10. Word break problem using Trie"
puts "11. Implement T9 predictive text"
puts "12. Find all palindromic prefixes"

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "TRIES - SUMMARY"
puts "=" * 50
puts "WHAT IS A TRIE:"
puts "• Tree-like data structure for storing strings"
puts "• Each node represents a character"
puts "• Path from root to node represents prefix"
puts "• Words share common prefixes efficiently"
puts "\nKEY OPERATIONS:"
puts "• Insert word: O(m) where m is word length"
puts "• Search word: O(m)"
puts "• Prefix search: O(m)"
puts "• Autocomplete: O(p + n) for prefix p and n results"
puts "• Delete word: O(m)"
puts "\nWHEN TO USE:"
puts "• Autocomplete functionality"
puts "• Spell checking"
puts "• IP routing (longest prefix match)"
puts "• Contact lists with search"
puts "• Dictionary implementations"
puts "• String prefix matching"
puts "• Word games (Boggle, Scrabble)"
puts "\nADVANTAGES:"
puts "✓ Fast prefix lookups"
puts "✓ Space efficient for shared prefixes"
puts "✓ No hash collisions"
puts "✓ Alphabetically sorted traversal"
puts "✓ Prefix-based operations"
puts "\nDISADVANTAGES:"
puts "✗ More memory than hash table for small datasets"
puts "✗ More complex than hash table"
puts "✗ Cache locality may be poor"
puts "✗ Slower for exact match vs hash table"
puts "\nVARIATIONS:"
puts "• Compressed Trie (Radix Tree): Compress single-child chains"
puts "• Suffix Tree: Trie of all suffixes"
puts "• Ternary Search Tree: Space-efficient variant"
puts "• Bitwise Trie: For binary strings"
puts "\nREAL-WORLD APPLICATIONS:"
puts "• Autocomplete in search engines"
puts "• IP routing tables"
puts "• Spell checkers"
puts "• Phone contact lists"
puts "• Text editors (word suggestions)"
puts "• DNA sequence analysis"
puts "• Compiler symbol tables"
puts "=" * 50
