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

%token TOK_STRUCT "'Struct'"
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
	   | metadata_defn_list
	   ;

/*left recursion*/
function_list: function
             | function_list function
             ;

metadata_defn_list: %empty
				  | struct_defn
				  | metadata_defn_list struct_defn
				  ;

/*struct defn nonterminal*/
struct_defn: STRUCT_TOK TOK_IDENT TOK_LBRACE member_list TOK_RBRACE {
				printf("struct definition");
			}
			;

member_list: member_decl
		   | member_list member_decl
		   ;

member_decl: 

%%

void yyerror(const char *str)
{
    fprintf(stderr, "urslcc: fatal: line %d: %s near '%s'\n", yylineno, str, yytext);
}
