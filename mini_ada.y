%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h" 

AST *root;
int yylex(void);
void yyerror(const char *s) { fprintf(stderr, "Error: %s\n", s); }
%}

%union {
    char *str;
    AST *node;
}

%token <str> ID NUMBER STRING
%token <str> OP COMPARE
%token PROCEDURE IS BEGIN_ END MAIN
%token IF THEN ELSE WHILE LOOP
%token PUT_LINE GET_LINE
%token AND OR NOT
%token ASSIGN LPAREN RPAREN SEMICOL

%type <node> program block statement expr term factor

%%

program
    : PROCEDURE MAIN IS BEGIN_ block END MAIN SEMICOL { 
        root = new_ast(NODE_PROGRAM, "Main"); 
        root->body = $5; 
    }
    ;

block
    : statement block { 
        $$ = new_ast(NODE_BLOCK, NULL); 
        $$->children = malloc(sizeof(AST*) * 2);
        $$->children[0] = $1;
        $$->children[1] = $2;
        $$->child_count = 2;
    }
    | statement { 
        $$ = new_ast(NODE_BLOCK, NULL); 
        $$->children = malloc(sizeof(AST*) * 1);
        $$->children[0] = $1;
        $$->child_count = 1;
    }
    ;

statement
    : ID ASSIGN expr SEMICOL { 
        $$ = new_ast(NODE_ASSIGN, $1); 
        $$->right = $3; 
    }
    | IF expr THEN block ELSE block END IF SEMICOL { 
        $$ = new_ast(NODE_IF, NULL); 
        $$->cond = $2; 
        $$->then_branch = $4; 
        $$->else_branch = $6; 
    }
    | WHILE expr LOOP block END LOOP SEMICOL { 
        $$ = new_ast(NODE_WHILE, NULL); 
        $$->cond = $2; 
        $$->body = $4; 
    }
    | PUT_LINE LPAREN expr RPAREN SEMICOL { 
        $$ = new_ast(NODE_CALL, "Put_Line"); 
        $$->left = $3; 
    }
    | GET_LINE SEMICOL { 
        $$ = new_ast(NODE_CALL, "Get_Line"); 
    }
    ;

expr
    : term { $$ = $1; }
    | expr OP term { 
        $$ = new_ast_binary(NODE_BINOP, $2, $1, $3); 
    }
    | expr COMPARE term { 
        $$ = new_ast_binary(NODE_BINOP, $2, $1, $3); 
    }
    | expr AND term { 
        $$ = new_ast_binary(NODE_BINOP, "and", $1, $3); 
    }
    | expr OR term { 
        $$ = new_ast_binary(NODE_BINOP, "or", $1, $3); 
    }
    ;

term
    : factor { $$ = $1; }
    ;

factor
    : NUMBER { $$ = new_ast(NODE_LITERAL, $1); }
    | STRING { $$ = new_ast(NODE_LITERAL, $1); }
    | ID { $$ = new_ast(NODE_VAR, $1); }
    | LPAREN expr RPAREN { $$ = $2; }
    | NOT factor { 
        $$ = new_ast(NODE_UNARYOP, "not"); 
        $$->left = $2; 
    }
    ;

%%

int main(void) {
    if (yyparse() == 0) {
        printf("Parsed successfully!\n");
        print_ast(root, 0);
    }
    return 0;
}