# ========================================
# ARRAYS IN RUBY
# ========================================
# Arrays are ordered, integer-indexed collections of any object.
# They are dynamic and can grow/shrink automatically.

puts "=" * 50
puts "ARRAYS IN RUBY"
puts "=" * 50

# ========================================
# 1. ARRAY CREATION
# ========================================

# Different ways to create arrays
arr1 = [1, 2, 3, 4, 5]
arr2 = Array.new(5)           # [nil, nil, nil, nil, nil]
arr3 = Array.new(5, 0)        # [0, 0, 0, 0, 0]
arr4 = Array.new(5) { |i| i * 2 }  # [0, 2, 4, 6, 8]
arr5 = %w[apple banana cherry]     # ["apple", "banana", "cherry"]
arr6 = (1..10).to_a           # [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

puts "\n1. Array Creation:"
puts "arr1 = #{arr1}"
puts "arr2 = #{arr2}"
puts "arr3 = #{arr3}"
puts "arr4 = #{arr4}"
puts "arr5 = #{arr5}"
puts "arr6 = #{arr6}"

# ========================================
# 2. ACCESSING ELEMENTS
# ========================================

arr = [10, 20, 30, 40, 50]

puts "\n2. Accessing Elements:"
puts "arr = #{arr}"
puts "arr[0] = #{arr[0]}"           # First element: 10
puts "arr[-1] = #{arr[-1]}"         # Last element: 50
puts "arr[1..3] = #{arr[1..3]}"     # Range: [20, 30, 40]
puts "arr[1...3] = #{arr[1...3]}"   # Exclusive range: [20, 30]
puts "arr.first = #{arr.first}"     # 10
puts "arr.last = #{arr.last}"       # 50
puts "arr.at(2) = #{arr.at(2)}"     # 30
puts "arr.fetch(10, 'default') = #{arr.fetch(10, 'default')}"  # 'default'

# ========================================
# 3. ADDING ELEMENTS
# ========================================

arr = [1, 2, 3]

puts "\n3. Adding Elements:"
arr.push(4)              # Add to end: [1, 2, 3, 4]
puts "After push(4): #{arr}"

arr << 5                 # Append operator: [1, 2, 3, 4, 5]
puts "After << 5: #{arr}"

arr.unshift(0)           # Add to beginning: [0, 1, 2, 3, 4, 5]
puts "After unshift(0): #{arr}"

arr.insert(3, 99)        # Insert at index: [0, 1, 2, 99, 3, 4, 5]
puts "After insert(3, 99): #{arr}"

arr.concat([6, 7])       # Concatenate: [0, 1, 2, 99, 3, 4, 5, 6, 7]
puts "After concat([6, 7]): #{arr}"

# ========================================
# 4. REMOVING ELEMENTS
# ========================================

arr = [1, 2, 3, 4, 5, 3]

puts "\n4. Removing Elements:"
puts "Original: #{arr}"

removed = arr.pop        # Remove last: 3
puts "After pop: #{arr}, removed: #{removed}"

removed = arr.shift      # Remove first: 1
puts "After shift: #{arr}, removed: #{removed}"

removed = arr.delete(3)  # Delete all occurrences: 3
puts "After delete(3): #{arr}, removed: #{removed}"

removed = arr.delete_at(1) # Delete at index: 3
puts "After delete_at(1): #{arr}, removed: #{removed}"

arr = [1, 2, 3, 4, 5]
arr.delete_if { |x| x > 3 }  # Conditional delete
puts "After delete_if {|x| x > 3}: #{arr}"

# ========================================
# 5. SEARCHING AND FILTERING
# ========================================

arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

puts "\n5. Searching and Filtering:"
puts "arr = #{arr}"
puts "arr.include?(5) = #{arr.include?(5)}"           # true
puts "arr.index(5) = #{arr.index(5)}"                 # 4
puts "arr.find { |x| x > 5 } = #{arr.find { |x| x > 5 }}"     # 6
puts "arr.find_all { |x| x > 5 } = #{arr.find_all { |x| x > 5 }}"  # [6, 7, 8, 9, 10]
puts "arr.select { |x| x.even? } = #{arr.select { |x| x.even? }}"  # [2, 4, 6, 8, 10]
puts "arr.reject { |x| x.even? } = #{arr.reject { |x| x.even? }}"  # [1, 3, 5, 7, 9]

# ========================================
# 6. TRANSFORMATION
# ========================================

arr = [1, 2, 3, 4, 5]

puts "\n6. Transformation:"
puts "arr = #{arr}"
puts "arr.map { |x| x * 2 } = #{arr.map { |x| x * 2 }}"        # [2, 4, 6, 8, 10]
puts "arr.reverse = #{arr.reverse}"                             # [5, 4, 3, 2, 1]
puts "arr.sort = #{[3, 1, 4, 1, 5].sort}"                      # [1, 1, 3, 4, 5]
puts "arr.uniq = #{[1, 2, 2, 3, 3, 3].uniq}"                   # [1, 2, 3]
puts "arr.compact = #{[1, nil, 2, nil, 3].compact}"            # [1, 2, 3]
puts "arr.flatten = #{[1, [2, 3], [4, [5]]].flatten}"          # [1, 2, 3, 4, 5]

# ========================================
# 7. AGGREGATION
# ========================================

arr = [1, 2, 3, 4, 5]

puts "\n7. Aggregation:"
puts "arr = #{arr}"
puts "arr.sum = #{arr.sum}"                                    # 15
puts "arr.max = #{arr.max}"                                    # 5
puts "arr.min = #{arr.min}"                                    # 1
puts "arr.reduce(:+) = #{arr.reduce(:+)}"                      # 15
puts "arr.reduce(1, :*) = #{arr.reduce(1, :*)}"                # 120 (factorial)
puts "arr.count = #{arr.count}"                                # 5
puts "arr.count { |x| x > 3 } = #{arr.count { |x| x > 3 }}"   # 2

# ========================================
# 8. ITERATION
# ========================================

arr = ['a', 'b', 'c']

puts "\n8. Iteration:"
puts "arr = #{arr}"

print "each: "
arr.each { |item| print "#{item} " }
puts

print "each_with_index: "
arr.each_with_index { |item, idx| print "(#{idx}:#{item}) " }
puts

print "each_with_object: "
result = arr.each_with_object({}) { |item, hash| hash[item] = item.upcase }
puts result.inspect

# ========================================
# 9. ARRAY OPERATIONS
# ========================================

arr1 = [1, 2, 3]
arr2 = [3, 4, 5]

puts "\n9. Array Operations:"
puts "arr1 = #{arr1}"
puts "arr2 = #{arr2}"
puts "arr1 + arr2 = #{arr1 + arr2}"           # Concatenation: [1, 2, 3, 3, 4, 5]
puts "arr1 - arr2 = #{arr1 - arr2}"           # Difference: [1, 2]
puts "arr1 & arr2 = #{arr1 & arr2}"           # Intersection: [3]
puts "arr1 | arr2 = #{arr1 | arr2}"           # Union: [1, 2, 3, 4, 5]

# ========================================
# 10. PRACTICAL EXAMPLES
# ========================================

puts "\n10. Practical Examples:"

# Example 1: Finding duplicates
def find_duplicates(arr)
  arr.select { |e| arr.count(e) > 1 }.uniq
end

puts "Duplicates in [1,2,3,2,4,3]: #{find_duplicates([1, 2, 3, 2, 4, 3])}"

# Example 2: Two sum problem
def two_sum(arr, target)
  hash = {}
  arr.each_with_index do |num, i|
    complement = target - num
    return [hash[complement], i] if hash.key?(complement)
    hash[num] = i
  end
  nil
end

puts "Two sum indices for [2,7,11,15], target 9: #{two_sum([2, 7, 11, 15], 9)}"

# Example 3: Rotate array
def rotate_array(arr, k)
  k = k % arr.length
  arr[-k..-1] + arr[0...-k]
end

puts "Rotate [1,2,3,4,5] by 2: #{rotate_array([1, 2, 3, 4, 5], 2)}"

# Example 4: Find maximum subarray sum (Kadane's algorithm)
def max_subarray_sum(arr)
  max_sum = arr[0]
  current_sum = arr[0]

  arr[1..-1].each do |num|
    current_sum = [num, current_sum + num].max
    max_sum = [max_sum, current_sum].max
  end

  max_sum
end

puts "Max subarray sum of [-2,1,-3,4,-1,2,1,-5,4]: #{max_subarray_sum([-2, 1, -3, 4, -1, 2, 1, -5, 4])}"

# Example 5: Chunk array
def chunk_array(arr, size)
  arr.each_slice(size).to_a
end

puts "Chunk [1,2,3,4,5,6,7] by 3: #{chunk_array([1, 2, 3, 4, 5, 6, 7], 3)}"

# ========================================
# TIME COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY ANALYSIS"
puts "=" * 50
puts "Access by index:      O(1)"
puts "Search:               O(n)"
puts "Insert at end:        O(1) amortized"
puts "Insert at beginning:  O(n)"
puts "Delete at end:        O(1)"
puts "Delete at beginning:  O(n)"
puts "Delete by value:      O(n)"
puts "Space complexity:     O(n)"
puts "=" * 50

# ========================================
# PRACTICE PROBLEMS
# ========================================

puts "\nPRACTICE PROBLEMS:"
puts "1. Implement a method to remove duplicates from an unsorted array"
puts "2. Find the missing number in an array containing n distinct numbers from 0 to n"
puts "3. Move all zeros to the end while maintaining relative order"
puts "4. Find the intersection of two arrays"
puts "5. Implement merge sort on an array"
puts "6. Find all pairs in an array that sum to a target value"
puts "7. Implement a circular buffer using an array"
puts "8. Find the kth largest element in an array"
puts "9. Rearrange array such that arr[i] = i"
puts "10. Find the longest consecutive sequence in an unsorted array"
