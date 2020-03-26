%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%
"/*"(.|\n|\r)+"*/" ;
"new" {return NEW;}
"Dict" {return DICTTYPE;}
\"[^\"]+\" {return CHARVAL;}
"Array" {return ARRAYTYPE;}
"CharArray" {return CHARTYPE;}
"Integer" {return INTEGERTYPE;}
[A-Za-z][A-Za-z0-9]* {return ID;}
[+-]?[1-9][0-9]*|0 {return INTEGERVAL;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
