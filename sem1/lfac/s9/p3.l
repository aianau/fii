%{
#include <stdio.h>
    int app = 0;
%}
%x name

name [A-Z][a-z]+

%%
[A-Z] {printf("*"); BEGIN name;}
<name>[^ \n\t] {printf("*");}
<name>[ \n\t] {printf(" "); BEGIN 0;}
.|\n ECHO;

%%
int main(int argc, char *argv[]){
    
    yyin = fopen(argv[1], "r");
    if (yyin == NULL){
        printf("error at opening the file\n");
        return 1;
    }
    yylex();
    return 0;
}
