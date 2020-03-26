#!/bin/bash
gcc -Wall server.c -o server.o
if [ $? -ne 0 ]
then
    exit 1
fi
gcc -Wall -o3 client.c -o client.o
if [ $? -ne 0 ]
then
    exit 1
fi
chmod +x server.o
chmod +x client.o

cd ~/Desktop/FII2/RC/tema1/

gnome-terminal --title="Server" --geometry 73x31+2000+300 -- ./server.o 

let n=1;

if [ "$1" != "" ]; then
    let n=$1
fi


for (( i=1; i<=$1; i++ ))
do
    let y=(${i})*40+50
    gnome-terminal --title="Client${i}" --geometry 73x31+${y}+300  -- ./client.o 
done

exit 0