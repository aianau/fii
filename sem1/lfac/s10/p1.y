%{
#include <stdio.h>
extern int yylineno;
%}
%start s
%token nr

%%
s   :   e {$$=$1; printf("regula s->e; valoarea expreisi = %d\n", $$);}
    ;
e   :   '(' e ')' {printf("regula e->(e) pt %d\n", $2);}
    |   e '*' e {$$=$1*$3; printf("regula e->e * e pt %d %d\n", $1, $3);}
    |   e e {$$=$1+$2; printf("regula e->e e pt %d %d\n", $1, $2);}
    |   nr {$$=$1; printf("e->%d\n", $1);}
    ;
%%

int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(){
    yyparse();
}