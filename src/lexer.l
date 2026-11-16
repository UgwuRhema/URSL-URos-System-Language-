%{
#include <stdio.h>
#include "parser.h"
%}

%option noyywrap
%option yylineno

%%

"struct" {
	return STRUCT_TOK;
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
":" { return TOK_COLON; }
[ \t\r\n]+ { /* skip whitespace */ }
"//".* { /* skip single line comments */ }

. { fprintf(stderr, "urslc: fatal: unknown '%s'\n", yytext); }

%%
