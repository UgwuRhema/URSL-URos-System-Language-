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

%token TOK_STRUCT "'%struc'"
%token <str> TOK_IDENT "'identifier'"
%token <num> TOK_NUM  "'number'"
%token TOK_LBRACE "'{'" 
%token TOK_RBRACE "'}'"
%token TOK_LPAREN "'('"
%token TOK_RPAREN "')'"
%token TOK_SEMICOLON "';'"
%token TOK_ASSIGN "'='"
%token TOK_ASTERISK "'*'"
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
				printf("struct definition\n");
			}
			;

member_list: member_decl
		   | member_list member_decl
		   ;

member_decl: TOK_IDENT TOK_U64 TOK_SEMICOLON { printf("Member decl\n"); }
		   | TOK_IDENT TOK_U8 TOK_SEMICOLON { printf("Member decl\n"); }
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
