#include "../utilities.h"

#define MSG1 "Comunicam prin socketi!"
#define MSG2 "Atentie!Socketpair() o generalizarea a pipe-urilor"

int main()
{
    int sockp[2], child;
    char msg[1024];

    SOCKETPAIR(AF_UNIX, SOCK_STREAM, 0, sockp);
    
    if ((child = fork()) == -1)
        perror("Err...fork");
    else if (child) // parinte
    { 
        close(sockp[0]);
        if (read(sockp[1], msg, 1024) < 0)
            perror("[parinte]Err...read");
        printf("[parinte] %s\n", msg);
        if (write(sockp[1], MSG2, sizeof(MSG2)) < 0)
            perror("[parinte]Err...write");
        close(sockp[1]);
    }
    else // copil
    {
        close(sockp[1]);
        if (write(sockp[0], MSG1, sizeof(MSG1)) < 0)
            perror("[copil]Err...write");
        if (read(sockp[0], msg, 1024) < 0)
            perror("[copil]Err..read");
        printf("[copil]  %s\n", msg);
        close(sockp[0]);
    }
}