%code requires {
#include "types.h" /*parser.h needs TypeRef*/
}

%{
#include <stdio.h>
#include <stdlib.h>
#include "types.h" /*type kinds and TypeRef*/
int yylex(void);
void yyerror(const char* s);
extern char *yytext;
extern int yylineno;
%}

%define parse.error verbose

/*token and rule values*/
%union {
    char *str;    /* TOK_IDENT text */
    long num;      /* TOK_NUM value */
    int kind;     /* TOK_PRIM_TYPE kind */
    TypeRef type; /* type_specifier result */
}

%token TOK_STRUCT "'%struc'"
%token <str> TOK_IDENT "'identifier'"
%token <num> TOK_NUM  "'number'"
/*one terminal for all primitives*/
%token <kind> TOK_PRIM_TYPE "'primitive type'"
%token TOK_LBRACE "'{'" 
%token TOK_RBRACE "'}'"
%token TOK_LPAREN "'('"
%token TOK_RPAREN "')'"
%token TOK_SEMICOLON "';'"
%token TOK_ASSIGN "'='"
%token TOK_ASTERISK "'*'"
%token TOK_COLON  "':'"
%token TOK_ERROR "'err'"

/*type_specifier carries a TypeRef*/
%type <type> type_specifier

%%

program: top_level_list
	   ;

/*left recursive CFG, grows by one struct*/
top_level_list: %empty
				| top_level_list struct_defn
				;

/*struct defn nonterminal*/
struct_defn: TOK_STRUCT TOK_IDENT TOK_LBRACE member_list TOK_RBRACE TOK_SEMICOLON {
				free($2); /*TODO: store struct definition*/
			}
			;

member_list: %empty
		   | member_list member_decl
		   ;

/*TODO: build AST instead of freeing*/
/*one member rule for every type*/
member_decl: TOK_IDENT type_specifier TOK_SEMICOLON {
				free($1);      /*TODO: store member name*/
				free($2.name); /*TODO: store member type*/
			}
			;

/*TODO: add pointers: type_specifier TOK_ASTERISK*/
/*generic type rule*/
type_specifier: TOK_PRIM_TYPE {
					$$.kind = (TypeKind)$1; /*$1 is the lexer kind*/
					$$.name = NULL;
				}
			  | TOK_IDENT {
					$$.kind = TY_NAMED; /*TODO: semantic pass checks it*/
					$$.name = $1;
				}
			  ;

%%

void yyerror(const char *str)
{
    fprintf(stderr, "urslcc: fatal: line %d: %s near '%s'\n", yylineno, str, yytext);
}

/*let's test it out*/
extern FILE *yyin;
int main(int argc, char *argv[])
{
	if (argc > 1)
	{
		FILE *fd = fopen(argv[1], "r");
		if (!fd) { 
			fprintf(stderr, "urlsc: fatal: couldn't open file '%s'\n", argv[1]); 
			return 1;
		}
		yyin = fd; /*give the file pointer our open file*/
		return yyparse();
	}
	fprintf(stderr, "urslc: fatal: no input files\n");
	return 1;
}
