%{
#include <stdio.h>
#include "y.tab.h"
%}
%%
[1-9][0-9]* {
                yylval = atoi(yytext);
                return EXPR;
            }
[ \t] {;}
\n {yylineno++; return 0;}
. {return yytext[0];}

 
