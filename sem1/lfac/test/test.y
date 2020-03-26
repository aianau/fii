%{
#include <stdio.h>
extern FILE* yyin;
extern int yylineno;
extern int yylex();
extern int yyerror(char * syntaxError);
%}

%token NEW DICTTYPE CHARTYPE CHARVAL INTEGERTYPE ARRAYTYPE ID INTEGERVAL
%start s
%%

s: declaratii {printf ("Limbaj acceptat! Well done\n");}

declaratii  : declaratii declaratie
            | declaratie
            ;

declaratie  : NEW DICTTYPE ID '=' valoare_dict '.'
            | NEW CHARTYPE ID '=' valoare_char '.'
            | NEW INTEGERTYPE ID '=' valoare_integer '.'
            | NEW ARRAYTYPE ID '=' valoare_array '.'

valoare_dict    : '{' tuple '}'
                ;

tuple   : tuple ';' tuplu
        | tuplu
        |
        ;

tuplu   : cheie ':' valoare_generala
        ;

cheie   : ID
        ;

valoare_generala    : valoare_array
                    | valoare_char
                    | valoare_dict
                    | valoare_integer
                    ;

valoare_char    : CHARVAL  
                ;

valoare_integer : INTEGERVAL
                ;

valoare_array   : '[' valoare_array_interior ']'
                | '['']'
                ;

valoare_array_interior  : valoare_array_interior ',' valoare_generala
                        | valoare_generala
                        ;



%%
int yyerror(char * s){
 printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
 yyin=fopen(argv[1],"r");
 yyparse();
} 

