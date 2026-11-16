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
%token TOK_U64 "'u64'"
%token TOK_I64 "'i64'"
%token TOK_U32 "'u32'"
%token TOK_I32 "'i32'"
%token TOK_U16 "'u16'"
%token TOK_I16 "'i16'"
%token TOK_U8 "'u8'"
%token TOK_I8 "'i8'"
%token TOK_VOID "'Void'"

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
				printf("struct definition");
			}
			;

member_list: member_decl
		   | member_list member_decl
		   ;

member_decl: TOK_U64 TOK_IDENT TOK_SEMICOLON { printf("Member decl"); }

%%

void yyerror(const char *str)
{
    fprintf(stderr, "urslcc: fatal: line %d: %s near '%s'\n", yylineno, str, yytext);
}
