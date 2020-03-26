#!/bin/bash
if [ $# -ne 2 ] && [ $# -ne 1 ]
then
    echo 'usage: <file_name_without extension> [<input file>]'
    exit 1
fi

result=$(lex $1.l
        yacc -d $1.y
        gcc lex.yy.c y.tab.c y.tab.h -ll -ly -o $1.o
        chmod +x $1.o 2>&1)
if [ -n "$result" ]
then
  echo 'error at running' $0
  exit 1
fi

./$1.o $2 

