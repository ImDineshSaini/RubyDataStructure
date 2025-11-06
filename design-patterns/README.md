# Design Patterns in Ruby

Comprehensive guide to Gang of Four (GoF) design patterns with Ruby implementations.

## What are Design Patterns?

Design patterns are reusable solutions to commonly occurring problems in software design. They represent best practices evolved over time by experienced developers.

## Pattern Categories

### Creational Patterns
Deal with object creation mechanisms, trying to create objects in a manner suitable to the situation.

- **Singleton** - Ensures a class has only one instance
- **Factory Method** - Defines interface for creating objects
- **Abstract Factory** - Creates families of related objects
- **Builder** - Constructs complex objects step by step
- **Prototype** - Creates objects by cloning existing ones

### Structural Patterns
Deal with object composition and typically identify simple ways to realize relationships between entities.

- **Adapter** - Converts interface of a class into another interface
- **Decorator** - Adds behavior to objects dynamically
- **Facade** - Provides simplified interface to complex subsystem
- **Proxy** - Provides placeholder for another object
- **Composite** - Composes objects into tree structures
- **Bridge** - Separates abstraction from implementation
- **Flyweight** - Shares objects to support large numbers efficiently

### Behavioral Patterns
Deal with algorithms and the assignment of responsibilities between objects.

- **Observer** - Defines one-to-many dependency between objects
- **Strategy** - Defines family of algorithms, makes them interchangeable
- **Command** - Encapsulates request as object
- **Iterator** - Accesses elements sequentially without exposing representation
- **Template Method** - Defines skeleton of algorithm in base class
- **State** - Alters behavior when internal state changes
- **Chain of Responsibility** - Passes request along chain of handlers
- **Mediator** - Defines simplified communication between classes
- **Memento** - Captures and restores object's internal state
- **Visitor** - Separates algorithm from object structure

## When to Use Design Patterns

### Benefits
- **Reusability** - Proven solutions that work
- **Maintainability** - Code is easier to understand and modify
- **Communication** - Common vocabulary for developers
- **Best Practices** - Battle-tested solutions

### Cautions
- **Over-engineering** - Don't force patterns where not needed
- **Complexity** - Can add unnecessary complexity
- **Learning curve** - Requires time to understand properly

## Ruby-Specific Considerations

Ruby's dynamic nature makes some patterns trivial or unnecessary:

1. **Iterator Pattern** - Built into Ruby with Enumerable
2. **Strategy Pattern** - Easy with blocks/procs
3. **Template Method** - Natural fit with Ruby's class inheritance
4. **Decorator Pattern** - Simple with modules and method aliasing

## Pattern Selection Guide

### Object Creation Problems
- Need single instance? → **Singleton**
- Complex construction? → **Builder**
- Family of objects? → **Abstract Factory**
- Clone existing? → **Prototype**
- Subclass decision? → **Factory Method**

### Object Structure Problems
- Incompatible interfaces? → **Adapter**
- Add behavior dynamically? → **Decorator**
- Simplify complex system? → **Facade**
- Control access? → **Proxy**
- Part-whole hierarchy? → **Composite**

### Object Behavior Problems
- Notify multiple objects? → **Observer**
- Switch algorithms? → **Strategy**
- Encapsulate request? → **Command**
- Vary by state? → **State**
- Define algorithm steps? → **Template Method**

## Learning Path

1. **Start with common patterns** - Singleton, Factory, Observer
2. **Understand problems they solve** - Don't just memorize code
3. **Practice implementation** - Code each pattern from scratch
4. **Recognize in wild** - Identify patterns in existing codebases
5. **Apply appropriately** - Use when truly beneficial

## Real-World Examples in Ruby/Rails

- **ActiveRecord** - Uses several patterns (Factory, Observer, etc.)
- **Rack Middleware** - Chain of Responsibility
- **Rails Concerns** - Decorator/Mixin pattern
- **Service Objects** - Command pattern
- **Presenters/Decorators** - Decorator pattern

## Additional Resources

- "Design Patterns in Ruby" by Russ Olsen
- "Head First Design Patterns" by Freeman & Freeman
- "Gang of Four" original book
- Ruby/Rails codebases on GitHub

## Running Examples

Each pattern file is self-contained:

```bash
ruby design-patterns/creational/01-singleton.rb
ruby design-patterns/structural/01-adapter.rb
ruby design-patterns/behavioral/01-observer.rb
```
