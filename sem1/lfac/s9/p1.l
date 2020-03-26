%{
%}

cifra [0-9]
numar [+-]?[1-9]([0-9])*
litera [a-zA-Z]
cuvant {litera}+

%%
^{numar}/[\n ] {ECHO; printf("\n");}
{numar}/[\n ] {ECHO; printf("\n");}
^{cuvant}/[\n ] {ECHO; printf("\n");}
{cuvant}/[\n ] {ECHO; printf("\n");}
.|\n ;
%%
int main(int argc, char *argv[]) {
yyin = fopen(argv[1], "r");
yylex();
fclose(yyin);
}
