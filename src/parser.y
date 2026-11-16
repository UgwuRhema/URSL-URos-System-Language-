%{
#include <stdio.h>
#include <stdlib.h>
#include "types.h"
int yylex(void);
void yyerror(const char* s);
extern char *yytext;
extern int yylineno;

/*primitive spelling*/
static const char *prim_name(int kind)
{
	switch (kind) {
		case TY_U64: return "u64";
		case TY_I64: return "i64";
		case TY_U32: return "u32";
		case TY_I32: return "i32";
		case TY_U16: return "u16";
		case TY_I16: return "i16";
		case TY_U8:  return "u8";
		case TY_I8:  return "i8";
		case TY_VOID: return "vd";
		default: return "?";
	}
}
%}

%define parse.error verbose

%union {
    char *str;
    int num;
    int kind;
}

%token TOK_STRUCT "'%struc'"
%token <str> TOK_IDENT "'identifier'"
%token <num> TOK_NUM  "'number'"
%token <kind> TOK_PRIM_TYPE "'primitive type'"
%token TOK_LBRACE "'{'" 
%token TOK_RBRACE "'}'"
%token TOK_LPAREN "'('"
%token TOK_RPAREN "')'"
%token TOK_SEMICOLON "';'"
%token TOK_ASSIGN "'='"
%token TOK_ASTERISK "'*'"
%token TOK_COLON  "':'"

%type <kind> type_specifier

%%

program: metadata_defn_list
	   ;

/*left recursive CFG*/
metadata_defn_list: %empty
				  | struct_defn
				  | metadata_defn_list struct_defn
				  ;

/*struct defn nonterminal*/
struct_defn: TOK_STRUCT TOK_IDENT TOK_LBRACE member_list TOK_RBRACE TOK_SEMICOLON {
				printf("struct definition\n");
			}
			;

member_list: member_decl
		   | member_list member_decl
		   ;

/*one member rule for every type*/
member_decl: TOK_IDENT type_specifier TOK_SEMICOLON {
				printf("Member decl: %s: %s\n", $1, prim_name($2));
				free($1);
			}
			;

/*generic type rule*/
type_specifier: TOK_PRIM_TYPE {
					$$ = $1;
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
