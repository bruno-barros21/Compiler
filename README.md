# Mini-Ada Compiler

This project implements a **scanner (lexer)** and **parser** for a simple subset of the Ada programming language.  
It constructs an **Abstract Syntax Tree (AST)** for a program containing a single `Main` procedure. The compiler supports:

- Arithmetic expressions  
- Boolean expressions (`and`, `or`, `not`)  
- Assignment statements (`:=`)  
- Conditional statements (`if ... then ... else`)  
- While loops  
- Input/output functions: `Put_Line` and `Get_Line`  

---

![C](https://img.shields.io/badge/Language-C-555.svg?style=for-the-badge&logo=c&logoColor=white)
![Bison](https://img.shields.io/badge/Bison-FF0000.svg?style=for-the-badge)
![Flex](https://img.shields.io/badge/Flex-0078D7.svg?style=for-the-badge)

---

## Directory Tree
```text
MiniAdaProject/
├── mini_ada.l         # Flex lexer
├── mini_ada.y         # Bison parser
├── ast.h              # AST node definitions
├── ast.c              # AST implementation
├── test.ada           # Sample Ada program
└── README.md          # This file
```

## Code Overview

Here is a description of each file in the Mini-Ada compiler project:

### - <ins>"ast.h"</ins>

  . Defines the structure of the **Abstract Syntax Tree (AST)** used to represent the parsed Ada program.  
  . Declares the `NodeType` enum and `AST` struct, including fields for node type, value, child nodes, and pointers for expressions/statements (`left`, `right`, `cond`, `then_branch`, etc.).  
  . Declares functions for creating and manipulating AST nodes (`new_ast()`, `new_ast_binary()`, `print_ast()`).  
  . Acts as the **data model** for the parser, providing a structured way to represent the program's hierarchy.


### - <ins>"ast.c"</ins>

  . Implements the functions declared in **"ast.h"**.  
  . `new_ast()` - allocates memory and initializes a generic AST node.  
  . `new_ast_binary()` - creates a binary operation node with left and right children.  
  . `print_ast()` - recursively prints the AST with indentation to visualize the program structure.  
  . Provides the **logic to create, link, and traverse** the AST during parsing, enabling the parser to build a complete representation of the program.

### - <ins>"mini_ada.l"</ins>

- Implements the **lexical analysis** phase of the compiler.  
- Defines regular expressions to recognize Ada keywords (`procedure`, `Main`, `if`, `while`, etc.), operators (`+`, `-`, `*`, `/`, `:=`, comparisons), identifiers, numbers, and string literals.  
- Converts the input Ada source code (`test.ada`) into a stream of **tokens** for the parser.  
- Assigns semantic values to tokens (`yylval`) to be used by the parser when building the AST.  
- Handles whitespace and illegal characters gracefully.  
- Contains `yywrap()` to signal the end of input.  
- Acts as the **bridge between raw source code and the parser**, providing structured tokenized data for syntactic analysis.

---

### - <ins>"mini_ada.y"</ins>

. Implements the **syntactic analysis (parsing)** phase using **Bison**.  
. Defines the grammar rules for the Mini-Ada subset:
  - `program` - top-level Main procedure.  
  - `block` - sequence of statements.  
  - `statement` - assignment, `if ... then ... else`, `while ... loop`, `Put_Line`, `Get_Line`.  
  - `expr`, `term`, `factor` - arithmetic and boolean expressions.  
. Uses semantic actions to **construct the AST** dynamically while parsing, calling `new_ast()` and `new_ast_binary()` functions.  
. Declares tokens and `%union` for semantic values (`char *` for identifiers and literals, `AST*` for nodes).  
. The `main()` function executes `yyparse()` and prints the AST if parsing is successful.  
. Converts the token stream from the lexer into a fully structured AST, representing the hierarchical structure of the program.  
. Acts as the **core of the compiler**, defining the syntax rules and orchestrating AST construction.

### - <ins>"test.ada"</ins>

After compilating all the programs using gcc, executing the produced file with the **"test.ada"** text, this is the output:

Parsed successfully!
PROGRAM [Main]
  BLOCK
    ASSIGN [X]
      LITERAL [10]
    BLOCK
      WHILE
        BINOP [>]
          VAR [X]
          LITERAL [0]
        BLOCK
          CALL [Put_Line]
            LITERAL ["Countdown"]
          BLOCK
            ASSIGN [X]
              BINOP [-]
                VAR [X]
                LITERAL [1]

## Authorship
Made by Bruno Barros and Orlando Soares.

Built as part of coursework at [Faculdade de Ciências da Universidade do Porto](https://www.up.pt/fcup/pt/).
