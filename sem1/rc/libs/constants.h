#ifndef __CONSTANTS_H__
#define __CONSTANTS_H__

////////////////////////////////////////////////////////
//                      CONSTANTS
///////////////////////////////////////////////////////

#define PORT_NUMBER 9090
#define INVALID_ADDRESS 0

#define PIPE_READ 0
#define PIPE_WRITE 1

#define READ_CHANNEL 0
#define WRITE_CHANNEL 1

#define BUFFER_SIZE 1024*5
#define BUFFER_SIZE_1024 1024


#define TRUE 1
#define FALSe 0

#define VALID 0

#define MAX_CONNECTIONS_ALLOWED 10
#define MAX_ARGS 10
#define MAX_NUMBER_PRIMES 3517


#define ARGS_INDEX_USERNAME 0
#define ARGS_INDEX_PASSWORD 1
#define ARGS_INDEX_FILE 0

#define AUTHENTICATED 0

#define AUTH_SUCCESS 0
#define AUTH_FAILED_USER 2
#define AUTH_FAILED_PASSWORD 1

#define PRIMES_FILE "primes.pr"


#endif //! __CONSTANTS_H__