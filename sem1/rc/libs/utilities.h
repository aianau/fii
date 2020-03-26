#ifndef __UTILITIES_H__
#define __UTILITIES_H__

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/un.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>
#include <pwd.h>
#include <math.h>
#include <fcntl.h>
#include <time.h>
#include <resolv.h>      
#include <netdb.h>  
#include <errno.h>  

#include "macros.h"
#include "constants.h"

#include "rsa.h"
#include "sha256.h"


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
//                      NUMBER FUNCTIONS
///////////////////////////////////////////////////////

int IsPrime(int num);

////////////////////////////////////////////////////////
//                      INPUT/OUTPUT FUNCTIONS
///////////////////////////////////////////////////////

// @summary reads until EOF is read or before max_buffer_size bytes are read.
// Appends null terminator at the end of the string.
// @return number of bytes read
int Read_input_line(char *buff, int max_buffer_size);


// @return 0 if succeded.
int Sanitize_input(char *buff);



////////////////////////////////////////////////////////
//                      CONNECTION FUNCTIONS
///////////////////////////////////////////////////////

int Open_connection(const char *hostname, int port);

int Open_listener(int port);

////////////////////////////////////////////////////////
//                      MESSAGING FUNCTIONS
///////////////////////////////////////////////////////


// @return 0 on success
int Send_message(const char *message_param, int socket, struct public_key_class pub[1]);

// @return 0 on success
int Recv_message(char *message, int socket, struct private_key_class priv[1]);


#endif // __UTILITIES_H__