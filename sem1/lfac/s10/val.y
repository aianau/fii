%{
#include <stdio.h>
#include <string.h>

#define __DEBUG__

#define LOG

#ifdef __DEBUG__
#define LOG(...)\
{\
    printf("[DBG] " __VA_ARGS__);\
    printf("\n");\
}
#endif //!__DEBUG__


%}
%start s
%union 
    {
        int intval;
        char* strval;
        float floatval;
    }
%token <strval>STRING 
%token <intval>NR_INT
%token <floatval>NR_FLOAT

%type <intval>expr_int
%type <strval>str
%type <floatval>expr_float
%left '+'

%%
s   : expr_int {printf("s-a recunoscut valoarea numerica=%d\n",$<intval>$);}
    | expr_float {LOG("s-a recunoscut valoarea numerica=%f", $<floatval>$);}
    | str  {printf("s-a recunoscut sirul=%s\n",$<strval>$);}
    ;
expr_int    : expr_int '+' expr_int  {$$=$1+$3;}
            | NR_INT {$$=$1;}
            ;  
expr_float  : '(' expr_float ')'
                {
                    $$ = $2; 
                }
            | expr_float '+' expr_float
                {
                    $$ = $1 + $3;
                }
            | expr_float '+' expr_int
                {
                    $$ = (float)$1 + (float)$3;
                }
            | expr_int '+'  expr_float
                {
                    $$ = (float)$1 + (float)$3;
                }
            | NR_FLOAT
                {
                    $$ = $1;
                }
            ;

str :  str '+' str  
        {   
			char* s=strdup($1);
                        strcat(s,$3);
			$$=s;
        }   
    | STRING {$$=strdup($1);}
    ; 			 
%%
int main(){
 yyparse();
}    
