#include "utilities.h"

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
    printf("[input:]");
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

////////////////////////////////////////////////////////
//                      CONNECTION FUNCTIONS
///////////////////////////////////////////////////////

int Open_connection(const char *hostname, int port)
{
    int sd;
    struct hostent *host;
    struct sockaddr_in addr;
    CHECK((host = gethostbyname(hostname)) != NULL, -1, "Unable to gethost by name for: %s", hostname);
    sd = socket(AF_INET, SOCK_STREAM, 0);
    bzero(&addr, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = *(long *)(host->h_addr_list[0]);
    CHECK(connect(sd, (struct sockaddr *)&addr, sizeof(addr)) == 0, -1, "Unable to connect");
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
    CHECK(bind(sd, (struct sockaddr *)&addr, sizeof(addr)) == 0, -1, "Unable to bind");
    CHECK(listen(sd, MAX_CONNECTIONS_ALLOWED) == 0, -1, "Unable to setup listener");
    LOG("listening");
    return sd;
}

////////////////////////////////////////////////////////
//                      MESSAGING FUNCTIONS
///////////////////////////////////////////////////////

// @return 0 on success
int Send_message(const char *message_param, int socket, struct public_key_class pub[1])
{
    int message_size = 0;
    char message[BUFFER_SIZE];
    if (strlen(message_param) == 0)
    {
        strcpy(message, "No output!");
    }
    else
    {
        strcpy(message, message_param);
    }
    message_size = strlen(message);

    long long *encrypted = Rsa_encrypt(message, message_size, pub);
    CHECK(encrypted != NULL, -1, "Error in encryption!");

    // printf("Encrypted message:\n");
    // for (int i = 0; i < message_size; i++)
    // {
    //     printf("%lld-", (long long)encrypted[i]);
    // }
    // printf("\n");

    CHECK(send(socket, &message_size, sizeof(int), 0) != -1, -1, "Unable to send message to client!");
    CHECK(send(socket, encrypted, sizeof(long long) * message_size, 0) != -1, -1, "Unable to send message to client!");

    message[message_size] = 0;
    printf("[sent] \"\"%s\"\"\n", message);

    if (encrypted)
    {
        free(encrypted);
    }
    memset(message, 0, message_size);
    return 0;
}

// @return 0 on success
int Recv_message(char *message, int socket, struct private_key_class priv[1])
{
    int message_size = 0;
    long long *encrypted = NULL;

    CHECK(recv(socket, &message_size, sizeof(int), 0) != -1, -1, "Recv() function did not work properyly!");
    // printf("received message_size = %d\n", message_size);

    encrypted = (long long *)malloc(sizeof(long long) * message_size);
    CHECK(encrypted != NULL, -1, "Unable to malloc");

    CHECK(recv(socket, encrypted, sizeof(long long) * message_size, 0) != -1, 3, "Recv() function did not work properyly!");

    // printf("[Encrypted]");
    // for (int i = 0; i < message_size; i++)
    // {
    //     printf("%lld-", (long long)encrypted[i]);
    // }
    // printf("\n");

    char *decrypted = Rsa_decrypt(encrypted, 8 * message_size, priv);
    CHECK(decrypted != NULL, -1, "Error in decryption!");
    // LOG("Finished decrypted");
    for (int i = 0; i < message_size; ++i)
    {
        message[i] = decrypted[i];
    }
    message[message_size] = 0;
    printf("[recv] \"\"%s\"\"\n", message);

    if (decrypted)
    {
        free(decrypted);
    }
    return 0;
}
