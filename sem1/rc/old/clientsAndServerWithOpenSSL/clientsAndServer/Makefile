CFLAGS = -Wall
CC = gcc
LIBS_PATH = -L/usr/lib
LDLIBS = $(LIBS_PATH)-lm -lssl -lcrypto
DEPENDS = ../libs/rsa.c ../libs/sha256.c ../libs/utilities.c

.PHONY: clean, all

all: client server

client: client.c $(DEPENDS)
	$(CC) $(CFLAGS) $(DEPENDS) client.c -o client.o  $(LDLIBS)

server: server.c $(DEPENDS)
	$(CC) $(CFLAGS) $(DEPENDS) server.c -o server.o $(LDLIBS)

#  gcc -Wall ../libs/rsa.c ../libs/sha256.c ../libs/utilities.c server.c -o server.o -L/usr/lib -lm -lssl -lcrypto

clean:
	rm -f *.o 

