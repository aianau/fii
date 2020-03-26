%{
#include <stdio.h>
#include "y.tab.h"
%}
%%
[0-9]*"."[0-9]+ {yylval.floatval = atof(yytext); return NR_FLOAT;}
[0-9]+ {yylval.intval = atoi(yytext); return NR_INT;}
[a-zA-Z]+ {yylval.strval = strdup(yytext); return STRING; }

[\t ] {;}
\n {yylineno++; return 0;}
. {return yytext[0];}
