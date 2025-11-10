# SOLID Principles in Ruby

SOLID is an acronym for five design principles that make software more understandable, flexible, and maintainable.

## The Five SOLID Principles

### 1. Single Responsibility Principle (SRP)
**"A class should have one, and only one, reason to change."**

- Each class should have only one responsibility
- A class should have only one reason to change
- Promotes high cohesion and low coupling

### 2. Open/Closed Principle (OCP)
**"Software entities should be open for extension, but closed for modification."**

- Open for extension: Can add new functionality
- Closed for modification: Don't modify existing code
- Achieved through abstraction and polymorphism

### 3. Liskov Substitution Principle (LSP)
**"Subtypes must be substitutable for their base types."**

- Objects of a superclass should be replaceable with objects of subclass
- Subclasses should enhance, not replace, base class behavior
- Contract of base class must be honored

### 4. Interface Segregation Principle (ISP)
**"Clients should not be forced to depend on interfaces they don't use."**

- Many specific interfaces are better than one general interface
- Classes shouldn't implement methods they don't need
- In Ruby: Use modules and mixins carefully

### 5. Dependency Inversion Principle (DIP)
**"Depend on abstractions, not concretions."**

- High-level modules shouldn't depend on low-level modules
- Both should depend on abstractions
- Abstractions shouldn't depend on details

## Why SOLID Matters

### Benefits
- **Maintainability** - Easier to modify and extend code
- **Testability** - Simpler to write unit tests
- **Reusability** - Components can be reused in different contexts
- **Scalability** - Code can grow without becoming unmanageable
- **Readability** - Code is easier to understand

### In Ruby Context
Ruby's dynamic nature and features like:
- **Modules** - Help with ISP and SRP
- **Duck Typing** - Natural fit for LSP
- **Blocks/Procs** - Enable DIP and OCP
- **Metaprogramming** - Can help or hurt SOLID principles

## Quick Reference

| Principle | Question to Ask | Ruby Feature |
|-----------|----------------|--------------|
| SRP | Does this class do one thing? | Classes, Modules |
| OCP | Can I add features without changing existing code? | Inheritance, Modules |
| LSP | Can I replace parent with child? | Inheritance, Duck Typing |
| ISP | Is this interface too fat? | Modules, Mixins |
| DIP | Am I depending on abstraction? | Duck Typing, Dependency Injection |

## Common Violations

### SRP Violations
- God objects that do everything
- Classes handling multiple concerns
- Mixed business logic and presentation

### OCP Violations
- Using conditionals instead of polymorphism
- Modifying existing classes for new features
- Hardcoded dependencies

### LSP Violations
- Subclass throws exceptions parent doesn't
- Subclass weakens preconditions
- Subclass strengthens postconditions

### ISP Violations
- Fat interfaces with many methods
- Forcing implementation of unused methods
- One-size-fits-all modules

### DIP Violations
- Direct instantiation of concrete classes
- Tight coupling to specific implementations
- No abstraction layer

## Learning Path

1. **Understand each principle** - Study definitions and examples
2. **Recognize violations** - Learn to spot anti-patterns
3. **Practice refactoring** - Apply principles to existing code
4. **Write new code** - Use principles from the start
5. **Balance pragmatism** - Don't over-engineer

## SOLID and Other Principles

SOLID works well with:
- **DRY** (Don't Repeat Yourself)
- **KISS** (Keep It Simple, Stupid)
- **YAGNI** (You Aren't Gonna Need It)
- **Composition over Inheritance**
- **Law of Demeter**

## Real-World Examples

### Rails/Ruby Gems
- **ActiveRecord** - OCP with callbacks and modules
- **Rack** - DIP with middleware abstractions
- **RSpec** - ISP with focused matchers
- **Sidekiq** - SRP with job classes

### Common Patterns
- Service Objects → SRP
- Strategy Pattern → OCP, DIP
- Decorator Pattern → OCP, SRP
- Adapter Pattern → LSP, DIP

## Red Flags

Watch for these code smells:
- Large classes (>200 lines)
- Long methods (>10 lines)
- Many parameters (>3)
- Deep nesting (>3 levels)
- Lots of conditionals
- Tight coupling
- Global state

## Practical Tips

### For SRP
- Use service objects
- Separate concerns into modules
- Keep controllers thin
- Extract complex logic

### For OCP
- Use strategy pattern
- Leverage modules and inheritance
- Design for extension points
- Avoid switch statements

### For LSP
- Test with parent type
- Follow contract
- Don't weaken guarantees
- Use duck typing

### For ISP
- Small, focused modules
- Role-based interfaces
- Composition over inclusion
- Method visibility

### For DIP
- Dependency injection
- Factory pattern
- Use abstractions
- Inversion of control

## Running Examples

Each principle has detailed examples:

```bash
ruby solid-principles/01-srp.rb
ruby solid-principles/02-ocp.rb
ruby solid-principles/03-lsp.rb
ruby solid-principles/04-isp.rb
ruby solid-principles/05-dip.rb
```

## Further Reading

- "Practical Object-Oriented Design in Ruby" by Sandi Metz
- "Clean Code" by Robert C. Martin
- "Agile Software Development" by Robert C. Martin
- Ruby Science by thoughtbot
