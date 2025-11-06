# Core Ruby Concepts

Essential Ruby programming concepts every developer should master.

## Overview

This guide covers fundamental and advanced Ruby concepts that form the foundation of Ruby programming.

## Table of Contents

### Object-Oriented Programming
1. **Classes and Objects** - Class definition, instantiation, instance variables
2. **Inheritance** - Class hierarchies, method overriding, super
3. **Modules and Mixins** - Code reuse, namespacing, include vs extend
4. **Encapsulation** - Public, private, protected methods
5. **Polymorphism** - Duck typing, method overriding

### Blocks, Procs, and Lambdas
6. **Blocks** - Yield, block_given?, implicit blocks
7. **Procs** - Proc objects, calling procs
8. **Lambdas** - Lambda vs Proc differences
9. **Closures** - Binding and scope

### Metaprogramming
10. **Method Missing** - Dynamic method handling
11. **Define Method** - Dynamic method creation
12. **Class Eval and Instance Eval** - Code evaluation in context
13. **Eigenclasses** - Singleton classes, class methods
14. **Hooks** - Inherited, included, extended callbacks

### Functional Programming
15. **Enumerables** - Map, select, reduce, and more
16. **Lazy Evaluation** - Lazy enumerables for efficiency
17. **Immutability** - Freeze, dup, clone
18. **Method Chaining** - Fluent interfaces

### Advanced Features
19. **Refinements** - Scoped monkey patching
20. **Structs** - Quick data classes
21. **Exception Handling** - Rescue, ensure, custom exceptions
22. **Regular Expressions** - Pattern matching

### Concurrency
23. **Threads** - Thread creation, synchronization
24. **Fibers** - Lightweight concurrency
25. **Ractors** - Parallel execution (Ruby 3.0+)

## Key Principles

### Ruby Philosophy
- **TIMTOWTDI** - There's more than one way to do it
- **Convention over Configuration** - Sensible defaults
- **Principle of Least Surprise** - Behavior should be intuitive
- **Duck Typing** - If it quacks like a duck...

### Best Practices
- Follow Ruby style guide
- Write idiomatic Ruby
- Prefer composition over inheritance
- Use modules for shared behavior
- Keep methods small and focused
- Write self-documenting code

## Learning Path

### Beginner
1. Classes and Objects
2. Basic OOP concepts
3. Blocks and iterators
4. Modules basics

### Intermediate
1. Advanced blocks, procs, lambdas
2. Metaprogramming basics
3. Enumerables mastery
4. Module patterns

### Advanced
1. Deep metaprogramming
2. Eigenclasses
3. Concurrency patterns
4. Performance optimization

## Ruby Features by Version

### Ruby 2.x
- Keyword arguments
- Symbol to proc
- Refinements
- Lazy enumerables

### Ruby 3.x
- Ractors (parallel execution)
- Pattern matching
- Rightward assignment
- Endless methods
- Type signatures (RBS)

## Common Patterns

### Singleton Pattern
```ruby
class MyClass
  include Singleton
end
```

### Factory Pattern
```ruby
def create_object(type)
  case type
  when :a then ClassA.new
  when :b then ClassB.new
  end
end
```

### Builder Pattern
```ruby
user = User.build do |u|
  u.name = "John"
  u.email = "john@example.com"
end
```

### Method Chaining
```ruby
result = [1,2,3]
  .map { |n| n * 2 }
  .select { |n| n > 4 }
  .sum
```

## Ruby vs Other Languages

### Ruby vs Python
- Ruby: More OOP-focused, blocks everywhere
- Python: More procedural, explicit is better

### Ruby vs JavaScript
- Ruby: Class-based OOP, mixin-based inheritance
- JavaScript: Prototype-based, function-first

### Ruby vs Java
- Ruby: Dynamic typing, duck typing, metaprogramming
- Java: Static typing, interfaces, compile-time checks

## Debugging Techniques

1. **puts/p/pp** - Simple output debugging
2. **binding.irb** - Interactive debugging
3. **pry** - Advanced REPL
4. **ruby-debug** - Step-through debugging
5. **caller** - Stack trace inspection

## Performance Considerations

- Use symbols for hash keys
- Avoid creating unnecessary objects
- Use bang methods when appropriate
- Lazy evaluation for large collections
- Memoization for expensive operations
- Avoid global variables

## Testing

- **RSpec** - BDD testing framework
- **Minitest** - Lightweight testing
- **Test::Unit** - Standard library testing
- **Mock/Stub** - Test doubles

## Common Gotchas

1. **Frozen String Literals** - Default in Ruby 3
2. **Instance Variables** - Return nil if undefined
3. **Method Visibility** - Be careful with private/protected
4. **Block vs Symbol to Proc** - Performance differences
5. **Mutating Methods** - Bang methods modify in place

## Resources

### Books
- "The Well-Grounded Rubyist"
- "Metaprogramming Ruby"
- "Eloquent Ruby"
- "Ruby Under a Microscope"

### Online
- Ruby documentation (ruby-doc.org)
- Ruby Style Guide
- Ruby Koans
- Exercism Ruby track

## Running Examples

```bash
ruby core-concepts/01-classes-objects.rb
ruby core-concepts/06-blocks-procs-lambdas.rb
ruby core-concepts/07-metaprogramming.rb
```
