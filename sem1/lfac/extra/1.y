%{
#include <stdio.h>
extern FILE* yyin;
extern int yylineno;
extern int yylex();
extern int yyerror(char * syntaxError);
%}

%token TGR ETGR TSTUD ETSTUD TNUME ETNUME TOB ETOB TPROM ETPROM TNPROM ETNPROM TNOTA ETNOTA NUME NOTA NUME_MATERIE
%start s
%%

s   : grupe {printf("input acceptat\n");}
    ; 

grupe   : TGR studenti ETGR grupe 
        | TGR studenti ETGR
        ;

studenti    : TSTUD nume prom neprom ETSTUD studenti
            | TSTUD nume prom neprom ETSTUD
            ;
    
nume: TNUME numee ETNUME
    ;

numee   : NUME numee
        | NUME
        ;

prom    : TPROM obiecte_promovate ETPROM
        | 
        ;

obiecte_promovate   : TOB obiect_promovat ETOB obiecte_promovate
                    | TOB obiect_promovat ETOB
                    ;

obiect_promovat     : TNUME NUME_MATERIE ETNUME  TNOTA NOTA ETNOTA
                    | TNUME NUME_MATERIE ETNUME
                    ;

neprom  : TNPROM obiecte_nepromovate ETNPROM
        |
        ;

obiecte_nepromovate : TOB obiect_nepromovat ETOB obiecte_nepromovate
                    | TOB obiect_nepromovat ETOB
                    ;

obiect_nepromovat   : TNUME NUME_MATERIE ETNUME
                    ;


%%
int yyerror(char * s){
 printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
 yyin=fopen(argv[1],"r");
 yyparse();
} 
