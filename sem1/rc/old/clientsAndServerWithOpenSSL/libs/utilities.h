#ifndef __UTILITIES_H__
#define __UTILITIES_H__

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/un.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <dirent.h>
#include <pwd.h>
#include <math.h>
#include <fcntl.h>
#include <time.h>
#include <openssl/ssl.h> 
#include <openssl/err.h> 
#include <resolv.h>      
#include <netdb.h>       

#include "rsa.h"
#include "sha256.h"

////////////////////////////////////////////////////////
//                      CONSTANTS
///////////////////////////////////////////////////////

#define PORT_NUMBER 9090
#define INVALID_ADDRESS 0

#define PIPE_READ 0
#define PIPE_WRITE 1

#define READ_CHANNEL 0
#define WRITE_CHANNEL 1

#define SOCKET_NAME "/tmp/9Lq7BNBnBycd6nxy.socket"
#define BUFFER_SIZE 1024

#define TRUE 1
#define FALSE 0

#define VALID 0
#define FAIL -1

#define MAX_CONNECTIONS_ALLOWED 10
#define MAX_ARGS 10

#define ARGS_INDEX_USERNAME 0
#define ARGS_INDEX_PASSWORD 1
#define ARGS_INDEX_FILE 0

#define AUTHENTICATED 0

#define AUTH_SUCCESS 0
#define AUTH_FAILED_USER 2
#define AUTH_FAILED_PASSWORD 1

////////////////////////////////////////////////////////
//                      MACROS
///////////////////////////////////////////////////////

#define LOG(format, ...)                        \
    {                                           \
        printf("[" format "]\n" __VA_ARGS__); \
    }

#define CHECK(c, ret, ...)   \
    if (!(c))                \
    {                        \
        printf(__VA_ARGS__); \
        printf("\n");        \
        return ret;          \
    }

#define CHECKSHOW(c, ...)    \
    if (!(c))                \
    {                        \
        printf(__VA_ARGS__); \
        printf("\n");        \
    }

#define CHECKNOTNULL(ptr, ret)                  \
    if (ptr == NULL)                            \
    {                                           \
        printf("Expected not null poitner!\n"); \
        return ret;                             \
    }

#define CHECKEXIT(c, exit_code, ...) \
    if (!(c))                        \
    {                                \
        printf(__VA_ARGS__);         \
        perror(__VA_ARGS__);         \
        exit(exit_code);             \
    }

#define PIPE(p)                                                                    \
    {                                                                              \
        CHECK(pipe(p) != -1, -1, "Unable to create pipe for pid: %d\n", getpid()); \
    }

#define FORK(pid)                                                   \
    {                                                               \
        pid = fork();                                               \
        CHECK(pid != -1, -1, "Unable to fork pid: %d\n", getpid()); \
    }

#define DUP(oldfd, newfd)                                                                                   \
    {                                                                                                       \
        CHECK((newfd = dup(oldfd)) == 0, -1, "Unable to duplicate fd: %d, for pid: %d\n", oldfd, getpid()); \
    }

#define DUPSIMPLE(fd)                                                                              \
    {                                                                                              \
        CHECK(dup(fd) == 0, -1, "Unable to duplicate simply fd: %d, for pid: %d\n", fd, getpid()); \
    }

#define CLOSE(fd)                                                                          \
    {                                                                                      \
        CHECK(close(fd) != -1, -1, "Unable to close fd: %d, for pid: %d\n", fd, getpid()); \
    }

#define SOCKETPAIR(domain, type, protocol, fds_pointer)                                                     \
    {                                                                                                       \
        CHECK(socketpair(domain, type, protocol, fds_pointer) >= 0, -1, "Unable to create socket pair.\n"); \
    }

////////////////////////////////////////////////////////
//                      STRUCTS
///////////////////////////////////////////////////////

struct Client
{
    int socket;
    char username[BUFFER_SIZE];
    struct sockaddr_in address;
};

////////////////////////////////////////////////////////
//                       FUNCTIONS
///////////////////////////////////////////////////////

int isRoot(); 

int IsPrime(int num);

// @summary reads until EOF is read or before max_buffer_size bytes are read.
// Appends null terminator at the end of the string.
// @return number of bytes read
int Read_input_line(char *buff, int max_buffer_size);
// @return 0 if succeded.
int Sanitize_input(char *buff);
// @return 0 if succeded.
int Parse_input(const char *client_message, char *command, char args[MAX_ARGS][BUFFER_SIZE]);


// @return 0 on success
int Send_message(const char *message, SSL *ssl);
// @return 0 on success
int Recv_message(char *message, SSL *ssl);

int Open_connection(const char *hostname, int port);
int Open_listener(int port);

SSL_CTX *InitServerCTX(void);
SSL_CTX *InitCTX(void);
void Load_certificates(SSL_CTX *ctx, char *CertFile, char *KeyFile);
void Show_certs(SSL *ssl);

#endif // __UTILITIES_H__