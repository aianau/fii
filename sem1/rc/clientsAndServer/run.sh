#!/bin/bash
cd ~/Desktop/fii2/rc/clientsAndServer/

# gcc -Wall server.c -o server.o | echo
# if [ $? -ne 0 ]
# then
#     exit 1
# fi
# gcc -Wall client.c -o client.o | echo
# if [ $? -ne 0 ]
# then
#     exit 1
# fi

make all

chmod +x server.o
chmod +x client.o


gnome-terminal --title="Server" --geometry 80x100+23600+400 -- ./server.o 9090 # default connection to port:9090

let n=1;

if [ $# -ne 0 ]; then
    let n=$1
fi


for (( i=1; i<=n; i++ ))
do
    let x=(${i})*40+60
    gnome-terminal --title="Client${i}" --geometry 80x100+${x}+300  -- ./client.o 127.0.0.1 9090 # default connection to local and port:9090
done

exit 0