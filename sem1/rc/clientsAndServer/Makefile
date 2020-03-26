CFLAGS = -Wall
CC = gcc
LIBS_PATH = -L.
LDLIBS = $(LIBS_PATH)-lm
DEPENDS = ../libs/rsa.c ../libs/sha256.c ../libs/utilities.c

.PHONY: clean, all

all: client server


client: client.c $(DEPENDS)
	$(CC) $(CFLAGS) $(DEPENDS) client.c -o client.o

server: server.c $(DEPENDS)
	$(CC) $(CFLAGS) $(DEPENDS) server.c -o server.o

clean:
	rm -f *.o 

