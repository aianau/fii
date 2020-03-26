%{
#include <stdio.h>
#include "y.tab.h"
%}
nr [+-][1-9][0-9]*

%%
{nr}    {yylval = atoi(yytext); return nr;}
[ \t]   ;
\n      {return 0;}
.       {return yytext[0];}
