#include "../libs/utilities.h"

void Check_superuser(const char server_message){
    
}

int main(int argc, char *argv[])
{
    CHECK(argc == 3, -1, 
        "Wrong number of params. Params must be <IP_to_connect_to> <PORT_to_connect_to>");

    char *hostname, *portnum;    
    int network_socket;
    char server_message[BUFFER_SIZE];
    char client_message[BUFFER_SIZE];

    hostname = argv[1];
    portnum = argv[2];

    network_socket = Open_connection(hostname, atoi(portnum));    

    struct public_key_class pub_mine[1];
    struct private_key_class priv_mine[1];
    struct public_key_class pub_his[1];
    
    Rsa_gen_keys(pub_mine, priv_mine);
    printf("My Private Key:\n Modulus: %lld\n Exponent: %lld\n", (long long)priv_mine->modulus, (long long) priv_mine->exponent);
    CHECK(recv(network_socket, pub_his, sizeof(struct public_key_class), 0) != -1, -1, "Unable to receive public key from server!");
    printf("His Public Key:\n Modulus: %lld\n Exponent: %lld\n", (long long)pub_his->modulus, (long long) pub_his->exponent);
    CHECK(send(network_socket, pub_mine, sizeof(struct public_key_class), 0) != -1, -1, "Unable to send public key to server!");
    printf("My Public Key:\n Modulus: %lld\n Exponent: %lld\n", (long long)pub_mine->modulus, (long long) pub_mine->exponent);


    Recv_message(server_message, network_socket, priv_mine);

    do{
        Read_input_line(client_message, BUFFER_SIZE);
        Sanitize_input(client_message);

        Send_message(client_message, network_socket, pub_his);

        Recv_message(server_message, network_socket, priv_mine);
        
    }while (strcmp(client_message, "quit") != 0);
     

    close(network_socket);
    return 0;
}



