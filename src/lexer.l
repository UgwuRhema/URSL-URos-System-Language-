%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.h"
#include "types.h"
%}

%option noyywrap
%option yylineno

%%

"u64" { yylval.kind = TY_U64; return TOK_PRIM_TYPE; }
"i64" { yylval.kind = TY_I64; return TOK_PRIM_TYPE; }
"u32" { yylval.kind = TY_U32; return TOK_PRIM_TYPE; }
"i32" { yylval.kind = TY_I32; return TOK_PRIM_TYPE; }
"u16" { yylval.kind = TY_U16; return TOK_PRIM_TYPE; }
"i16" { yylval.kind = TY_I16; return TOK_PRIM_TYPE; }
"u8"  { yylval.kind = TY_U8;  return TOK_PRIM_TYPE; }
"i8"  { yylval.kind = TY_I8;  return TOK_PRIM_TYPE; }
"vd"  { yylval.kind = TY_VOID; return TOK_PRIM_TYPE; }

"%struc" {
	return TOK_STRUCT;
}

[0-9]+ {
    yylval.num = atoi(yytext);
    return TOK_NUM;
}
[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext);
    return TOK_IDENT;
}
"{" { return TOK_LBRACE; }
"}" { return TOK_RBRACE; }
"(" { return TOK_LPAREN; }
")" { return TOK_RPAREN; }
";" { return TOK_SEMICOLON; }
"=" { return TOK_ASSIGN; }
"*" { return TOK_ASTERISK; }
":" { return TOK_COLON; }
[ \t\r\n]+ { /* skip whitespace */ }
"//".* { /* skip single line comments */ }

. { fprintf(stderr, "urslc: fatal: unknown '%s'\n", yytext); }

%%
