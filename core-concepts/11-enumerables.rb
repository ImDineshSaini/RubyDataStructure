# ========================================
# ENUMERABLES IN RUBY
# ========================================
# Enumerable is one of Ruby's most powerful modules
# Provides collection-related methods to any class that implements 'each'

puts "=" * 50
puts "ENUMERABLES IN RUBY"
puts "=" * 50

# ========================================
# 1. BASIC ENUMERABLE METHODS
# ========================================

puts "\n1. Basic Enumerable Methods:"

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# each - iterate over each element
puts "each:"
numbers.each { |n| print "#{n} " }
puts

# map/collect - transform each element
puts "\nmap (multiply by 2):"
doubled = numbers.map { |n| n * 2 }
puts doubled.inspect

# select/find_all - filter elements
puts "\nselect (even numbers):"
evens = numbers.select { |n| n.even? }
puts evens.inspect

# reject - opposite of select
puts "\nreject (odd numbers):"
not_odds = numbers.reject { |n| n.odd? }
puts not_odds.inspect

# reduce/inject - accumulate a value
puts "\nreduce (sum):"
sum = numbers.reduce(0) { |acc, n| acc + n }
puts sum

# Shorthand with symbols
sum2 = numbers.reduce(:+)
product = numbers.reduce(:*)
puts "Sum (shorthand): #{sum2}"
puts "Product: #{product}"

# ========================================
# 2. FINDING ELEMENTS
# ========================================

puts "\n2. Finding Elements:"

# find/detect - find first matching element
puts "find (first > 5):"
first_big = numbers.find { |n| n > 5 }
puts first_big

# find_all is alias for select

# find_index - index of first match
puts "\nfind_index (value 7):"
index = numbers.find_index(7)
puts index

# any? - true if any element matches
puts "\nany? (> 8):"
puts numbers.any? { |n| n > 8 }

# all? - true if all elements match
puts "\nall? (> 0):"
puts numbers.all? { |n| n > 0 }

# none? - true if no elements match
puts "\nnone? (> 10):"
puts numbers.none? { |n| n > 10 }

# one? - true if exactly one element matches
puts "\none? (== 5):"
puts numbers.one? { |n| n == 5 }

# include? - check if value exists
puts "\ninclude? (7):"
puts numbers.include?(7)

# ========================================
# 3. GROUPING AND PARTITIONING
# ========================================

puts "\n3. Grouping and Partitioning:"

# group_by - group elements by block result
words = %w[cat dog bird elephant bee butterfly tiger]
puts "group_by length:"
by_length = words.group_by(&:length)
puts by_length.inspect

# partition - split into two arrays
puts "\npartition (even/odd):"
evens, odds = numbers.partition(&:even?)
puts "Evens: #{evens}"
puts "Odds: #{odds}"

# chunk - chunk consecutive elements
puts "\nchunk (consecutive evens/odds):"
chunks = numbers.chunk(&:even?).to_a
puts chunks.inspect

# slice_before/slice_after
puts "\nslice_before (multiples of 3):"
slices = numbers.slice_before { |n| n % 3 == 0 }.to_a
puts slices.inspect

# ========================================
# 4. TRANSFORMATIONS
# ========================================

puts "\n4. Transformations:"

# flat_map/collect_concat - map and flatten
nested = [[1, 2], [3, 4], [5, 6]]
puts "flat_map:"
flattened = nested.flat_map { |arr| arr.map { |n| n * 2 } }
puts flattened.inspect

# zip - combine arrays
puts "\nzip:"
letters = ['a', 'b', 'c']
zipped = numbers.first(3).zip(letters)
puts zipped.inspect

# take/drop
puts "\ntake (first 3):"
puts numbers.take(3).inspect

puts "drop (first 3):"
puts numbers.drop(3).inspect

# take_while/drop_while
puts "\ntake_while (< 5):"
puts numbers.take_while { |n| n < 5 }.inspect

# uniq - remove duplicates
duplicates = [1, 2, 2, 3, 3, 3, 4]
puts "\nuniq:"
puts duplicates.uniq.inspect

# ========================================
# 5. SORTING
# ========================================

puts "\n5. Sorting:"

unsorted = [3, 1, 4, 1, 5, 9, 2, 6]

# sort - ascending order
puts "sort:"
puts unsorted.sort.inspect

# sort descending
puts "sort (descending):"
puts unsorted.sort { |a, b| b <=> a }.inspect

# sort_by - sort by block result
puts "\nsort_by length:"
words = %w[cat elephant dog bee]
puts words.sort_by(&:length).inspect

# min/max
puts "\nmin/max:"
puts "Min: #{numbers.min}"
puts "Max: #{numbers.max}"
puts "Min 3: #{numbers.min(3)}"
puts "Max 3: #{numbers.max(3)}"

# min_by/max_by
puts "\nmax_by length:"
puts words.max_by(&:length)

# ========================================
# 6. CHAINING METHODS
# ========================================

puts "\n6. Method Chaining:"

result = numbers
  .select { |n| n.even? }
  .map { |n| n * 2 }
  .reject { |n| n > 20 }
  .reduce(:+)

puts "Chained operations result: #{result}"

# More complex chain
result2 = words
  .select { |w| w.length > 3 }
  .map(&:upcase)
  .sort
  .join(', ')

puts "Complex chain: #{result2}"

# ========================================
# 7. WORKING WITH HASHES
# ========================================

puts "\n7. Working with Hashes:"

scores = { alice: 85, bob: 92, charlie: 78, david: 95 }

# each
puts "each:"
scores.each { |name, score| puts "  #{name}: #{score}" }

# map - returns array of [key, value] pairs or block results
puts "\nmap:"
formatted = scores.map { |name, score| "#{name.capitalize}: #{score}" }
puts formatted.inspect

# select
puts "\nselect (score >= 90):"
high_scores = scores.select { |_, score| score >= 90 }
puts high_scores.inspect

# transform_values
puts "\ntransform_values (+5 bonus):"
with_bonus = scores.transform_values { |score| score + 5 }
puts with_bonus.inspect

# transform_keys
puts "\ntransform_keys (uppercase):"
upper_keys = scores.transform_keys(&:upcase)
puts upper_keys.inspect

# ========================================
# 8. CUSTOM ENUMERABLE
# ========================================

puts "\n8. Custom Enumerable Class:"

class Fibonacci
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    a, b = 0, 1
    count = 0

    while count < @limit
      yield a
      a, b = b, a + b
      count += 1
    end
  end
end

fib = Fibonacci.new(10)
puts "Fibonacci numbers:"
puts fib.to_a.inspect

puts "\nFibonacci (even only):"
puts fib.select(&:even?).inspect

puts "\nFibonacci (sum):"
puts fib.reduce(:+)

# ========================================
# 9. EACH_WITH_INDEX AND VARIANTS
# ========================================

puts "\n9. each_with_index and Variants:"

fruits = ['apple', 'banana', 'cherry']

# each_with_index
puts "each_with_index:"
fruits.each_with_index do |fruit, idx|
  puts "  #{idx}: #{fruit}"
end

# each_with_object
puts "\neach_with_object (build hash):"
fruit_hash = fruits.each_with_object({}) do |fruit, hash|
  hash[fruit] = fruit.length
end
puts fruit_hash.inspect

# map.with_index
puts "\nmap.with_index:"
indexed = fruits.map.with_index { |fruit, idx| "#{idx+1}. #{fruit}" }
puts indexed.inspect

# ========================================
# 10. LAZY ENUMERABLES
# ========================================

puts "\n10. Lazy Enumerables:"

# Regular enumerable (evaluates immediately)
regular = (1..Float::INFINITY).select(&:even?).first(5)
# This would hang without 'first'!

# Lazy enumerable (evaluates on demand)
lazy = (1..Float::INFINITY).lazy.select(&:even?).first(5)
puts "Lazy evaluation (infinite range):"
puts lazy.inspect

# Practical lazy example
puts "\nLazy example (file processing):"
def process_large_file
  (1..1000).lazy
    .select { |n| n.even? }
    .map { |n| n * 2 }
    .take(5)
    .force  # Execute lazy chain
end

puts process_large_file.inspect

# ========================================
# 11. PRACTICAL EXAMPLES
# ========================================

puts "\n11. Practical Examples:"

# Example 1: Process log entries
logs = [
  { level: 'INFO', message: 'Server started' },
  { level: 'ERROR', message: 'Connection failed' },
  { level: 'INFO', message: 'Request processed' },
  { level: 'ERROR', message: 'Timeout' },
  { level: 'WARN', message: 'High memory usage' }
]

errors = logs
  .select { |log| log[:level] == 'ERROR' }
  .map { |log| log[:message] }

puts "Error messages:"
puts errors.inspect

# Example 2: Calculate statistics
prices = [10.99, 25.50, 15.75, 30.00, 8.99]

stats = {
  total: prices.reduce(:+),
  average: prices.reduce(:+) / prices.size,
  min: prices.min,
  max: prices.max,
  count: prices.count
}

puts "\nPrice statistics:"
puts stats.inspect

# Example 3: Data transformation pipeline
users = [
  { name: 'Alice', age: 30, active: true },
  { name: 'Bob', age: 25, active: false },
  { name: 'Charlie', age: 35, active: true },
  { name: 'David', age: 28, active: true }
]

active_adults = users
  .select { |u| u[:active] }
  .select { |u| u[:age] >= 30 }
  .map { |u| u[:name] }
  .sort

puts "\nActive users 30+:"
puts active_adults.inspect

# Example 4: Frequency counter
text = "the quick brown fox jumps over the lazy dog"
word_freq = text.split
  .each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }

puts "\nWord frequency:"
puts word_freq.inspect

# Example 5: Group and aggregate
transactions = [
  { category: 'Food', amount: 50 },
  { category: 'Transport', amount: 30 },
  { category: 'Food', amount: 40 },
  { category: 'Entertainment', amount: 60 },
  { category: 'Food', amount: 35 }
]

category_totals = transactions
  .group_by { |t| t[:category] }
  .transform_values { |ts| ts.map { |t| t[:amount] }.reduce(:+) }

puts "\nCategory totals:"
puts category_totals.inspect

# ========================================
# 12. PERFORMANCE TIPS
# ========================================

puts "\n12. Performance Tips:"

large_array = (1..1000).to_a

# Bad: Creates intermediate arrays
result1 = large_array.map { |n| n * 2 }.select { |n| n > 100 }.first(10)

# Better: Use lazy to avoid intermediate arrays
result2 = large_array.lazy.map { |n| n * 2 }.select { |n| n > 100 }.first(10)

puts "Results are same: #{result1 == result2.force}"

# Use symbol to proc when possible
names = ['alice', 'bob', 'charlie']
puts "\nSymbol to proc:"
puts names.map(&:upcase).inspect  # Faster than { |n| n.upcase }

# ========================================
# SUMMARY
# ========================================

puts "\n" + "=" * 50
puts "ENUMERABLES - SUMMARY"
puts "=" * 50
puts "CORE METHODS:"
puts "• each - Iterate over elements"
puts "• map - Transform elements"
puts "• select/reject - Filter elements"
puts "• reduce - Accumulate a value"
puts "• find - Find first match"
puts "• any?/all?/none? - Boolean queries"
puts "\nGROUPING:"
puts "• group_by - Group by block result"
puts "• partition - Split into two groups"
puts "• chunk - Group consecutive elements"
puts "\nSORTING:"
puts "• sort/sort_by - Sort elements"
puts "• min/max - Find extremes"
puts "\nCHAINING:"
puts "• Methods return enumerables"
puts "• Can chain multiple operations"
puts "• Use lazy for infinite/large collections"
puts "\nBEST PRACTICES:"
puts "✓ Use symbol to proc (&:method)"
puts "✓ Chain methods for clarity"
puts "✓ Use lazy for large/infinite collections"
puts "✓ Prefer enumerable methods over loops"
puts "✓ Use reduce for complex accumulations"
puts "\nCOMMON PATTERNS:"
puts "• map + select/reject = data transformation"
puts "• group_by + transform_values = aggregation"
puts "• reduce = sum, product, accumulation"
puts "• zip = parallel iteration"
puts "=" * 50
