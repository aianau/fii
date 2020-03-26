#include "../utilities.h"


int main()
{
    printf("ANA");
    pid_t pid;
    int p[2];
    printf("pid");
    PIPE(p);
    printf("pid");
    FORK(pid);

    printf("pid");

    if(pid == 0)
    {
        printf("pid");
        close(PIPE_WRITE);
        if(dup(p[PIPE_WRITE]) != 1){
            printf("ERROR dup != 1");
            exit(2);
        }
        printf("pid");
        close(p[PIPE_READ]);
        close(p[PIPE_WRITE]);
        printf("pid");
        CHECK(execlp("cat", "cat", "/home/ianubuntu/Desktop/RC/s3prim/main.cpp", NULL), -1, "Error at execlp");
        printf("Unable to execute execlp sucessfuly\n");
        exit(2);
    }

    wait(NULL);
    printf("pid1 finished");

    FORK(pid);

    if(pid == 0)
    {
        CLOSE(PIPE_READ);
        if(dup(p[PIPE_READ]) != 0){
            printf("ERROR dup != 0");
            exit(2);
        }
        CLOSE(PIPE_WRITE);
        if(dup(p[PIPE_WRITE]) != 1){
            printf("ERROR dup != 1");
            exit(2);
        }
        close(p[PIPE_READ]);
        close(p[PIPE_WRITE]);
        execlp("grep", "grep", "\"include\"", NULL);
        printf("Unable to execute grep sucessfuly\n");
        exit(2);
    }

    wait(NULL);
    printf("pid2 finished");

    FORK(pid);

    if(pid == 0)
    {
        char ch;
        close(PIPE_READ);
        if(dup(p[PIPE_READ]) != 0){
            printf("ERROR dup != 0");
            exit(2);
        }
        while(read(p[PIPE_READ], &ch, sizeof(char)) != 0){
            printf("%c", ch);
        }
        close(p[PIPE_READ]);
        close(p[PIPE_WRITE]);
    }
    while (wait (NULL) != -1)
        ;
    printf("pid3 finished");
    printf("father finished\n");
}