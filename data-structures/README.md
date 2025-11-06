# Data Structures in Ruby

Complete guide to implementing and using data structures in Ruby.

## Overview

Data structures are fundamental building blocks for efficient algorithms. This guide covers both built-in Ruby data structures and custom implementations.

## Contents

### Basic Data Structures
1. **Arrays** - Dynamic arrays, operations, and complexity
2. **Hashes** - Key-value pairs, hash functions, collision handling
3. **Sets** - Unique collections, set operations

### Linear Data Structures
4. **Linked Lists** - Singly linked, doubly linked, circular
5. **Stacks** - LIFO principle, use cases
6. **Queues** - FIFO principle, circular queues
7. **Deque** - Double-ended queue operations

### Non-Linear Data Structures
8. **Binary Trees** - Tree traversals (inorder, preorder, postorder, level-order)
9. **Binary Search Trees** - Insertion, deletion, searching
10. **Heaps** - Min heap, max heap, heap sort
11. **Tries** - Prefix trees for string operations
12. **Graphs** - Adjacency list, adjacency matrix, traversals (DFS, BFS)

### Advanced Structures
13. **Hash Tables** - Custom implementation with collision handling
14. **LRU Cache** - Cache with eviction policy

## Time Complexity Quick Reference

| Data Structure | Access | Search | Insertion | Deletion |
|---------------|--------|--------|-----------|----------|
| Array | O(1) | O(n) | O(n) | O(n) |
| Hash | O(1) | O(1) | O(1) | O(1) |
| Stack | O(n) | O(n) | O(1) | O(1) |
| Queue | O(n) | O(n) | O(1) | O(1) |
| Linked List | O(n) | O(n) | O(1) | O(1) |
| BST | O(log n) | O(log n) | O(log n) | O(log n) |
| Heap | O(n) | O(n) | O(log n) | O(log n) |
| Trie | O(k) | O(k) | O(k) | O(k) |

*Note: BST operations are O(n) worst case, O(log n) average case*

## Learning Path

1. **Start with basics** - Arrays, Hashes, Sets
2. **Linear structures** - Linked Lists, Stacks, Queues
3. **Tree structures** - Binary Trees, BST, Heaps
4. **Advanced topics** - Graphs, Tries, Hash Tables
5. **Practice** - Implement from scratch, solve problems

## Usage

Each file contains:
- Conceptual explanation
- Implementation with comments
- Usage examples
- Time/space complexity analysis
- Common use cases
- Practice problems

Run any example:
```bash
ruby data-structures/01-arrays.rb
```
