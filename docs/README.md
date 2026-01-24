# Nexus Programming Language - Complete Documentation

## Table of Contents
1. [Quick Start](#quick-start)
2. [Installation](#installation)
3. [Getting Started](#getting-started)
4. [Language Specification](#language-specification)
5. [Complete Guide](#complete-guide)

---

## Quick Start

The Nexus interpreter is ready to use! No installation needed - just Python 3.

```bash
cd path/to/nexus-lang
bash install.sh
```

### Your First Program
Create a file `hello.nexus`:
```nexus
println "Hello, Nexus!"
```

Run it:
```bash
nexus hello.nexus
```

---

## Installation

### Requirements
- Python 3.8 or higher
- Git (for development installations)
- pip (Python package manager)

### From Source
```bash
git clone https://github.com/nekocd10/Nexus
cd Nexus
bash install.sh
```

### Verify Installation
```bash
nexus --version
nexus --help
```

---

## Getting Started

### Your First Nexus Program

#### 1. Hello World
```bash
nexus run examples/01_hello.nexus
```

Output:
```
Hello, Nexus World!
```

#### 2. Variables & Arithmetic
```bash
nexus run examples/02_variables.nexus
```

Output:
```
30
```

#### 3. Collections (Pools)
```bash
nexus run examples/03_pools.nexus
```

Output:
```
[1, 2, 3, 4, 5]
{'name': 'Alice', 'age': 30, 'city': 'NYC'}
```

### Interactive REPL

Try Nexus interactively:

```bash
nexus repl
```

Then type:
```
nexus> 10 + 5 => output
15
nexus> "Hello, Nexus!" => output
Hello, Nexus!
nexus> [| 1, 2, 3 |] => output
[1, 2, 3]
```

### Language Basics

#### Variables
```nexus
#var x = 10        // Immutable
@var y = 20        // Mutable
```

#### Collections
```nexus
[| 1, 2, 3 |]           // Ordered pool
[: name="Bob", age=30 :] // Keyed pool
```

#### Operations
```nexus
a + b => output    // Addition → output
a - b => output    // Subtraction → output
a * b => output    // Multiplication → output
a / b => output    // Division → output
```

#### Comparisons
```nexus
a > b => output     // Greater than
a == b => output    // Equal
a != b => output    // Not equal
```

#### Strings
```nexus
"Hello" + " " + "Nexus!" => output
```

### All Example Programs

1. **01_hello.nexus** - Hello world
2. **02_variables.nexus** - Variables and arithmetic
3. **03_pools.nexus** - Collections
4. **04_contexts.nexus** - Context definitions
5. **05_arithmetic.nexus** - Math operations
6. **06_comparison.nexus** - Comparisons
7. **07_mutation.nexus** - State changes
8. **08_strings.nexus** - String operations

Run any with:
```bash
python3 nexus examples/[number]_[name].nexus
```

### Debugging Tools

#### View Tokens
```bash
python3 nexus --tokens examples/01_hello.nexus
```

#### View AST
```bash
python3 nexus --ast examples/01_hello.nexus
```

### Creating Your Own Program

Create a file `my_program.nexus`:

```nexus
// My first Nexus program
#var x = 100
#var y = 50

x + y => output
x - y => output
x * y => output
x / y => output

"Program complete!" => output
```

Run it:
```bash
python3 nexus my_program.nexus
```

### Key Language Operators

| Operator | Use | Example |
|----------|-----|---------|
| `=>` | Send data forward | `value => output` |
| `@` | Mutable state | `@var x = 10` |
| `#` | Immutable value | `#var x = 10` |
| `~` | Define context | `~context name` |
| `[` `\|` ... `\|` `]` | Ordered pool | `[` `\|` `1, 2, 3` `\|` `]` |
| `[: ... :]` | Keyed pool | `[: x=1 :]` |
| `?` | Condition | `x ? > 10 => ...` |

---

## Language Specification

### Philosophy: Completely Original Language Design

Nexus is a fundamentally different language with unique syntax, paradigms, and concepts that don't exist in mainstream languages.

### Core Unique Features

#### 1. CONTEXT-BASED PROGRAMMING
Instead of functions/methods, Nexus uses **Contexts** - named execution scopes with inputs and outputs:

```nexus
~context add_numbers
  @in: a, b
  @out: result
  result => a + b
```

#### 2. FLOW ARROWS
Data flows through `=>` (forward), `<=` (backward), `<>` (bidirectional):

```nexus
data => transform => output
value <= previous_context
```

#### 3. POOLS (Unique data structures)
**Pools** are ordered, indexed collections with implicit iteration:

```nexus
[| 1, 2, 3, 4, 5 |]  # pool of numbers
[: name="Alice", age=30, city="NYC" :]  # keyed pool
```

#### 4. MUTATIONS (State management)
Use `@` symbol to mark values that change:

```nexus
@counter = 0
@counter ++> 1  # increment, result flows forward
```

#### 5. CONDITION GATES
Instead of if/else, use condition gates with `?`:

```nexus
value ? > 10
  => "large"
| < 10
  => "small"
| else
  => "medium"
```

#### 6. REACTION CHAINS
Instead of while/for, use reactions that trigger on conditions:

```nexus
~reaction process_items
  @items
  ? @items.length > 0
    => process @items[0]
    @items => @items.tail
```

#### 7. CHANNEL OPERATORS
Pass data through channels with `@>`, `<@`, `@<>`:

```nexus
data @> transform @> output
input <@ previous <@ start
```

#### 8. ASPECT SYSTEM
Mark behaviors that apply across contexts:

```nexus
#[aspect: logging]
#[aspect: security]
~context protected_operation
  @in: data
  @out: result
```

#### 9. QUANTUM OPERATORS
Handle alternatives elegantly:

```nexus
value ?: a | b | c  # try a, if fails try b, if fails try c
```

#### 10. RESONANCE BLOCKS
Named blocks that resonate together:

```nexus
{~ resonance process_payment
  validate => charge => confirm
~}
```

### Syntax Components

#### Variable Declaration
```nexus
#var x = 10           # immutable binding
@var counter = 0      # mutable state
```

#### Contexts (Execution Blocks)
```nexus
~context name
  @in: param1, param2
  @out: result
  # body
```

#### Flow Control
```nexus
~gate condition
  ? condition1 => action1
  | condition2 => action2
  | else => default_action
```

#### Pools (Collections)
```nexus
[| 1, 2, 3 |]         # ordered pool
[: x=1, y=2 :]        # keyed pool
```

#### Reactions (Loops)
```nexus
~reaction keep_going
  @state
  ? @state != done
    => process @state
    @state => update @state
```

#### Data Flow
```nexus
input => step1 => step2 => output
@value ++> next_value
result <= source_context
```

### Example Programs

#### Hello World
```nexus
~context main
  @out: message
  message => "Hello, Nexus!"
```

#### Variables and Operations
```nexus
#var x = 10
#var y = 20
#var sum = x + y
sum => output
```

#### Simple Context
```nexus
~context multiply
  @in: a, b
  @out: result
  result => a * b
```

#### Conditional Gates
```nexus
~context classify
  @in: number
  @out: type
  
  number ? > 100
    => type = "large"
  | > 10
    => type = "medium"
  | else
    => type = "small"
```

#### Pool Operations
```nexus
~context sum_pool
  @in: numbers [| |]
  @out: total
  
  @total = 0
  
  ~reaction add_items
    [| numbers |]
    ? @total => @total + item
```

#### Reaction (Loop) with State
```nexus
~context countdown
  @in: start
  @out: sequence
  
  @current = start
  @sequence = [| |]
  
  ~reaction count_down
    ? @current >= 0
      @sequence => @sequence + @current
      @current ++> @current - 1
```

### Built-in Contexts

```nexus
~context output          # send to output
~context input           # receive input
~context type_of         # get type
~context length          # get length
~context reverse         # reverse pool
~context transform       # apply transformation
~context filter          # filter pool
~context accumulate      # reduce operation
```

### Unique Syntax Rules

1. **`~`** - Marks context/reaction definitions
2. **`@`** - Marks mutable state
3. **`#`** - Marks immutable bindings
4. **`=>`** - Forward flow
5. **`<=`** - Backward flow
6. **`?`** - Gate/condition marker
7. **`|`** - Alternative branch
8. **`[| |]`** - Ordered pool
9. **`[: :]`** - Keyed pool
10. **`@>`** - Channel operator
11. **`++>`** - Increment and flow
12. **`?:`** - Quantum operator

### Why It's Completely Different

- **No functions** - Uses contexts instead
- **No if/else** - Uses condition gates with `?`
- **No loops** - Uses reactions that trigger on state
- **No arrays/objects** - Uses pools (unique data structure)
- **No methods** - Data flows through channels
- **No return statements** - Results flow forward with `=>`
- **Aspect system** - Built-in cross-cutting concerns
- **Quantum operators** - Try multiple alternatives
- **Explicit data flow** - All movement marked with arrows
- **Mutable state marked** - `@` prefix shows what can change

This language is fundamentally different from every mainstream language and creates a new paradigm for thinking about programs.

---

## Complete Guide

### Installation Methods
```bash
# Download and run the installer
bash <(curl -sL https://github.com/nekocd10/Nexus/raw/main/install.sh)

# Or using wget
bash <(wget -qO- https://github.com/nekocd10/Nexus/raw/main/install.sh)

# Or local installation
cd /workspaces/Nexus
bash install.sh
```

### Basic Concepts
- **Variables**: Declare with `#var` (immutable) or `@var` (mutable)
- **Pools**: Aggregate values using pool syntax `[| |]` or `[: :]`
- **Contexts**: Create scoped environments with `~context`
- **Data Flow**: Pass data with `=>` operator
- **Mutations**: Handle stateful changes with `@` prefix

### Project Structure

```
Nexus/
├── src/                 # Core interpreter source code
│   ├── lexer.py        # Tokenizer
│   ├── parser.py       # AST builder
│   ├── interpreter.py  # Execution engine
│   ├── cli.py          # Command-line interface
│   ├── backend.py      # Backend system
│   ├── frontend.py     # Frontend system
│   └── ...
├── docs/                # Documentation files
├── examples/            # Example Nexus programs
├── nxs_modules/         # Built-in modules
└── setup.py             # Package configuration
```

### Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

### Questions?

Check the source files:
- `src/lexer.py` - How tokenization works
- `src/parser.py` - How parsing works
- `src/interpreter.py` - How execution works

Enjoy coding in Nexus! 🚀

### Back to Main README
- [Back to Main README](../README.md)
- [Examples](../examples/)
