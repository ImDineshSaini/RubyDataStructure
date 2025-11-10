# ========================================
# GRAPHS IN RUBY
# ========================================
# A graph is a non-linear data structure consisting of vertices (nodes)
# and edges that connect them.

puts "=" * 50
puts "GRAPHS IN RUBY"
puts "=" * 50

# ========================================
# 1. ADJACENCY LIST REPRESENTATION
# ========================================

class Graph
  def initialize(directed = false)
    @adjacency_list = Hash.new { |h, k| h[k] = [] }
    @directed = directed
  end

  def add_vertex(vertex)
    @adjacency_list[vertex] ||= []
  end

  def add_edge(vertex1, vertex2, weight = nil)
    @adjacency_list[vertex1] << (weight ? { vertex: vertex2, weight: weight } : vertex2)
    @adjacency_list[vertex2] << (weight ? { vertex: vertex1, weight: weight } : vertex1) unless @directed
  end

  def vertices
    @adjacency_list.keys
  end

  def edges
    all_edges = []
    @adjacency_list.each do |vertex, neighbors|
      neighbors.each do |neighbor|
        edge = [vertex, neighbor.is_a?(Hash) ? neighbor[:vertex] : neighbor]
        all_edges << edge unless @directed && all_edges.include?(edge.reverse)
      end
    end
    all_edges
  end

  def neighbors(vertex)
    @adjacency_list[vertex]
  end

  def display
    puts "\nGraph (#{@directed ? 'Directed' : 'Undirected'}):"
    @adjacency_list.each do |vertex, neighbors|
      neighbors_str = neighbors.map do |n|
        n.is_a?(Hash) ? "#{n[:vertex]}(#{n[:weight]})" : n.to_s
      end.join(', ')
      puts "  #{vertex} -> [#{neighbors_str}]"
    end
  end
end

puts "\n1. Adjacency List Representation:"

graph = Graph.new
['A', 'B', 'C', 'D'].each { |v| graph.add_vertex(v) }
graph.add_edge('A', 'B')
graph.add_edge('A', 'C')
graph.add_edge('B', 'D')
graph.add_edge('C', 'D')
graph.display

# ========================================
# 2. WEIGHTED GRAPH
# ========================================

puts "\n2. Weighted Graph:"

weighted_graph = Graph.new
['A', 'B', 'C', 'D'].each { |v| weighted_graph.add_vertex(v) }
weighted_graph.add_edge('A', 'B', 4)
weighted_graph.add_edge('A', 'C', 2)
weighted_graph.add_edge('B', 'D', 5)
weighted_graph.add_edge('C', 'D', 3)
weighted_graph.display

# ========================================
# 3. DEPTH-FIRST SEARCH (DFS)
# ========================================

class Graph
  def dfs(start, visited = Set.new, &block)
    return if visited.include?(start)

    visited.add(start)
    block.call(start) if block_given?

    neighbors(start).each do |neighbor|
      vertex = neighbor.is_a?(Hash) ? neighbor[:vertex] : neighbor
      dfs(vertex, visited, &block)
    end

    visited
  end

  def dfs_iterative(start)
    visited = Set.new
    stack = [start]
    result = []

    while !stack.empty?
      vertex = stack.pop
      next if visited.include?(vertex)

      visited.add(vertex)
      result << vertex

      neighbors(vertex).reverse_each do |neighbor|
        v = neighbor.is_a?(Hash) ? neighbor[:vertex] : neighbor
        stack.push(v) unless visited.include?(v)
      end
    end

    result
  end
end

puts "\n3. Depth-First Search:"

puts "DFS Recursive:"
graph.dfs('A') { |v| print "#{v} " }
puts

puts "DFS Iterative:"
puts graph.dfs_iterative('A').join(' ')

# ========================================
# 4. BREADTH-FIRST SEARCH (BFS)
# ========================================

class Graph
  def bfs(start)
    visited = Set.new
    queue = [start]
    result = []

    while !queue.empty?
      vertex = queue.shift
      next if visited.include?(vertex)

      visited.add(vertex)
      result << vertex

      neighbors(vertex).each do |neighbor|
        v = neighbor.is_a?(Hash) ? neighbor[:vertex] : neighbor
        queue.push(v) unless visited.include?(v)
      end
    end

    result
  end
end

puts "\n4. Breadth-First Search:"
puts "BFS: #{graph.bfs('A').join(' ')}"

# ========================================
# 5. PATH FINDING
# ========================================

class Graph
  def has_path?(start, end_vertex, visited = Set.new)
    return true if start == end_vertex
    return false if visited.include?(start)

    visited.add(start)

    neighbors(start).each do |neighbor|
      v = neighbor.is_a?(Hash) ? neighbor[:vertex] : neighbor
      return true if has_path?(v, end_vertex, visited)
    end

    false
  end

  def find_path(start, end_vertex)
    queue = [[start, [start]]]
    visited = Set.new

    while !queue.empty?
      vertex, path = queue.shift
      return path if vertex == end_vertex
      next if visited.include?(vertex)

      visited.add(vertex)

      neighbors(vertex).each do |neighbor|
        v = neighbor.is_a?(Hash) ? neighbor[:vertex] : neighbor
        queue.push([v, path + [v]]) unless visited.include?(v)
      end
    end

    nil
  end

  def all_paths(start, end_vertex, path = [], all_paths = [])
    path = path + [start]

    if start == end_vertex
      all_paths << path
      return all_paths
    end

    neighbors(start).each do |neighbor|
      v = neighbor.is_a?(Hash) ? neighbor[:vertex] : neighbor
      all_paths(v, end_vertex, path, all_paths) unless path.include?(v)
    end

    all_paths
  end
end

puts "\n5. Path Finding:"
puts "Has path from A to D? #{graph.has_path?('A', 'D')}"
puts "Path from A to D: #{graph.find_path('A', 'D')}"
puts "All paths from A to D:"
graph.all_paths('A', 'D').each { |path| puts "  #{path.join(' -> ')}" }

# ========================================
# 6. CYCLE DETECTION
# ========================================

class Graph
  def has_cycle?
    visited = Set.new
    rec_stack = Set.new

    vertices.each do |vertex|
      return true if has_cycle_util?(vertex, visited, rec_stack)
    end

    false
  end

  private

  def has_cycle_util?(vertex, visited, rec_stack)
    return true if rec_stack.include?(vertex)
    return false if visited.include?(vertex)

    visited.add(vertex)
    rec_stack.add(vertex)

    neighbors(vertex).each do |neighbor|
      v = neighbor.is_a?(Hash) ? neighbor[:vertex] : neighbor
      return true if has_cycle_util?(v, visited, rec_stack)
    end

    rec_stack.delete(vertex)
    false
  end
end

puts "\n6. Cycle Detection:"

cyclic_graph = Graph.new(true)
['A', 'B', 'C'].each { |v| cyclic_graph.add_vertex(v) }
cyclic_graph.add_edge('A', 'B')
cyclic_graph.add_edge('B', 'C')
cyclic_graph.add_edge('C', 'A')
puts "Cyclic graph has cycle? #{cyclic_graph.has_cycle?}"

acyclic_graph = Graph.new(true)
['A', 'B', 'C'].each { |v| acyclic_graph.add_vertex(v) }
acyclic_graph.add_edge('A', 'B')
acyclic_graph.add_edge('A', 'C')
puts "Acyclic graph has cycle? #{acyclic_graph.has_cycle?}"

# ========================================
# 7. TOPOLOGICAL SORT
# ========================================

class Graph
  def topological_sort
    visited = Set.new
    stack = []

    vertices.each do |vertex|
      topological_sort_util(vertex, visited, stack) unless visited.include?(vertex)
    end

    stack.reverse
  end

  private

  def topological_sort_util(vertex, visited, stack)
    visited.add(vertex)

    neighbors(vertex).each do |neighbor|
      v = neighbor.is_a?(Hash) ? neighbor[:vertex] : neighbor
      topological_sort_util(v, visited, stack) unless visited.include?(v)
    end

    stack.push(vertex)
  end
end

puts "\n7. Topological Sort:"

dag = Graph.new(true)
['A', 'B', 'C', 'D', 'E'].each { |v| dag.add_vertex(v) }
dag.add_edge('A', 'C')
dag.add_edge('B', 'C')
dag.add_edge('B', 'D')
dag.add_edge('C', 'E')
dag.add_edge('D', 'E')
dag.display
puts "Topological order: #{dag.topological_sort.join(' -> ')}"

# ========================================
# 8. DIJKSTRA'S SHORTEST PATH
# ========================================

class Graph
  def dijkstra(start)
    distances = Hash.new(Float::INFINITY)
    distances[start] = 0
    previous = {}
    unvisited = vertices.to_set

    while !unvisited.empty?
      current = unvisited.min_by { |v| distances[v] }
      break if distances[current] == Float::INFINITY

      unvisited.delete(current)

      neighbors(current).each do |neighbor|
        vertex = neighbor[:vertex]
        weight = neighbor[:weight]
        alt = distances[current] + weight

        if alt < distances[vertex]
          distances[vertex] = alt
          previous[vertex] = current
        end
      end
    end

    { distances: distances, previous: previous }
  end

  def shortest_path(start, end_vertex)
    result = dijkstra(start)
    path = []
    current = end_vertex

    while current
      path.unshift(current)
      current = result[:previous][current]
    end

    { path: path, distance: result[:distances][end_vertex] }
  end
end

puts "\n8. Dijkstra's Shortest Path:"

weighted_graph.display
result = weighted_graph.shortest_path('A', 'D')
puts "Shortest path from A to D: #{result[:path].join(' -> ')}"
puts "Distance: #{result[:distance]}"

# ========================================
# 9. CONNECTED COMPONENTS
# ========================================

class Graph
  def connected_components
    visited = Set.new
    components = []

    vertices.each do |vertex|
      unless visited.include?(vertex)
        component = []
        dfs(vertex, visited) { |v| component << v }
        components << component
      end
    end

    components
  end

  def is_connected?
    connected_components.length == 1
  end
end

puts "\n9. Connected Components:"

disconnected = Graph.new
['A', 'B', 'C', 'D', 'E', 'F'].each { |v| disconnected.add_vertex(v) }
disconnected.add_edge('A', 'B')
disconnected.add_edge('B', 'C')
disconnected.add_edge('D', 'E')
disconnected.display

puts "Connected components:"
disconnected.connected_components.each_with_index do |component, i|
  puts "  Component #{i + 1}: #{component.join(', ')}"
end
puts "Is connected? #{disconnected.is_connected?}"

# ========================================
# 10. PRACTICAL APPLICATIONS
# ========================================

puts "\n10. Practical Applications:"

# Application 1: Social Network
puts "\nSocial Network:"

social = Graph.new
['Alice', 'Bob', 'Charlie', 'David', 'Eve'].each { |user| social.add_vertex(user) }
social.add_edge('Alice', 'Bob')
social.add_edge('Alice', 'Charlie')
social.add_edge('Bob', 'David')
social.add_edge('Charlie', 'Eve')
social.add_edge('David', 'Eve')

puts "Friends of Alice: #{social.neighbors('Alice').join(', ')}"
puts "Path from Alice to Eve: #{social.find_path('Alice', 'Eve').join(' -> ')}"

# Application 2: Course Prerequisites
puts "\nCourse Prerequisites:"

courses = Graph.new(true)
['Intro CS', 'Data Structures', 'Algorithms', 'AI', 'ML'].each { |c| courses.add_vertex(c) }
courses.add_edge('Intro CS', 'Data Structures')
courses.add_edge('Data Structures', 'Algorithms')
courses.add_edge('Algorithms', 'AI')
courses.add_edge('AI', 'ML')

puts "Course order: #{courses.topological_sort.join(' -> ')}"

# Application 3: City Network
puts "\nCity Network (Shortest Path):"

cities = Graph.new
['NYC', 'Boston', 'Philadelphia', 'Washington DC'].each { |c| cities.add_vertex(c) }
cities.add_edge('NYC', 'Boston', 215)
cities.add_edge('NYC', 'Philadelphia', 95)
cities.add_edge('Philadelphia', 'Washington DC', 140)
cities.add_edge('Boston', 'Washington DC', 440)

result = cities.shortest_path('NYC', 'Washington DC')
puts "Shortest route: #{result[:path].join(' -> ')}"
puts "Total distance: #{result[:distance]} miles"

# ========================================
# TIME COMPLEXITY ANALYSIS
# ========================================

puts "\n" + "=" * 50
puts "TIME COMPLEXITY ANALYSIS"
puts "=" * 50
puts "Adjacency List:"
puts "  Add vertex:         O(1)"
puts "  Add edge:           O(1)"
puts "  Remove vertex:      O(V + E)"
puts "  Remove edge:        O(E)"
puts "  Query edge:         O(V)"
puts "  Space:              O(V + E)"
puts "\nTraversal:"
puts "  DFS:                O(V + E)"
puts "  BFS:                O(V + E)"
puts "\nAlgorithms:"
puts "  Dijkstra:           O((V + E) log V)"
puts "  Topological Sort:   O(V + E)"
puts "  Cycle Detection:    O(V + E)"
puts "=" * 50

# ========================================
# PRACTICE PROBLEMS
# ========================================

puts "\nPRACTICE PROBLEMS:"
puts "1. Number of islands (2D grid)"
puts "2. Clone a graph"
puts "3. Course schedule (detect cycle)"
puts "4. Word ladder transformation"
puts "5. Network delay time"
puts "6. Critical connections (bridges)"
puts "7. Minimum spanning tree (Kruskal/Prim)"
puts "8. Traveling salesman problem"
puts "9. Graph coloring"
puts "10. Strongly connected components"
