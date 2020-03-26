%{
int yylineno;
%}
%%
a printf("%4d  ana\t\n", ++yylineno);
%%
int main(int argc, char *argv[]) {
 yyin = fopen(argv[1], "r");
 yylex();
 fclose(yyin);
}
