letter [A-Za-z]
digit [0-9]
%{
int count;
%}
%%
{letter}({letter}|{digit})* {count++;}
.|\n|\t {}
%%
int main(int argc, char *argv[]) {
yyin = fopen(argv[1], "r");
yylex();
fclose(yyin);
printf("number of identifiers = %d\n", count);
return 0;
}
