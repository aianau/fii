#include "../utilities.h"

/*
1. Creati un program in care tatal trimite un sir fiului. Acesta concateneaza la
sirul primit un alt sir si va intoarce procesului tata raspunsul obtinut.
Pentru comunicare se va folosi primitiva socketpair. 
*/

void Read_line(char *buff){
    while(read(stdin, ))
}

int main(){
    int sp[2];
    int size = 0;
    int size2 = 0;
    pid_t pid;
    char buff[BUFFER_SIZE + 1];
    char buff2[BUFFER_SIZE + 1];


    memset(buff, 0, sizeof(char) * BUFFER_SIZE);
    memset(buff2, 0, sizeof(char) * BUFFER_SIZE);

    SOCKETPAIR(AF_UNIX, SOCK_STREAM, 0, sp);
    FORK(pid);

    if(pid == 0) // child
    {
        CLOSE(sp[1]);
        strcpy(buff2, "Ba andrei nu are mere.");
        read(sp[0], &size, sizeof(int));
        CHECK(size < BUFFER_SIZE, -1, "Size of message received is bigger that buffer size.\n");
        read(sp[0], buff, size * sizeof(char));

        strcat(buff, buff2);
        size2 = strlen(buff);

        write(sp[0], &size2, sizeof(int));
        write(sp[0], buff, size2 * sizeof(char));
        
        close(sp[0]);
    }
    else // father 
    {
        CLOSE(sp[0]);

        scanf("%s", buff);
        size = strlen(buff);

        write(sp[1], &size, sizeof(int));
        write(sp[1], buff, size);


        memset(buff, 0, sizeof(char) * BUFFER_SIZE);        
        read(sp[1], &size, sizeof(int));
        CHECK(size < BUFFER_SIZE, -1, "Size of message received is bigger that buffer size.\n");
        read(sp[1], buff, size * sizeof(char));
        close(sp[1]);

        printf("FINAL STRING: %s", buff);
    }
    return 0;
}
















