%{
#include <stdio.h>
int i=0;
%}
%%
infoiasi {i++; ECHO; printf("\n"); REJECT;}
inf {printf("INF");}
" "/" " printf(" ");
.|\n ;
%%
int main(int argc, char** argv ){
if(argc>0)
 yyin = fopen(argv[1],"r");
yylex();
printf("\n numarul de aparitii ale sirului infoiasi: %d\n",i);
}
