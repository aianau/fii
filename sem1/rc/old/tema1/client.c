#include "../utilities.h"


int main(){
    int network_socket;
    char server_message[BUFFER_SIZE];
    char client_message[BUFFER_SIZE];
    // int server_message_size = 0;
    // int client_message_size = 0;

    CHECK((network_socket = socket(AF_INET, SOCK_STREAM, 0)) >= 0, 1, "Unable to create socket!");

    // specifying the address to which to connect;
    struct sockaddr_in server_address;
    server_address.sin_family = AF_INET;
    server_address.sin_addr.s_addr = INADDR_ANY;
    server_address.sin_port = htons(9090);


    CHECK(connect(network_socket, (struct sockaddr*)(&server_address), sizeof(server_address)) == 0, 2, "Unable to connect properly!");
    LOG("connected");
    Recv_message(server_message, network_socket);
    do{
        Read_input_line(client_message, BUFFER_SIZE);
        Sanitize_input(client_message);

        Send_message(client_message, network_socket);

        Recv_message(server_message, network_socket);
    }while (strcmp(client_message, "quit") != 0);
     

    close(network_socket);
    return 0;
}



