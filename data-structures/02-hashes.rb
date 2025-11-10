# ========================================
# HASHES IN RUBY
# ========================================
# Hashes are dictionaries with key-value pairs.
# Keys must be unique. Fast lookup, insertion, and deletion.

puts "=" * 50
puts "HASHES IN RUBY"
puts "=" * 50

# ========================================
# 1. HASH CREATION
# ========================================

# Different ways to create hashes
hash1 = { 'name' => 'John', 'age' => 30 }
hash2 = { name: 'Jane', age: 25 }  # Symbol keys
hash3 = Hash.new                    # Empty hash
hash4 = Hash.new(0)                 # Default value 0
hash5 = Hash.new { |h, k| h[k] = [] }  # Default value as array

puts "\n1. Hash Creation:"
puts "hash1 = #{hash1}"
puts "hash2 = #{hash2}"
puts "hash3 = #{hash3}"
puts "hash4['missing'] = #{hash4['missing']}"  # 0
puts "hash5['key'] << 'value' => #{hash5['key'] << 'value'}"

# ========================================
# 2. ACCESSING ELEMENTS
# ========================================

person = { name: 'Alice', age: 30, city: 'NYC' }

puts "\n2. Accessing Elements:"
puts "person = #{person}"
puts "person[:name] = #{person[:name]}"
puts "person.fetch(:age) = #{person.fetch(:age)}"
puts "person.fetch(:country, 'USA') = #{person.fetch(:country, 'USA')}"
puts "person.dig(:address, :street) = #{person.dig(:address, :street)}"  # nil
puts "person.values_at(:name, :city) = #{person.values_at(:name, :city)}"

# ========================================
# 3. ADDING AND UPDATING
# ========================================

person = { name: 'Bob' }

puts "\n3. Adding and Updating:"
puts "Original: #{person}"

person[:age] = 25              # Add new key
puts "After adding :age => #{person}"

person[:age] = 26              # Update existing
puts "After updating :age => #{person}"

person.merge!(city: 'LA', country: 'USA')  # Merge multiple
puts "After merge! => #{person}"

person.store(:job, 'Developer')  # Store method
puts "After store(:job) => #{person}"

# ========================================
# 4. REMOVING ELEMENTS
# ========================================

person = { name: 'Charlie', age: 30, city: 'SF', job: 'Engineer' }

puts "\n4. Removing Elements:"
puts "Original: #{person}"

removed = person.delete(:age)
puts "After delete(:age): #{person}, removed: #{removed}"

key, value = person.shift  # Remove first pair
puts "After shift: #{person}, removed: (#{key}, #{value})"

person.delete_if { |k, v| v == 'SF' }
puts "After delete_if: #{person}"

person.clear
puts "After clear: #{person}"

# ========================================
# 5. QUERYING
# ========================================

person = { name: 'David', age: 28, city: 'Boston' }

puts "\n5. Querying:"
puts "person = #{person}"
puts "person.key?(:name) = #{person.key?(:name)}"
puts "person.value?('David') = #{person.value?('David')}"
puts "person.empty? = #{person.empty?}"
puts "person.size = #{person.size}"
puts "person.keys = #{person.keys}"
puts "person.values = #{person.values}"

# ========================================
# 6. ITERATION
# ========================================

grades = { math: 90, science: 85, english: 88 }

puts "\n6. Iteration:"
puts "grades = #{grades}"

print "each: "
grades.each { |subject, score| print "(#{subject}: #{score}) " }
puts

print "each_key: "
grades.each_key { |subject| print "#{subject} " }
puts

print "each_value: "
grades.each_value { |score| print "#{score} " }
puts

# ========================================
# 7. TRANSFORMATION
# ========================================

prices = { apple: 1.0, banana: 0.5, orange: 0.75 }

puts "\n7. Transformation:"
puts "prices = #{prices}"

# Map/transform
expensive = prices.transform_values { |v| v * 2 }
puts "Double prices: #{expensive}"

# Select/filter
cheap = prices.select { |k, v| v < 1.0 }
puts "Cheap items: #{cheap}"

# Reject
not_apple = prices.reject { |k, v| k == :apple }
puts "Not apple: #{not_apple}"

# Invert
inverted = prices.invert
puts "Inverted: #{inverted}"

# ========================================
# 8. NESTED HASHES
# ========================================

users = {
  1 => { name: 'Alice', email: 'alice@example.com' },
  2 => { name: 'Bob', email: 'bob@example.com' }
}

puts "\n8. Nested Hashes:"
puts "users = #{users}"
puts "User 1 name: #{users[1][:name]}"
puts "User 2 email: #{users.dig(2, :email)}"

# Deep merge
user1_update = { 1 => { phone: '123-456' } }
users.merge!(user1_update) { |key, old, new| old.merge(new) }
puts "After deep merge: #{users}"

# ========================================
# 9. HASH METHODS
# ========================================

h1 = { a: 1, b: 2 }
h2 = { b: 3, c: 4 }

puts "\n9. Hash Methods:"
puts "h1 = #{h1}"
puts "h2 = #{h2}"
puts "h1.merge(h2) = #{h1.merge(h2)}"  # { a: 1, b: 3, c: 4 }

# Custom merge
merged = h1.merge(h2) { |key, old, new| old + new }
puts "Custom merge (sum): #{merged}"  # { a: 1, b: 5, c: 4 }

# Slice
full_hash = { a: 1, b: 2, c: 3, d: 4 }
puts "full_hash.slice(:a, :c) = #{full_hash.slice(:a, :c)}"

# Except
puts "full_hash.except(:b, :d) = #{full_hash.except(:b, :d)}"

# ========================================
# 10. PRACTICAL EXAMPLES
# ========================================

puts "\n10. Practical Examples:"

# Example 1: Count character frequency
def char_frequency(str)
  str.chars.each_with_object(Hash.new(0)) do |char, hash|
    hash[char] += 1
  end
end

puts "Frequency of 'hello': #{char_frequency('hello')}"

# Example 2: Group by property
def group_by_length(words)
  words.group_by(&:length)
end

words = %w[cat dog elephant bee butterfly]
puts "Group by length: #{group_by_length(words)}"

# Example 3: Two arrays to hash
def arrays_to_hash(keys, values)
  keys.zip(values).to_h
end

keys = [:name, :age, :city]
values = ['Eve', 30, 'Seattle']
puts "Arrays to hash: #{arrays_to_hash(keys, values)}"

# Example 4: Find first duplicate
def first_duplicate(arr)
  seen = {}
  arr.each do |item|
    return item if seen[item]
    seen[item] = true
  end
  nil
end

puts "First duplicate in [1,2,3,2,4,3]: #{first_duplicate([1, 2, 3, 2, 4, 3])}"

# Example 5: Anagram grouping
def group_anagrams(words)
  words.group_by { |word| word.chars.sort.join }
end

words = %w[eat tea tan ate nat bat]
puts "Anagram groups: #{group_anagrams(words)}"

# Example 6: LRU Cache using Hash
class LRUCache
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
    @cache.delete(key) if @cache.key?(key)
    @cache[key] = value

    # Remove least recently used
    @cache.shift if @cache.size > @capacity
  end

  def to_s
    @cache.to_s
  end
end

cache = LRUCache.new(2)
cache.put(1, 'one')
cache.put(2, 'two')
puts "\nLRU Cache after adding 1 and 2: #{cache}"
cache.get(1)  # Access 1
cache.put(3, 'three')  # Evicts key 2
puts "After accessing 1 and adding 3: #{cache}"

# Example 7: Validate parentheses using hash
def valid_parentheses?(str)
  stack = []
  pairs = { '(' => ')', '[' => ']', '{' => '}' }

  str.each_char do |char|
    if pairs.key?(char)
      stack.push(char)
    elsif pairs.value?(char)
      return false if stack.empty? || pairs[stack.pop] != char
    end
  end

  stack.empty?
end

puts "Valid '({[]})': #{valid_parentheses?('({[]})')}"
puts "Valid '([)]': #{valid_parentheses?('([)]')}"

# Example 8: Subarray sum equals K
def subarray_sum(nums, k)
  count = 0
  sum = 0
  sums = Hash.new(0)
  sums[0] = 1

  nums.each do |num|
    sum += num
    count += sums[sum - k]
    sums[sum] += 1
  end

  count
end

puts "Subarrays with sum 7 in [1,2,3,4]: #{subarray_sum([1, 2, 3, 4], 7)}"

# Example 9: Convert nested hash to flat hash
def flatten_hash(hash, prefix = '')
  hash.each_with_object({}) do |(key, value), result|
    new_key = prefix.empty? ? key.to_s : "#{prefix}.#{key}"
    if value.is_a?(Hash)
      result.merge!(flatten_hash(value, new_key))
    else
      result[new_key] = value
    end
  end
end

nested = { user: { name: 'John', address: { city: 'NYC', zip: '10001' } } }
puts "Flattened hash: #{flatten_hash(nested)}"

# ========================================
# TIME COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY ANALYSIS"
puts "=" * 50
puts "Access by key:        O(1) average, O(n) worst"
puts "Insert:               O(1) average, O(n) worst"
puts "Delete:               O(1) average, O(n) worst"
puts "Search by value:      O(n)"
puts "Iteration:            O(n)"
puts "Space complexity:     O(n)"
puts "=" * 50

# ========================================
# PRACTICE PROBLEMS
# ========================================

puts "\nPRACTICE PROBLEMS:"
puts "1. Implement a method to find the first non-repeating character"
puts "2. Check if two strings are anagrams using hashes"
puts "3. Find the most frequent element in an array"
puts "4. Group contacts by first letter of name"
puts "5. Implement a simple phone book with hash"
puts "6. Find all pairs in array that sum to target (using hash)"
puts "7. Implement a custom hash with collision handling"
puts "8. Merge multiple hashes with conflict resolution"
puts "9. Find intersection of multiple arrays using hash"
puts "10. Implement a word frequency counter for text"
