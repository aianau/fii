%{
#include <stdio.h>
#include "y.tab.h"
%}
%%
"int"|"float"|"char"|"string" {return TIP;}
"begin_progr" {return BGIN;}
"end_progr" {return END;}
@[_a-zA-Z][_a-zA-Z0-9]* {return ID;}
":=" {return ASSIGN;}
[+-]?[1-9][0-9]* {yylval=atoi(yytext);  return NR;}
[+]?[1-9][0-9]* {return NR_INT;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

 
