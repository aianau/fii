%{
#include <stdio.h>
%}
cifra [0-9]
cifra_para [02468]
nr {cifra}+
nr_par {cifra}*{cifra_para}
lista_nr_pare {nr_par}(,{nr_par})*
lista_para ({nr},{nr},)*{nr},{nr}


%%
\<{lista_para}\> {ECHO;}
.|\n|\t ;  


%%
int main(int argc, char** argv){
FILE *g;
if(argc>0)
 yyin = fopen(argv[1],"r");

/*if(!(g = fopen("out.txt","w")))
    fprintf(stderr,"eroare creare fisier!");
else
 yyout=g; */

yylex();

}



