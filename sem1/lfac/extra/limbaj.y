%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
extern yyerror;
#define __DEBUG__

#ifdef __DEBUG__
#define LOG(...)\
{\
    printf("[DBG] " __VA_ARGS__);\
    printf("\n");\
}
#endif //!__DEBUG__

%}
%token ID TIP BGIN END ASSIGN NR  NR_INT
%start progr

%left '+' '-'
%left '*' '/' '%'
%left UMINUS



%%
progr: declaratii bloc {printf("program corect sintactic\n");}
     ;

declaratii :  declaratie ';'
	   | declaratii declaratie ';'
	   ;
declaratie  : TIP ID 
            | TIP ID '[' expr ']'
            | TIP ID '(' lista_param ')'
            | TIP ID '(' ')'
            ;
lista_param : param
            | lista_param ','  param 
            ;
            
param   : TIP ID
        | TIP ID '['expr']'
        ; 
      
/* bloc */
bloc : BGIN list END  
     ;
     
/* lista instructiuni */
list :  statement ';' 
     | list statement ';'
     ;

/* instructiune */
statement: ID ASSIGN ID
         | ID ASSIGN expr  		 
         | ID '(' lista_apel ')'
         ;
        
lista_apel : NR
           | lista_apel ',' NR
           ;

expr    :   '(' expr ')' 
                {
                    LOG("expr = (%d)", $2);
                    $$ = $2;
                }
        |   expr '+' expr
                {
                    LOG("expr = %d + %d", $1, $3);
                    $$ = $1 + $3;
                }
        |   expr '*' expr 
                {
                    LOG("expr = %d * %d", $1, $3);
                    $$ = $1 * $3;
                }
        |   '-' expr        %prec UMINUS
                {
                    LOG("expr = -%d", $2);
                    $$ = -$2;
                }
        |   NR     
                {
                    LOG("expr -> %d", $1);
                    $$ = $1;
                }
        ;

%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();

} 