/// ORIGINAL INCLUDES

// #include <errno.h> 
// #include <stdio.h> 
// #include <unistd.h>      
// #include <malloc.h>      
// #include <string.h>      
// #include <sys/socket.h>  
// #include <sys/types.h>
// #include <netinet/in.h>
// #include <arpa/inet.h>
// #include <resolv.h>      
// #include <netdb.h>       
// #include <openssl/ssl.h> 
// #include <openssl/err.h> 
// #include <unistd.h>      

/// MY INCLUDES

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

#define FAIL -1          
#define BUFFER 1024      

int OpenConnection(const char *hostname, int port)
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
    return sd;
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

void Show_certs(SSL *ssl) 
{
    X509 *cert;
    char *line;
    cert = SSL_get_peer_certificate(ssl); 
    if (cert != NULL)
    {
        printf("Server certificates:\n");
        line = X509_NAME_oneline(X509_get_subject_name(cert), 0, 0);
        printf("Subject: %s\n", line);
        free(line); 
        line = X509_NAME_oneline(X509_get_issuer_name(cert), 0, 0);
        printf("Issuer: %s\n", line);
        free(line);      
        X509_free(cert); 
    }
    else
        printf("Info: No client certificates configured.\n");
}
int main(int count, char *strings[]) 
{
    SSL_CTX *ctx;
    int server;
    SSL *ssl;
    char buf[1024];
    char input[BUFFER];
    int bytes;
    char *hostname, *portnum;
    pid_t cpid; 
    if (count != 3)
    {
        printf("usage: %s  \n", strings[0]);
        exit(0);
    }
    SSL_library_init(); 
    hostname = strings[1];
    portnum = strings[2];
    ctx = InitCTX();
    server = OpenConnection(hostname, atoi(portnum)); 
    ssl = SSL_new(ctx);                               
    SSL_set_fd(ssl, server);                          
    if (SSL_connect(ssl) == FAIL)                     
        ERR_print_errors_fp(stderr);
    else
    {
        printf("Connected with %s encryption\n", SSL_get_cipher(ssl));
        Show_certs(ssl);
        
        cpid = fork();
        
        if (cpid == 0)
        {
            while (1)
            {
                printf("\nMESSAGE TO SERVER:");
                fgets(input, BUFFER, stdin);
                SSL_write(ssl, input, strlen(input)); 
            }
        }
        else
        {
            while (1)
            {
                bytes = SSL_read(ssl, buf, sizeof(buf)); 
                if (bytes > 0)
                {
                    buf[bytes] = 0;
                    printf("\nMESSAGE FROM CLIENT: %s\n", buf);
                }
            }
        }
        SSL_free(ssl); 
    }
    close(server);     
    SSL_CTX_free(ctx); 
    return 0;
}