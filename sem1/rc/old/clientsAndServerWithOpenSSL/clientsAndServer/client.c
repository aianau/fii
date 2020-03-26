#include "../libs/utilities.h"

int Recv_download(SSL *ssl)
{
    char client_message[BUFFER_SIZE];

    do
    {
        Recv_message(client_message, ssl);

    }while(strcmp(client_message, "IAN_DOWNLOAD_FINISED!@#") != 0);
    
    return 0;
}


int main(int count, char *strings[]) 
{
    CHECK(count == 3, -1, 
        "Wrong number of params. Params must be <IP_to_connect_to> <PORT_to_connect_to>");

    SSL_CTX *ctx;
    SSL *ssl;
    char *hostname, *portnum;
    int network_socket;
    char server_message[BUFFER_SIZE];
    char client_message[BUFFER_SIZE];

    char command[BUFFER_SIZE];    
    char args[MAX_ARGS][BUFFER_SIZE];

    hostname = strings[1];
    portnum = strings[2];

    SSL_library_init();
    ctx = InitCTX();
    Load_certificates(ctx, "client_cert.pem", "client_cert.pem");
    network_socket = Open_connection(hostname, atoi(portnum));
    ssl = SSL_new(ctx);
    SSL_set_fd(ssl, network_socket);
    CHECK(SSL_connect(ssl) != FAIL, -1, "Unable to ssl connect");                    
    LOG("Connected with %s encryption",, SSL_get_cipher(ssl));
    Show_certs(ssl);
    
    do{
        memset(client_message, 0, BUFFER_SIZE);
        memset(server_message, 0, BUFFER_SIZE);

        Read_input_line(client_message, BUFFER_SIZE);
        Sanitize_input(client_message);

        Send_message(client_message, ssl);

        Parse_input(client_message, command, args);        
        
        if (strcmp(command, "download"))
        {
            Recv_download(ssl);
            continue;
        }

        Recv_message(server_message, ssl);

    }while (strcmp(client_message, "quit") != 0);
     
    SSL_free(ssl); 
    close(network_socket);
    SSL_CTX_free(ctx);

    return 0;
}



