# ========================================
# LRU CACHE IN RUBY
# ========================================
# Least Recently Used (LRU) Cache
# Evicts the least recently used item when cache is full
# O(1) time complexity for both get and put operations

puts "=" * 50
puts "LRU CACHE"
puts "=" * 50

# ========================================
# 1. LRU CACHE USING HASH + DOUBLY LINKED LIST
# ========================================

class Node
  attr_accessor :key, :value, :prev, :next

  def initialize(key, value)
    @key = key
    @value = value
    @prev = nil
    @next = nil
  end
end

class LRUCache
  def initialize(capacity)
    @capacity = capacity
    @cache = {}  # Hash for O(1) lookup

    # Dummy head and tail for easier manipulation
    @head = Node.new(nil, nil)
    @tail = Node.new(nil, nil)
    @head.next = @tail
    @tail.prev = @head
  end

  # Get value - O(1)
  def get(key)
    return -1 unless @cache.key?(key)

    node = @cache[key]
    move_to_front(node)
    node.value
  end

  # Put key-value pair - O(1)
  def put(key, value)
    if @cache.key?(key)
      # Update existing node
      node = @cache[key]
      node.value = value
      move_to_front(node)
    else
      # Create new node
      node = Node.new(key, value)
      @cache[key] = node
      add_to_front(node)

      # Evict if over capacity
      if @cache.size > @capacity
        removed = remove_from_tail
        @cache.delete(removed.key)
      end
    end
  end

  # Display cache (for debugging)
  def display
    current = @head.next
    items = []
    while current != @tail
      items << "#{current.key}:#{current.value}"
      current = current.next
    end
    "LRU [#{items.join(' -> ')}] MRU"
  end

  private

  # Move node to front (most recently used)
  def move_to_front(node)
    remove_node(node)
    add_to_front(node)
  end

  # Add node to front
  def add_to_front(node)
    node.next = @head.next
    node.prev = @head
    @head.next.prev = node
    @head.next = node
  end

  # Remove node from list
  def remove_node(node)
    node.prev.next = node.next
    node.next.prev = node.prev
  end

  # Remove least recently used (from tail)
  def remove_from_tail
    node = @tail.prev
    remove_node(node)
    node
  end
end

puts "\n1. LRU Cache Operations:"

cache = LRUCache.new(3)

cache.put(1, "one")
cache.put(2, "two")
cache.put(3, "three")
puts "After putting 1, 2, 3: #{cache.display}"

puts "Get 1: #{cache.get(1)}"
puts "After getting 1 (now MRU): #{cache.display}"

cache.put(4, "four")
puts "After putting 4 (2 evicted): #{cache.display}"

puts "Get 3: #{cache.get(3)}"
puts "After getting 3: #{cache.display}"

cache.put(5, "five")
puts "After putting 5 (1 evicted): #{cache.display}"

# ========================================
# 2. SIMPLE LRU USING RUBY HASH
# ========================================

puts "\n2. Simple LRU using OrderedHash:"

class SimpleLRUCache
  def initialize(capacity)
    @capacity = capacity
    @cache = {}
  end

  def get(key)
    return -1 unless @cache.key?(key)

    # Move to end (most recently used)
    value = @cache.delete(key)
    @cache[key] = value
    value
  end

  def put(key, value)
    # Remove if exists (to reinsert at end)
    @cache.delete(key) if @cache.key?(key)

    @cache[key] = value

    # Evict least recently used (first element)
    @cache.shift if @cache.size > @capacity
  end

  def display
    "LRU #{@cache.keys} MRU"
  end
end

puts "\nSimple LRU Cache:"
simple_cache = SimpleLRUCache.new(3)
simple_cache.put(1, "one")
simple_cache.put(2, "two")
simple_cache.put(3, "three")
puts simple_cache.display

simple_cache.get(1)
puts "After get(1): #{simple_cache.display}"

simple_cache.put(4, "four")
puts "After put(4): #{simple_cache.display}"

# ========================================
# 3. LRU WITH TIME-TO-LIVE (TTL)
# ========================================

puts "\n3. LRU Cache with TTL:"

class LRUCacheWithTTL
  def initialize(capacity, ttl)
    @capacity = capacity
    @ttl = ttl
    @cache = {}
  end

  def get(key)
    return -1 unless @cache.key?(key)

    entry = @cache[key]

    # Check if expired
    if Time.now - entry[:timestamp] > @ttl
      @cache.delete(key)
      return -1
    end

    # Move to end (most recently used) and update timestamp
    @cache.delete(key)
    @cache[key] = { value: entry[:value], timestamp: Time.now }
    entry[:value]
  end

  def put(key, value)
    @cache.delete(key) if @cache.key?(key)

    @cache[key] = { value: value, timestamp: Time.now }

    # Evict expired or least recently used
    clean_expired
    @cache.shift if @cache.size > @capacity
  end

  private

  def clean_expired
    @cache.delete_if do |_, entry|
      Time.now - entry[:timestamp] > @ttl
    end
  end
end

ttl_cache = LRUCacheWithTTL.new(3, 2)  # 2 seconds TTL
ttl_cache.put(1, "one")
ttl_cache.put(2, "two")
puts "TTL Cache get(1): #{ttl_cache.get(1)}"

# ========================================
# 4. LRU WITH STATISTICS
# ========================================

puts "\n4. LRU Cache with Statistics:"

class StatsLRUCache < LRUCache
  attr_reader :hits, :misses, :evictions

  def initialize(capacity)
    super
    @hits = 0
    @misses = 0
    @evictions = 0
  end

  def get(key)
    if @cache.key?(key)
      @hits += 1
    else
      @misses += 1
    end
    super
  end

  def put(key, value)
    will_evict = !@cache.key?(key) && @cache.size >= @capacity
    @evictions += 1 if will_evict
    super
  end

  def hit_rate
    total = @hits + @misses
    total == 0 ? 0.0 : (@hits.to_f / total * 100).round(2)
  end

  def stats
    {
      hits: @hits,
      misses: @misses,
      evictions: @evictions,
      hit_rate: "#{hit_rate}%",
      size: @cache.size,
      capacity: @capacity
    }
  end
end

stats_cache = StatsLRUCache.new(3)
stats_cache.put(1, "one")
stats_cache.put(2, "two")
stats_cache.put(3, "three")

stats_cache.get(1)  # Hit
stats_cache.get(2)  # Hit
stats_cache.get(4)  # Miss

stats_cache.put(4, "four")  # Eviction

puts "Cache stats: #{stats_cache.stats}"

# ========================================
# 5. LFU CACHE (Least Frequently Used)
# ========================================

puts "\n5. LFU Cache (for comparison):"

class LFUCache
  def initialize(capacity)
    @capacity = capacity
    @cache = {}  # key => {value, frequency}
    @frequencies = Hash.new { |h, k| h[k] = [] }  # frequency => [keys]
    @min_freq = 0
  end

  def get(key)
    return -1 unless @cache.key?(key)

    entry = @cache[key]
    update_frequency(key, entry[:frequency])

    entry[:value]
  end

  def put(key, value)
    return if @capacity == 0

    if @cache.key?(key)
      entry = @cache[key]
      entry[:value] = value
      update_frequency(key, entry[:frequency])
    else
      if @cache.size >= @capacity
        # Remove least frequently used
        evict_key = @frequencies[@min_freq].shift
        @cache.delete(evict_key)
      end

      @cache[key] = { value: value, frequency: 1 }
      @frequencies[1] << key
      @min_freq = 1
    end
  end

  private

  def update_frequency(key, old_freq)
    @frequencies[old_freq].delete(key)
    @min_freq += 1 if @min_freq == old_freq && @frequencies[old_freq].empty?

    new_freq = old_freq + 1
    @cache[key][:frequency] = new_freq
    @frequencies[new_freq] << key
  end
end

lfu = LFUCache.new(2)
lfu.put(1, "one")
lfu.put(2, "two")
puts "LFU get(1): #{lfu.get(1)}"  # Frequency: 1->2
puts "LFU put(3, 'three'): evicts 2 (less frequent)"
lfu.put(3, "three")
puts "LFU get(2): #{lfu.get(2)}"  # Should be -1 (evicted)
puts "LFU get(3): #{lfu.get(3)}"  # Should be 'three'

# ========================================
# 6. PRACTICAL APPLICATIONS
# ========================================

puts "\n6. Practical Applications:"

# Application 1: Web Page Cache
class WebPageCache
  def initialize(max_pages)
    @cache = LRUCache.new(max_pages)
  end

  def get_page(url)
    cached = @cache.get(url)
    if cached == -1
      puts "  Cache MISS: Fetching #{url}"
      content = fetch_from_server(url)
      @cache.put(url, content)
      content
    else
      puts "  Cache HIT: #{url}"
      cached
    end
  end

  private

  def fetch_from_server(url)
    # Simulate network request
    "Content of #{url}"
  end
end

web_cache = WebPageCache.new(3)
web_cache.get_page("example.com/home")
web_cache.get_page("example.com/about")
web_cache.get_page("example.com/home")  # Cache hit

# Application 2: Database Query Cache
class QueryCache
  def initialize(max_queries)
    @cache = StatsLRUCache.new(max_queries)
  end

  def execute_query(sql)
    result = @cache.get(sql)
    if result == -1
      puts "  Executing query: #{sql[0..30]}..."
      result = run_query(sql)
      @cache.put(sql, result)
    else
      puts "  Returning cached result"
    end
    result
  end

  def stats
    @cache.stats
  end

  private

  def run_query(sql)
    # Simulate database query
    "Result for: #{sql[0..20]}..."
  end
end

query_cache = QueryCache.new(5)
query_cache.execute_query("SELECT * FROM users WHERE id = 1")
query_cache.execute_query("SELECT * FROM products WHERE category = 'books'")
query_cache.execute_query("SELECT * FROM users WHERE id = 1")  # Cached
puts "Query cache stats: #{query_cache.stats}"

# ========================================
# TIME COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY ANALYSIS"
puts "=" * 50
puts "LRU Cache (Hash + Doubly Linked List):"
puts "  Get:                O(1)"
puts "  Put:                O(1)"
puts "  Space:              O(capacity)"
puts "\nSimple LRU (Ruby Hash):"
puts "  Get:                O(1)"
puts "  Put:                O(1) amortized"
puts "  Space:              O(capacity)"
puts "\nLFU Cache:"
puts "  Get:                O(1)"
puts "  Put:                O(1)"
puts "  Space:              O(capacity)"
puts "=" * 50

# ========================================
# PRACTICE PROBLEMS
# ========================================

puts "\nPRACTICE PROBLEMS:"
puts "1. Implement LRU Cache with size() method"
puts "2. LRU Cache that stores objects instead of primitives"
puts "3. Thread-safe LRU Cache"
puts "4. LRU Cache with different eviction strategies"
puts "5. Implement LFU (Least Frequently Used) Cache"
puts "6. LRU Cache with priority levels"
puts "7. Distributed LRU Cache"
puts "8. LRU Cache with write-through/write-back"
puts "9. Time-aware LRU Cache with TTL"
puts "10. Multi-level cache hierarchy"

# ========================================
# INTERVIEW TIPS
# ========================================

puts "\n" + "=" * 50
puts "LRU CACHE - INTERVIEW TIPS"
puts "=" * 50
puts "KEY INSIGHTS:"
puts "• Use HashMap for O(1) lookup"
puts "• Use Doubly Linked List for O(1) move/remove"
puts "• Head = Most Recently Used (MRU)"
puts "• Tail = Least Recently Used (LRU)"
puts "• Evict from tail when full"
puts "• Move to head on access"
puts "\nCOMMON FOLLOW-UPS:"
puts "• What if multi-threaded? (Add mutex/locks)"
puts "• What if distributed? (Consistent hashing)"
puts "• How to add TTL? (Store timestamps)"
puts "• LRU vs LFU? (Frequency vs recency)"
puts "\nEDGE CASES TO HANDLE:"
puts "• Capacity = 0 or 1"
puts "• Update existing key"
puts "• Get non-existent key"
puts "• Multiple gets of same key"
puts "=" * 50
