#include "../utilities.h"



int main(int argc, char *argv[])
{
    int p[2];
    pid_t pid;
    int num;
    char responese[10];

    memset(responese, 0, 10);
    strcpy(responese, "no");

    PIPE(p);
    FORK(pid);

    // printf("%d\n", pid);

    if (pid == 0) // child
    {
        read(p[0], &num, sizeof(int));
        int result = IsPrime(num);
        if (result)
        {
            strcpy(responese, "yes");
        }
        
        write(p[1], responese, strlen(responese));
    }
    else // father
    {
        memset(responese, 0, 10);

        scanf("%d", &num);
        write(p[1], &num, sizeof(int));
        wait(NULL);
        read(p[0], responese, 4);
        printf("%s\n", responese);
    }
}