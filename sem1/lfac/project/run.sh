#!/bin/bash
if [ $# -ne 0 ]
then
    echo 'usage: ./run.sh'
    exit 1
fi

result=$(
        # yacc -d -v project.ypp -o ya.cc 
        # lex project.l
        # cc -c lex.yy.c -o lex.yy.o
        # g++ -c ya.cc -o yac.o
        # g++ -o project.o lex.yy.o yac.o
        # chmod +x project.o
        
        yacc -d --verbose project.ypp
        flex project.l
        g++ -g -rdynamic -std=c++11 y.tab.c lex.yy.c -o project.o -ll -ly
        )


if [ -n "$result" ]
then
  echo 'error at running' $0
  exit 1
fi

./project.o test_input.txt

