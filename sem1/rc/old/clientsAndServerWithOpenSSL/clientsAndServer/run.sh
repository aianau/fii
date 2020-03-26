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

if [ $# -ne 3 ]; then
    echo "Usage: ./run.sh <number_of_clients> <Ip_that_clients_connect_to> <Port_to_connect_to>"
    exit 1
fi

port="$3"
ip="$2"

gnome-terminal --title="Server" --geometry 80x100+23600+400 -- ./server.o ${port}

let n=$1;

for (( i=1; i<=n; i++ ))
do
    let x=(${i})*40+60
    gnome-terminal --title="Client${i}" --geometry 80x30+${x}+300  -- ./client.o ${ip} ${port}
done

exit 0