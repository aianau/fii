%{
#include <stdio.h>
extern FILE* yyin;

#define __DEBUG__

#ifdef __DEBUG__
#define LOG(...)\
{\
    printf("[DBG] " __VA_ARGS__);\
    printf("\n");\
}
#endif //!__DEBUG__
%}

%start calculator
%token EXPR

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS

%%
calculator  :   expr
            {
                $$ = $1;
                LOG("result = %d", $$);
            }
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
        |   EXPR     
                {
                    LOG("expr -> %d", $1);
                    $$ = $1;
                }
        ;

%%
int main(int argc, char** argv){
    if (argc == 2) {
        yyin=fopen(argv[1],"r");
    }
    yyparse();
} 
