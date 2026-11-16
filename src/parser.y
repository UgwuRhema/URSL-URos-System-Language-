%{
#include <stdio.h>
int yylex(void);
void yyerror(const char* s);
extern char *yytext;
extern int yylineno;
%}

%define parse.error verbose

%union {
    char *str;
    int num;
}

%token STRUCT_TOK "'Struct"
%token <str> TOK_IDENT "'identifier'"
%token <num> TOK_NUM  "'number'"
%token TOK_LBRACE "'{'" 
%token TOK_RBRACE "'}'"
%token TOK_LPAREN "'('"
%token TOK_RPAREN "')'"
%token TOK_SEMICOLON "';'"
%token TOK_ASSIGN "'='"
%token TOK_COLON  "':'"

%%

program: function_list
       ;

function_list: function 
             | function_list function
             ;
%%

void yyerror(const char *str)
{
    fprintf(stderr, "urslcc: fatal: line %d: %s near '%s'\n", yylineno, str, yytext);
}
