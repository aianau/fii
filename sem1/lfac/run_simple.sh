#!/bin/bash
if [ $# -ne 2 ] && [ $# -ne 1 ]
then
    echo 'usage: <file_name_without extension> [<input file>]'
    exit 1
fi

lex $1.l
cc lex.yy.c -o $1.o -ll
chmod +x $1.o
./$1.o $2
