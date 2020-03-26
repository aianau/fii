%{
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "y.tab.h"

%}

%%
    /* TYPES */
"bool" {yylval.union_value_string = strdup(yytext);  return TYPE_BOOL; }
"int" {yylval.union_value_string = strdup(yytext);  return TYPE_INT;}
"float" {yylval.union_value_string = strdup(yytext);  return TYPE_FLOAT;}
"char" {yylval.union_value_string = strdup(yytext);  return TYPE_CHAR;}
"string" {yylval.union_value_string = strdup(yytext);  return TYPE_STRING; }
"let" {yylval.union_value_string = strdup(yytext);  return TYPE_USER_DEFINED; }
"array" {yylval.union_value_string = strdup(yytext);  return TYPE_ARRAY; }
"func" {yylval.union_value_string = strdup(yytext);  return TYPE_FUNC; }
[a-z][_a-z]* {yylval.union_value_string = strdup(yytext);  return ID_OBJ; REJECT;}

    /* HELPERS */
";" {return SEMICOLON;}

    /* VARIABLES */
@[_a-zA-Z][_a-zA-Z0-9]* {yylval.union_value_string = strdup(yytext);   return ID;}

    /* OPERATORS */
"=" {return OPERATOR_ASSIGN;}
"==" {return OPERATOR_EQUAL;}
"&&" {return OPERATOR_AND;}
"||" {return OPERATOR_OR;}
"+" {return OPERATOR_PLUS;}
"-" {return OPERATOR_MINUS;}
"*" {return OPERATOR_MULTIPLY;}
"/" {return OPERATOR_DIVIDE;}
"%" {return OPERATOR_MOD;}

    /* CONTROL OPERATORS */
"if" {return OPERATOR_CONTROL_IF;}
"else" {return OPERATOR_CONTROL_ELSE;}
"while" {return OPERATOR_CONTROL_WHILE;}



    /* VALUES */
[+-]?(0|[1-9][0-9]*)"."[0-9]+ {yylval.union_value_float = atof(yytext); return VALUE_FLOAT_CONST; REJECT;}
[+]?(0|[1-9][0-9]*)"."[0-9]+ {yylval.union_value_float = atof(yytext); return VALUE_FLOAT_POZ_CONST; REJECT;}
[+-]?(0|[1-9][0-9]*) {yylval.union_value_int = atoi(yytext); return VALUE_INT_CONST;}
[+]?(0|[1-9][0-9]*) {yylval.union_value_int = atoi(yytext); return VALUE_INT_POZ_CONST;}
\"[^"]*\" {yylval.union_value_string = strdup(yytext); return VALUE_STRING_CONST;}
[a-zA-Z] {yylval.union_value_char = *yytext; return VALUE_CHAR_CONST;}
'true'|'false' { yylval.union_value_bool = strdup(yytext); return VALUE_BOOL_CONST;}
'Eval' {return EVAL;}

    /* WHITE SPACES / MISCELANEOUS */
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
