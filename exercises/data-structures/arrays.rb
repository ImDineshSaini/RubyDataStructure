# ========================================
# ARRAY PRACTICE PROBLEMS
# ========================================

puts "=" * 50
puts "ARRAY PRACTICE PROBLEMS"
puts "=" * 50

# ========================================
# PROBLEM 1: TWO SUM
# ========================================
# Given an array and target, return indices of two numbers that add up to target

puts "\nProblem 1: Two Sum"
puts "Given: [2, 7, 11, 15], target = 9"
puts "Output: [0, 1] (because 2 + 7 = 9)"

# Solution 1: Brute Force O(n²)
def two_sum_brute(nums, target)
  nums.each_with_index do |num1, i|
    nums.each_with_index do |num2, j|
      return [i, j] if i != j && num1 + num2 == target
    end
  end
  nil
end

# Solution 2: Using Hash O(n)
def two_sum(nums, target)
  hash = {}
  nums.each_with_index do |num, i|
    complement = target - num
    return [hash[complement], i] if hash.key?(complement)
    hash[num] = i
  end
  nil
end

result = two_sum([2, 7, 11, 15], 9)
puts "Solution: #{result}"

# ========================================
# PROBLEM 2: MAXIMUM SUBARRAY (KADANE'S ALGORITHM)
# ========================================
# Find the contiguous subarray with the largest sum

puts "\nProblem 2: Maximum Subarray Sum"
puts "Given: [-2, 1, -3, 4, -1, 2, 1, -5, 4]"
puts "Output: 6 (subarray [4, -1, 2, 1])"

def max_subarray(nums)
  return nums[0] if nums.length == 1

  max_sum = nums[0]
  current_sum = nums[0]

  nums[1..-1].each do |num|
    current_sum = [num, current_sum + num].max
    max_sum = [max_sum, current_sum].max
  end

  max_sum
end

result = max_subarray([-2, 1, -3, 4, -1, 2, 1, -5, 4])
puts "Solution: #{result}"

# ========================================
# PROBLEM 3: ROTATE ARRAY
# ========================================
# Rotate array to right by k steps

puts "\nProblem 3: Rotate Array"
puts "Given: [1, 2, 3, 4, 5], k = 2"
puts "Output: [4, 5, 1, 2, 3]"

def rotate_array(nums, k)
  k = k % nums.length
  return nums if k == 0

  nums[-k..-1] + nums[0...-k]
end

# In-place solution
def rotate_array_in_place(nums, k)
  k = k % nums.length
  return if k == 0

  # Reverse entire array
  nums.reverse!
  # Reverse first k elements
  nums[0...k] = nums[0...k].reverse
  # Reverse remaining elements
  nums[k..-1] = nums[k..-1].reverse
end

result = rotate_array([1, 2, 3, 4, 5], 2)
puts "Solution: #{result}"

# ========================================
# PROBLEM 4: CONTAINS DUPLICATE
# ========================================
# Check if array contains duplicates

puts "\nProblem 4: Contains Duplicate"
puts "Given: [1, 2, 3, 1]"
puts "Output: true"

# Solution 1: Using Set O(n)
def contains_duplicate(nums)
  nums.uniq.length != nums.length
end

# Solution 2: Using Hash
def contains_duplicate_hash(nums)
  seen = {}
  nums.each do |num|
    return true if seen[num]
    seen[num] = true
  end
  false
end

result = contains_duplicate([1, 2, 3, 1])
puts "Solution: #{result}"

# ========================================
# PROBLEM 5: PRODUCT OF ARRAY EXCEPT SELF
# ========================================
# Return array where output[i] is product of all elements except nums[i]
# Without using division

puts "\nProblem 5: Product of Array Except Self"
puts "Given: [1, 2, 3, 4]"
puts "Output: [24, 12, 8, 6]"

def product_except_self(nums)
  n = nums.length
  result = Array.new(n, 1)

  # Left pass
  left_product = 1
  (0...n).each do |i|
    result[i] = left_product
    left_product *= nums[i]
  end

  # Right pass
  right_product = 1
  (n - 1).downto(0).each do |i|
    result[i] *= right_product
    right_product *= nums[i]
  end

  result
end

result = product_except_self([1, 2, 3, 4])
puts "Solution: #{result}"

# ========================================
# PROBLEM 6: MAXIMUM PRODUCT SUBARRAY
# ========================================
# Find the contiguous subarray with the largest product

puts "\nProblem 6: Maximum Product Subarray"
puts "Given: [2, 3, -2, 4]"
puts "Output: 6 (subarray [2, 3])"

def max_product(nums)
  return nums[0] if nums.length == 1

  max_prod = nums[0]
  current_max = nums[0]
  current_min = nums[0]

  nums[1..-1].each do |num|
    temp_max = current_max
    current_max = [num, num * current_max, num * current_min].max
    current_min = [num, num * temp_max, num * current_min].min
    max_prod = [max_prod, current_max].max
  end

  max_prod
end

result = max_product([2, 3, -2, 4])
puts "Solution: #{result}"

# ========================================
# PROBLEM 7: FIND MINIMUM IN ROTATED SORTED ARRAY
# ========================================

puts "\nProblem 7: Find Minimum in Rotated Sorted Array"
puts "Given: [3, 4, 5, 1, 2]"
puts "Output: 1"

def find_min(nums)
  left = 0
  right = nums.length - 1

  while left < right
    mid = (left + right) / 2

    if nums[mid] > nums[right]
      left = mid + 1
    else
      right = mid
    end
  end

  nums[left]
end

result = find_min([3, 4, 5, 1, 2])
puts "Solution: #{result}"

# ========================================
# PROBLEM 8: SEARCH IN ROTATED SORTED ARRAY
# ========================================

puts "\nProblem 8: Search in Rotated Sorted Array"
puts "Given: [4, 5, 6, 7, 0, 1, 2], target = 0"
puts "Output: 4"

def search_rotated(nums, target)
  left = 0
  right = nums.length - 1

  while left <= right
    mid = (left + right) / 2

    return mid if nums[mid] == target

    # Check which half is sorted
    if nums[left] <= nums[mid]
      # Left half is sorted
      if nums[left] <= target && target < nums[mid]
        right = mid - 1
      else
        left = mid + 1
      end
    else
      # Right half is sorted
      if nums[mid] < target && target <= nums[right]
        left = mid + 1
      else
        right = mid - 1
      end
    end
  end

  -1
end

result = search_rotated([4, 5, 6, 7, 0, 1, 2], 0)
puts "Solution: #{result}"

# ========================================
# PROBLEM 9: THREE SUM
# ========================================
# Find all unique triplets that sum to zero

puts "\nProblem 9: Three Sum"
puts "Given: [-1, 0, 1, 2, -1, -4]"
puts "Output: [[-1, -1, 2], [-1, 0, 1]]"

def three_sum(nums)
  result = []
  nums.sort!

  nums.each_with_index do |num, i|
    next if i > 0 && nums[i] == nums[i - 1]  # Skip duplicates

    left = i + 1
    right = nums.length - 1

    while left < right
      sum = num + nums[left] + nums[right]

      if sum == 0
        result << [num, nums[left], nums[right]]

        # Skip duplicates
        left += 1 while left < right && nums[left] == nums[left - 1]
        right -= 1 while left < right && nums[right] == nums[right + 1]

        left += 1
        right -= 1
      elsif sum < 0
        left += 1
      else
        right -= 1
      end
    end
  end

  result
end

result = three_sum([-1, 0, 1, 2, -1, -4])
puts "Solution: #{result}"

# ========================================
# PROBLEM 10: CONTAINER WITH MOST WATER
# ========================================

puts "\nProblem 10: Container With Most Water"
puts "Given: [1, 8, 6, 2, 5, 4, 8, 3, 7]"
puts "Output: 49 (between indices 1 and 8)"

def max_area(height)
  max_water = 0
  left = 0
  right = height.length - 1

  while left < right
    width = right - left
    h = [height[left], height[right]].min
    water = width * h
    max_water = [max_water, water].max

    if height[left] < height[right]
      left += 1
    else
      right -= 1
    end
  end

  max_water
end

result = max_area([1, 8, 6, 2, 5, 4, 8, 3, 7])
puts "Solution: #{result}"

# ========================================
# COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY SUMMARY"
puts "=" * 50
puts "Two Sum:                  O(n) time, O(n) space"
puts "Max Subarray:             O(n) time, O(1) space"
puts "Rotate Array:             O(n) time, O(1) space"
puts "Contains Duplicate:       O(n) time, O(n) space"
puts "Product Except Self:      O(n) time, O(n) space"
puts "Max Product:              O(n) time, O(1) space"
puts "Find Min Rotated:         O(log n) time, O(1) space"
puts "Search Rotated:           O(log n) time, O(1) space"
puts "Three Sum:                O(n²) time, O(1) space"
puts "Container Most Water:     O(n) time, O(1) space"
puts "=" * 50

# ========================================
# ADDITIONAL PRACTICE PROBLEMS
# ========================================

puts "\nADDITIONAL PRACTICE:"
puts "1. Missing Number - Find missing number from 0 to n"
puts "2. Move Zeroes - Move all zeros to end"
puts "3. Best Time to Buy/Sell Stock"
puts "4. Intersection of Two Arrays"
puts "5. Merge Intervals"
puts "6. Insert Interval"
puts "7. Spiral Matrix"
puts "8. Set Matrix Zeroes"
puts "9. Longest Consecutive Sequence"
puts "10. First Missing Positive"
