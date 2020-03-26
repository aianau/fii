%{
#include <stdio.h>
#include "y.tab.h"
/*int yylineno = 0;*/
%}
%option noyywrap
id [a-zA-Z][a-zA-Z0-9]*
%%
"/*"(.|\n)+"*/" ;
"<"grupa[ ]+id={id}">" {return TGR;}
"</grupa>" {return ETGR;}
"<student>" {return TSTUD;}
"</student>" {return ETSTUD;}
"<nume>" {return TNUME;}
"</nume>" {return ETNUME;}
"<obiect>" {return TOB;}
"</obiect>" {return ETOB;}
"<promovate>" {return TPROM;}
"</promovate>" {return ETPROM;}
"<nepromovate>" {return TNPROM;}
"</nepromovate>" {return ETNPROM;}
"<nota>" {return TNOTA;}
"</nota>" {return ETNOTA;}
[A-Z][a-z]* {return NUME;}
[A-Z]+ {return NUME_MATERIE;}
[0-9]|10 {return NOTA;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

 

