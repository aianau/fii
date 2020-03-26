#include "../utilities.h"

/// ENUNT
/*

Proiectati si implementati urmatorul protocol de comunicare intre procese:

- comunicarea se face prin executia de comenzi citite de la tastatura in procesul 
 parinte si executate in procesele copil
- comenzile sunt siruri de caractere delimitate de new line
- raspunsurile sunt siruri de octeti prefixate de lungimea raspunsului
- rezultatul obtinut in urma executiei oricarei comenzi va fi afisat de procesul 
 parinte
- protocolul minimal cuprinde comenzile:
    - "login : username" - a carei existenta este validata prin utilizarea unui 
     fisier de configurare
    - "myfind file" - o comanda care permite gasirea unui fisier si afisarea de 
    informatii asociate acelui fisier; informatiile vor fi de tipul: data crearii,
     data modificarii, dimensiunea fisierului, drepturile de access asupra fisierului
     etc.
    - "mystat file" - o comanda ce permite vizualizarea atributelor unui fisier
    - "quit"
- in implementarea comenzilor "myfind" si "mystat" nu se va utiliza nicio functie 
 din familia "exec()" in vederea executiei unor comenzi de sistem ce ofera
  functionalitatile respective
- comunicarea intre procese se va face folosind cel putin o data fiecare din
 urmatoarele mecanisme ce permit comunicarea: pipe-uri interne, pipe-uri externe
 si socketpair


Observatii:
- termen de predare: laboratorul din saptamana 5
- orice incercare de frauda, in functie de gravitate, va conduce la propunerea
 pentru exmatriculare a studentului in cauza sau la punctaj negativ
*/


int Get_user_password_entry(const char *line, char *username_entry, char * password_entry){
    int index = 0;
    strcpy(username_entry, "");
    strcpy(password_entry, "");
    while (line[index] != ' ' && line[index] != 0)
    {
        username_entry[index] = line[index];
        ++index;
    }
    username_entry[index] = 0;
    index++;
    int password_index = 0;
    while (line[index] != ' ' && line[index] != 0)
    {
        password_entry[password_index] = line[index];
        ++index;
        password_index++;
    }
    password_entry[password_index] = 0;

    return 0;
}

void calculate_sha256(char result[33], const char *input, size_t input_size){
    uint8_t hash_pass[32];    
    calc_sha_256(hash_pass, (const void *) input, input_size);
    for (int i = 0; i < 32; i++)
    {
        sprintf(&(result[i]), "%c", hash_pass[i]);
    }
    result[32] = 0;
}

// @return 0 : user found in users.txt and password is correct
// @return 1 : user found in users.txt and password is INcorrect
// @return 1 : user IS NOT found in users.txt
int Auth_user(const char *username, const char *password)
{
    FILE *fp;
    char *line = NULL;
    size_t len = 0;
    int read;
    int result = 2;
    char password_hashed[BUFFER_SIZE];
    
    calculate_sha256(password_hashed, password, strlen(password));

    fp = fopen("users.txt", "r");
    CHECK(fp != NULL, 1, "Unable to open users.txt");

    char username_entry[BUFFER_SIZE];
    char password_entry[BUFFER_SIZE];

    while ((read = getline(&line, &len, fp)) != -1)
    {
        line[strlen(line)-1] = 0;

        Get_user_password_entry(line, username_entry, password_entry);

        // printf("passw entry:[%s]\n", password_entry);
        // printf("passw hashed:[%s]\n", password_hashed);
        if (strcmp(username_entry, username) == 0)
        {
            result = 1;
            if (strcmp(password_hashed, password_entry) == 0){
                result = 0;
            }
        }
    }
    fclose(fp);
    if (line)
        free(line);

    return result;
}

// @return 0 if user authenticated and is accepted in session.
// @return 1 if not found.
// @param args[ARGS_INDEX_USERNAME] is the spearator ':'  
// @param args[1] is the username with which the user wants to login.
// @param args[2] is the password with which the user wants to login.
int Login_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    CHECKNOTNULL(args, -1);
    CHECKNOTNULL(args[1], -1);
    CHECKNOTNULL(args[2], -1);

    if (*auth == AUTHENTICATED){
        strcpy(message, "You are already logged in!");
    }

    int pipes[2];
    pid_t pid;
    int result_auth = 1;
    int username_size = strlen(args[1]);
    int password_size = strlen(args[2]);

    PIPE(pipes);
    FORK(pid);
    if (pid == 0) // child
    {
        char username[BUFFER_SIZE];
        char password[BUFFER_SIZE];
        read(pipes[PIPE_READ], &username_size, sizeof(int));
        read(pipes[PIPE_READ], username, sizeof(char) * username_size);
        username[username_size] = 0;
        read(pipes[PIPE_READ], &password_size, sizeof(int));
        read(pipes[PIPE_READ], password, sizeof(char) * password_size);
        password[password_size] = 0;
        int result = Auth_user(username, password);
        
        write(pipes[PIPE_WRITE], &result, sizeof(int));
        exit(1);
    }
    else // father
    {
        write(pipes[PIPE_WRITE], &username_size, sizeof(int));
        write(pipes[PIPE_WRITE], args[1], sizeof(char) * username_size);
        write(pipes[PIPE_WRITE], &password_size, sizeof(int));
        write(pipes[PIPE_WRITE], args[2], sizeof(char) * password_size);
        wait(NULL);
        read(pipes[PIPE_READ], &result_auth, sizeof(int));

        if (result_auth == 0){
            strcpy(message, "You are logged in.");
        }
        else if (result_auth == 1){
            strcpy(message, "Wrong password.");
        }
        else {
            strcpy(message, "User unknown.");
        }
        (*auth) = AUTHENTICATED;
        return result_auth;
    }
    
    return result_auth;
}

// @return 0 if succeded.
int Parse_input(const char *client_message, char *command, char args[MAX_ARGS][BUFFER_SIZE])
{
    int index_parser = 0;
    int number_args = 0;
    while (client_message[index_parser] != ' ' && client_message[index_parser] != 0)
    {
        command[index_parser] = client_message[index_parser];
        index_parser++;
    }
    command[index_parser] = 0;

    while (client_message[index_parser] != 0 && number_args < MAX_ARGS)
    {
        while (client_message[index_parser] == ' ' && client_message[index_parser] != 0)
        {
            index_parser++;
        }

        int index_arg = 0;
        while (client_message[index_parser] != ' ' && client_message[index_parser] != 0)
        {
            args[number_args][index_arg] = client_message[index_parser];
            index_arg++;
            index_parser++;
        }
        args[number_args][index_arg] = 0;
        number_args++;
    }
    memset(args[number_args], 0, BUFFER_SIZE);
    return 0;
}

// @return 0 if is directory
int Is_directory(const char *file){
    struct stat st;
    CHECK(stat(file, &st) != -1, 1, "Unable to stat the specified file!");  
    if (S_ISDIR(st.st_mode)){
        return 0;
    }  
    return 1;
}


// @return 0  if succses
int MyStat(const char *file_path, char perm[10]){
    CHECKNOTNULL(file_path, 1);
    struct stat st;    
    strcpy(perm, "---------");
    CHECK(stat(file_path, &st) != -1, 1, "Unable to stat the specified file!");
    if(S_IRUSR & st.st_mode) perm[0]='r';
    if(S_IWUSR & st.st_mode) perm[1]='w';
    if(S_IXUSR & st.st_mode) perm[2]='x';
    if(S_IRGRP & st.st_mode) perm[3]='r';
    if(S_IWGRP & st.st_mode) perm[4]='w';
    if(S_IXGRP & st.st_mode) perm[5]='x';
    if(S_IROTH & st.st_mode) perm[6]='r';
    if(S_IWOTH & st.st_mode) perm[7]='w';
    if(S_IXOTH & st.st_mode) perm[8]='x';
    return 0;
}


// @return 0 if succeeded. 1 if NOT.
// @params args[ARGS_INDEX_FILE] the file name of which info is to be shown.
int MyStat_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    CHECKNOTNULL(args[ARGS_INDEX_FILE], 1);
    
    if (*auth != AUTHENTICATED)
    {
        strcpy(message, "You are not authenticated to be able to use stat command!");
        return 0;
    }

    pid_t pid;
    int fd;
    char perm[10] = "---------";
    int perm_size;

    remove("fifo");    
    CHECK(mkfifo("fifo", 0666) != -1, 1, "Unable to create fifo");

    FORK(pid);
    if (pid != 0) // father
    {
        fd = open("fifo", O_RDONLY);
        read(fd, &perm_size, sizeof(int));
        if (perm_size == -1){
            strcpy(message, "Unable to stat the file.");
            close(fd);
            return -1;
        }

        char c;
        int index = 0;        
        while(read(fd, &c, sizeof(char))){
            message[index] = c;
            index ++;
        }
        message[index] = 0;
        
        close(fd);
        return 0;
    }
    else // child
    {
        fd = open("fifo", O_WRONLY);
        if (MyStat(args[ARGS_INDEX_FILE], perm) == 0){
            perm_size = strlen(perm);
            write(fd, &perm_size, sizeof(int));
            for (int i = 0; i < perm_size; ++i){
                write(fd, &perm[i], sizeof(char));
            }
        }
        else{
            perm_size = -1;
            write(fd, &perm_size, sizeof(int));
        }

        close(fd);
        exit(1);
    }

    return 0;
}


// @param path = directory in which to search
// @param found = 0 if found, 1 if NOT found
int Find(const char *dir_path, const char *file_to_find, int recursive, char perm[10], int *found){
    DIR *dir;
    struct dirent *de;
    char new_path[BUFFER_SIZE];
    char path_to_file[BUFFER_SIZE];
    int result = 0;

    *found = 1;

    CHECK((dir = opendir(dir_path)) != NULL, 1, "Unable to open directory");
    
    while((de = readdir(dir)) != NULL)
    {   
        if (strcmp(file_to_find, de->d_name) == 0){
            
            sprintf(path_to_file,"%s/%s",dir_path, de->d_name);
            *found = 0;
            result = MyStat(path_to_file, perm);
        }
        if (recursive == 0) {
            if( strcmp(de->d_name,".") != 0 && strcmp(de->d_name,"..") != 0) 
            {
                printf("newpath: %s\n", new_path);
                sprintf(new_path,"%s/%s",dir_path, de->d_name);
                Find(new_path, file_to_find, recursive, perm, found);
            }
        }
        
    }

    closedir(dir);
    return result;
}

// @return 0 if succeeded. 1 if NOT.
// @params args[0, 1,2...] different options:
//  -r => recursive find.
int MyFind_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    if (*auth != AUTHENTICATED)
    {
        strcpy(message, "You are not authenticated to be able to use stat command!");
        return 0;
    }


    int index_args = 0;
    int recursive = 1; 
    char perm[10] = "---------";
    int found;
    char dir[BUFFER_SIZE] = ".";
    char file_name[BUFFER_SIZE] = "123!@#123!@#123!@#";
    int dir_provided = 1;
    int file_provided = 1;


    while (strcmp(args[index_args], "") != 0)
    {
        if (strcmp(args[index_args], "-r") == 0){
            recursive = 0;
        }
        if (strcmp(args[index_args], "-d") == 0){
            strcpy(dir, args[index_args+1]);
            dir_provided = 0;
        }
        if (strcmp(args[index_args], "-f") == 0){
            strcpy(file_name, args[index_args+1]);
            file_provided = 0;
        }   
        index_args++;
    }

    if (file_provided == 1){
        strcpy(message, "File not provided.");
        return 1;
    }
    if (dir_provided == 1){
        strcpy(message, "Directory not provided.");
        return 1;
    }

    if (Is_directory(file_name) == 0){
        strcpy(message, "Filename is directory. Unable to stat.");
        printf("filename: %s\n", file_name);
        return 1;
    }

    Find(dir, file_name, recursive, perm, &found);

    if (found == 0)
    {
        strcpy(message, perm);
    }
    else{
        strcpy(message, "Unable to find the file.");        
    }
    return 0;
}

int Insert_new_user(char *username, char *password){
    FILE *fp;

    fp = fopen("users.txt", "a");
    CHECK(fp != NULL, 1, "Unable to open users.txt");

    char line[BUFFER_SIZE];
    char password_hashed[BUFFER_SIZE];

    calculate_sha256(password_hashed, password, strlen(password));

    sprintf(line, "%s %s\n", username, password_hashed);
    fwrite(line, sizeof(char), strlen(line), fp);
    fclose(fp);
    return 0;
}

// @return 0  if username already exists.
int Check_existing_username(const char* username){
    FILE *fp;
    char *line = NULL;
    size_t len = 0;
    int read;
    int user_found = 1;

    fp = fopen("users.txt", "r");
    CHECK(fp != NULL, 1, "Unable to open users.txt");

    char username_entry[BUFFER_SIZE];
    char password_entry[BUFFER_SIZE];

    while ((read = getline(&line, &len, fp)) != -1)
    {
        line[strlen(line)-1] = 0;
        Get_user_password_entry(line, username_entry, password_entry);

        if (strcmp(username_entry, username) == 0)
        {
            user_found = 0;
        }
    }

    fclose(fp);
    if (line)
        free(line);

    return user_found;
}

int Lognew_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    if (Check_existing_username(args[ARGS_INDEX_USERNAME]) == 0){
        strcpy(message, "Sorry, username already taken.");
        return 1;
    }
    Insert_new_user(args[ARGS_INDEX_USERNAME], args[ARGS_INDEX_PASSWORD]);
    strcpy(message, "User inserted.");
    return 0;
}

int Logout_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE]){
    if ((*auth) == AUTHENTICATED)
    {
        strcpy(message, "Logged out!");
        (*auth) = !AUTHENTICATED;
    }
    else
    {
        strcpy(message, "You are not authenticated to be able to logout!");
    }
    return 0;
}

int Help_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    strcpy(message, 
        "Commands:\n"
        "\thelp --> prints out this message\n"
        "\tlogin : [username] [password]\n"
        "\tlognew [username] [password]\n"
        "\tlogout\n"
        "\tmystat [file to stat]\n"
        "\tmyfind -d [directory within to search] -f [file to search] [-r] -->  -r = recursive search in subfolders\n"
        "\tquit\n"
    );
    return 0;
}

int Quit_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    strcpy(message, "Goodbye!");
    return 0;
}

int Unkown_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    strcpy(message, "Unkown command!");
    return 0;
}

void Print_cmd_args(const char *cmd, const char args[MAX_ARGS][BUFFER_SIZE])
{
    printf("cmd:%s\n", cmd);
    int index_args = 0;
    while (strcmp(args[index_args],"") != 0)
    {
        printf("arg %d:%s\n", index_args, args[index_args]);
        index_args++;
    }
}

typedef int (*Command)(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE]);

enum COMMANDS
{
    HELP_COMMAND,
    LOGNEW_COMMAND,
    LOGIN_COMMAND,
    LOGOUT_COMMAND,
    STAT_COMMAND,
    FIND_COMMAND,
    QUIT_COMMAND,
    UNKOWN_COMMAND,
    COMMANDS_NUMBER
};

// @return enum of type of the command.
int Command_type(const char *command)
{
    CHECK(command != NULL, -1, "Expected not null pointer!");

    if (strcmp(command, "lognew") == 0)
    {
        return LOGNEW_COMMAND;
    }
    if (strcmp(command, "login") == 0)
    {
        return LOGIN_COMMAND;
    }
    if (strcmp(command, "logout") == 0)
    {
        return LOGOUT_COMMAND;
    }
    if (strcmp(command, "mystat") == 0)
    {
        return STAT_COMMAND;
    }
    if (strcmp(command, "myfind") == 0)
    {
        return FIND_COMMAND;
    }
    if (strcmp(command, "help") == 0)
    {
        return HELP_COMMAND;
    }
    if (strcmp(command, "quit") == 0)
    {
        return QUIT_COMMAND;
    }
    return UNKOWN_COMMAND;
}


void Serve_client(int client_socket){
    char client_message[BUFFER_SIZE];
    char server_message[BUFFER_SIZE];

    int command_type;
    char command[BUFFER_SIZE];    
    char args[MAX_ARGS][BUFFER_SIZE];
    memset(args, 0, MAX_ARGS * BUFFER_SIZE);

    Command commands[COMMANDS_NUMBER] = {
        Help_command,
        Lognew_command,
        Login_command,
        Logout_command,
        MyStat_command,
        MyFind_command,
        Quit_command,
        Unkown_command
    };

    int auth = (! AUTHENTICATED); 

    do
    {
        Recv_message(client_message, client_socket);
        Parse_input(client_message, command, args);
        
        // Print_cmd_args(command, args);
        
        command_type = Command_type(command);
        commands[command_type](&auth, server_message, args);

        Send_message(server_message, client_socket);

    }while (command_type != QUIT_COMMAND);
}

// TODO
// * problema la autentificare. Acelasi user se poate autentifica de pe mai multe terminale.

int main()
{
    pid_t pid;
    struct sockaddr_in server_address;
    int server_socket;
    int client_socket;

    CHECK((server_socket = socket(AF_INET, SOCK_STREAM, 0)), 1, "Unable to create server socket!");
    server_address.sin_family = AF_INET;
    server_address.sin_addr.s_addr = INADDR_ANY;
    server_address.sin_port = htons(9090);

    bind(server_socket, (struct sockaddr *)&server_address, sizeof(server_address));
    
    while (1)
    {
        LOG("listening");
        listen(server_socket, MAX_CONNECTIONS_ALLOWED);
        LOG("client accepted");
        client_socket = accept(server_socket, NULL, NULL);
        CHECK(client_socket != -1, 1, "Unable to accept client!");
        LOG("connection established");
        Send_message("You are connected. Please log in for further operations.", client_socket);
        FORK(pid);
        if (pid == 0){
            Serve_client(client_socket);
            close(client_socket);            
            return 0;
        }
    }
    close(server_socket);
    return 0;
}