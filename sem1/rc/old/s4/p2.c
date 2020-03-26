#include "../utilities.h"

/*
2. Creati un program in care un process tata imparte o expresie aritmetica
intr-un numar de subexpresii. Aceste subexpresii sunt evaluate fiecare de
cate un proces fiu. Rezultatul este intors procesului parinte, care va reevalua
expresia si va intoarce rezultatul final. Comunicarea se va face prin
socketpair().
*/


// @return 0 if input is valid.
int Validate_input(const char *buff){
    CHECK(buff != NULL, 1, "Expecting a valid pointer.");
    int opened = 0;
    int closed = 0;

    while(*buff != 0 && opened <= closed){
        if(*buff == '('){
            opened++;
        } 
        if(*buff == ')'){
            closed++;
        }
        buff++;
    }
    if (*buff == 0){
        return 2;
    }
    if (opened != closed){
        return 3;
    }
    return 0;
}

// @return 1 if buff has a '(' else @return 0.
int Has_sub_expression(const char *buff){
    CHECK(buff != NULL, 1, "Expecting a valid pointer.");
    while(*buff != 0){
        if(*buff == '('){
            return 0;
        } 
    }
    return 1;
}

int Get_indexes_of_subexpression(const char *buff, int *index_opened_bracket, int *index_closed_bracket){
    CHECK(buff != NULL, 1, "Expecting a valid pointer buff.");
    CHECK(index_opened_bracket != NULL, 1, "Expecting a valid pointer index_opened_bracket.");
    CHECK(index_opened_bracket != NULL, 1, "Expecting a valid pointer index_closed_bracket.");
    int stopper;
    *index_opened_bracket = 0;
    while(*buff != 0 && *buff != ')'){
        (*index_opened_bracket)++;
        buff++;
    }
    stopper = *index_opened_bracket;
    while(stopper != 0 && *buff != '(' && stopper >= 0){
        (*index_opened_bracket)++;
    }

}

int main(){
    int sp[2];
    int size = 0;
    pid_t pid;
    char buff[BUFFER_SIZE + 1];
    memset(buff, 0, sizeof(char) * BUFFER_SIZE);

    SOCKETPAIR(AF_UNIX, SOCK_STREAM, 0, sp);
    FORK(pid);

    scanf("%s", buff);

    CHECK(Validate_input(buff) == 0, 1, "Expecting valid input.\n");
    while(Has_sub_expression(buff) == VALID){

    }


    if(pid != 0) // father 
    {
        CLOSE(sp[1]);
        read(sp[0], &size, sizeof(int));
        CHECK(size < BUFFER_SIZE, -1, "Size of message received is bigger that buffer size.\n");
        read(sp[0], buff, size * sizeof(char));


        
        close(sp[0]);
    }
    else 
    {

    }
    return 0;
}




































