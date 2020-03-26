#include "utilities.h"


////////////////////////////////////////////////////////
//                      CONTEXT FUNCTIONS
///////////////////////////////////////////////////////


int isRoot()
{
    if (getuid() != 0)
    {
        return 0;
    }
    else
    {
        return 1; 
    }
}


////////////////////////////////////////////////////////
//                      NUMBER FUNCTIONS
///////////////////////////////////////////////////////

int IsPrime(int num)
{
    if (num < 2)
        return 0;
    for (int i = 2; i < num / 2; ++i)
    {
        if (num % i == 0)
            return 0;
    }
    return 1;
}

////////////////////////////////////////////////////////
//                      INPUT/OUTPUT FUNCTIONS
///////////////////////////////////////////////////////

// @summary reads until EOF is read or before max_buffer_size bytes are read.
// Appends null terminator at the end of the string.
// @return number of bytes read
int Read_input_line(char *buff, int max_buffer_size)
{
    printf("[input]");
    char c;
    int count_read = 0;
    while (count_read < max_buffer_size && ((c = getchar()) != EOF && c != '\n'))
    {
        count_read++;
        *(buff) = c;
        buff++;
    }
    *(buff) = 0;
    return count_read;
}

// @return 0 if succeded.
int Sanitize_input(char *buff)
{
    int index = 0;
    int index_copier = 0;
    while (buff[index] == ' ')
    {
        index_copier = index;
        while (buff[index_copier] != 0)
        {
            buff[index_copier] = buff[index_copier + 1];
            index_copier++;
        }
    }

    while (buff[index] != 0)
    {
        while (buff[index] == ' ' && buff[index + 1] == ' ')
        {
            index_copier = index;
            while (buff[index_copier] != 0)
            {
                buff[index_copier] = buff[index_copier + 1];
                index_copier++;
            }
        }
        index++;
    }

    if (buff[index - 1] == ' ')
    {
        buff[index - 1] = 0;
    }

    // transform to lower case.
    return 0;
}


// @return 0 if succeded.
int Parse_input(const char *client_message, char *command, char args[MAX_ARGS][BUFFER_SIZE])
{
    memset(args, 0, MAX_ARGS * BUFFER_SIZE);
    int index_parser = 0;
    int number_args = 0;
    while (client_message[index_parser] != ' ' && client_message[index_parser] != 0)
    {
        command[index_parser] = client_message[index_parser];
        index_parser++;
    }
    command[index_parser] = 0;

    while (client_message[index_parser] != 0 && number_args < MAX_ARGS)
    {
        while (client_message[index_parser] == ' ' && client_message[index_parser] != 0)
        {
            index_parser++;
        }

        int index_arg = 0;
        while (client_message[index_parser] != ' ' && client_message[index_parser] != 0)
        {
            args[number_args][index_arg] = client_message[index_parser];
            index_arg++;
            index_parser++;
        }
        args[number_args][index_arg] = 0;
        number_args++;
    }
    return 0;
}


////////////////////////////////////////////////////////
//                      CONNECTION FUNCTIONS
///////////////////////////////////////////////////////

int Open_connection(const char *hostname, int port)
{
    int sd;
    struct hostent *host;
    struct sockaddr_in addr; 
    if ((host = gethostbyname(hostname)) == NULL)
    {
        perror(hostname);
        abort();
    }
    sd = socket(AF_INET, SOCK_STREAM, 0); 
    bzero(&addr, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = *(long *)(host->h_addr_list[0]);
    if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)) != 0) 
    {
        close(sd);
        perror(hostname);
        abort();
    }
    LOG("connection openned");
    return sd;
}

int Open_listener(int port)
{
    int sd;
    struct sockaddr_in addr; 
    sd = socket(PF_INET, SOCK_STREAM, 0);
    bzero(&addr, sizeof(addr));  
    addr.sin_family = AF_INET;   
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = INADDR_ANY;
    if (bind(sd, (struct sockaddr *)&addr, sizeof(addr)) != 0) 
    {
        perror("can't bind port"); 
        abort();                   
    }
    if (listen(sd, 10) != 0) 
    {
        perror("Can't configure listening port"); 
        abort();                                  
    }
    LOG("listening");
    return sd;
}



////////////////////////////////////////////////////////
//                      MESSAGING FUNCTIONS
///////////////////////////////////////////////////////


// @return 0 on success
int Send_message(const char *message_param, SSL *ssl)
{
    int message_size = 0;
    char message[BUFFER_SIZE];
    strcpy(message, message_param);
    message_size = strlen(message);

    message_size = strlen(message);
    SSL_write(ssl, &message_size, sizeof(int));
    SSL_write(ssl, message, message_size);
    printf("[sent] %s\n", message); 

    return 0;
}

// @return 0 on success
int Recv_message(char *message, SSL *ssl)
{
    int message_size = 0;

    CHECKSHOW(SSL_read(ssl, &message_size, sizeof(int)) > 0, "Did not read >0 bytes"); 
    CHECKSHOW(SSL_read(ssl, message, message_size) > 0, "Did not read >0 bytes"); 
    message[message_size] = 0; 
    printf("[recv] %s\n", message); 

    return 0;
}


////////////////////////////////////////////////////////
//                      SSL FUNCTIONS
///////////////////////////////////////////////////////


SSL_CTX *InitServerCTX(void) 
{
    SSL_METHOD *method;
    SSL_CTX *ctx;
    OpenSSL_add_all_algorithms();     
    SSL_load_error_strings();         
    method = TLSv1_2_server_method(); 
    ctx = SSL_CTX_new(method);        
    if (ctx == NULL)
    {
        ERR_print_errors_fp(stderr);
        abort();
    }
    return ctx;
}

SSL_CTX *InitCTX(void) 
{
    SSL_METHOD *method;
    SSL_CTX *ctx;
    OpenSSL_add_all_algorithms();     
    SSL_load_error_strings();         
    method = TLSv1_2_client_method(); 
    ctx = SSL_CTX_new(method);        
    if (ctx == NULL)
    {
        ERR_print_errors_fp(stderr);
        abort();
    }
    return ctx;
}

void Load_certificates(SSL_CTX *ctx, char *CertFile, char *KeyFile) 
{
    
    if (SSL_CTX_use_certificate_file(ctx, CertFile, SSL_FILETYPE_PEM) <= 0)
    {
        ERR_print_errors_fp(stderr);
        abort();
    }
    
    if (SSL_CTX_use_PrivateKey_file(ctx, KeyFile, SSL_FILETYPE_PEM) <= 0)
    {
        ERR_print_errors_fp(stderr);
        abort();
    }
    
    if (!SSL_CTX_check_private_key(ctx))
    {
        fprintf(stderr, "Private key does not match the public certificate\n");
        abort();
    }
}

void Show_certs(SSL *ssl)
{
    X509 *cert;
    char *line;
    cert = SSL_get_peer_certificate(ssl);
    if (cert != NULL)
    {
        LOG("Certificates:");
        line = X509_NAME_oneline(X509_get_subject_name(cert), 0, 0);
        printf("Server: %s\n", line); 
        free(line);
        line = X509_NAME_oneline(X509_get_issuer_name(cert), 0, 0);
        printf("client: %s\n", line);
        free(line);
        X509_free(cert);
    }
    else
        LOG("No certificates.");
}





