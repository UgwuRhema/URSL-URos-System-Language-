%{
#include <stdio.h>
#include "parser.h"
%}

%option noyywrap
%option yylineno

%%

"u64" { return TOK_U64; }
"u32" { return TOK_U32; }
"i64" { return TOK_I64; }
"i32" { return TOK_I32; }
"u16" { return TOK_U16; }
"i16" { return TOK_I16; }
"i8" { return TOK_I8; }
"u8" { return TOK_U8; }
"vd" { return TOK_VOID; }

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
