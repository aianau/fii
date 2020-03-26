#include "../libs/utilities.h"
char *PRIME_SOURCE_FILE = "primes.txt";

////////////////////////////////////////////////////////
//                      HELPERS
///////////////////////////////////////////////////////

int Get_user_password_entry(const char *line, char *username_entry, char *password_entry)
{
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

void calculate_sha256(char result[33], const char *input, size_t input_size)
{
    uint8_t hash_pass[32];
    calc_sha_256(hash_pass, (const void *)input, input_size);
    for (int i = 0; i < 32; i++)
    {
        sprintf(&(result[i]), "%c", hash_pass[i]);
    }
    result[32] = 0;
}

// @return 0 if is directory
int Is_directory(const char *file)
{
    struct stat st;
    CHECK(stat(file, &st) != -1, 1, "Unable to stat the specified file!");
    if (S_ISDIR(st.st_mode))
    {
        return 0;
    }
    return 1;
}

int Auth_user(const char *username, const char *password)
{
    FILE *fp;
    char *line = NULL;
    size_t len = 0;
    int read;
    int result = AUTH_FAILED_USER;
    char password_hashed[BUFFER_SIZE];

    calculate_sha256(password_hashed, password, strlen(password));

    fp = fopen("users.txt", "r");
    CHECK(fp != NULL, 1, "Unable to open users.txt");

    char username_entry[BUFFER_SIZE];
    char password_entry[BUFFER_SIZE];

    while ((read = getline(&line, &len, fp)) != -1)
    {
        line[strlen(line) - 1] = 0;

        Get_user_password_entry(line, username_entry, password_entry);

        // printf("passw entry:[%s]\n", password_entry);
        // printf("passw hashed:[%s]\n", password_hashed);
        if (strcmp(username_entry, username) == 0)
        {
            result = AUTH_FAILED_PASSWORD;
            if (strcmp(password_hashed, password_entry) == 0)
            {
                result = AUTH_SUCCESS;
            }
        }
    }
    fclose(fp);
    if (line)
        free(line);

    return result;
}

int Insert_new_user(char *username, char *password)
{
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
int Check_existing_username(const char *username)
{
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
        line[strlen(line) - 1] = 0;
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

// @return 0  if succses
int MyStat(const char *file_path, char perm[10])
{
    CHECKNOTNULL(file_path, 1);
    struct stat st;
    strcpy(perm, "---------");
    CHECK(stat(file_path, &st) != -1, 1, "Unable to stat the specified file!");
    if (S_IRUSR & st.st_mode)
        perm[0] = 'r';
    if (S_IWUSR & st.st_mode)
        perm[1] = 'w';
    if (S_IXUSR & st.st_mode)
        perm[2] = 'x';
    if (S_IRGRP & st.st_mode)
        perm[3] = 'r';
    if (S_IWGRP & st.st_mode)
        perm[4] = 'w';
    if (S_IXGRP & st.st_mode)
        perm[5] = 'x';
    if (S_IROTH & st.st_mode)
        perm[6] = 'r';
    if (S_IWOTH & st.st_mode)
        perm[7] = 'w';
    if (S_IXOTH & st.st_mode)
        perm[8] = 'x';
    return 0;
}

// @param path = directory in which to search
// @param found = 0 if found, 1 if NOT found
int Find(const char *dir_path, const char *file_to_find, int recursive, char perm[10], int *found)
{
    DIR *dir;
    struct dirent *de;
    char new_path[BUFFER_SIZE];
    char path_to_file[BUFFER_SIZE];
    int result = 0;

    *found = 1;

    CHECK((dir = opendir(dir_path)) != NULL, 1, "Unable to open directory");

    while ((de = readdir(dir)) != NULL)
    {
        if (strcmp(file_to_find, de->d_name) == 0)
        {

            sprintf(path_to_file, "%s/%s", dir_path, de->d_name);
            *found = 0;
            result = MyStat(path_to_file, perm);
        }
        if (recursive == 0)
        {
            if (strcmp(de->d_name, ".") != 0 && strcmp(de->d_name, "..") != 0)
            {
                printf("newpath: %s\n", new_path);
                sprintf(new_path, "%s/%s", dir_path, de->d_name);
                Find(new_path, file_to_find, recursive, perm, found);
            }
        }
    }

    closedir(dir);
    return result;
}

void Print_cmd_args(const char *cmd, const char args[MAX_ARGS][BUFFER_SIZE])
{
    printf("cmd:%s\n", cmd);
    int index_args = 0;
    while (strcmp(args[index_args], "") != 0)
    {
        printf("arg %d:%s\n", index_args, args[index_args]);
        index_args++;
    }
}

////////////////////////////////////////////////////////
//                      COMMANDS
///////////////////////////////////////////////////////

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

    if (*auth == AUTHENTICATED)
    {
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

        if (result_auth == 0)
        {
            strcpy(message, "You are logged in.");
            (*auth) = AUTHENTICATED;
        }
        else if (result_auth == 1)
        {
            strcpy(message, "Wrong password.");
            (*auth) = !AUTHENTICATED;
        }
        else
        {
            strcpy(message, "User unknown.");
            (*auth) = !AUTHENTICATED;
        }

        return result_auth;
    }

    return result_auth;
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
        if (perm_size == -1)
        {
            strcpy(message, "Unable to stat the file.");
            close(fd);
            return -1;
        }

        char c;
        int index = 0;
        while (read(fd, &c, sizeof(char)))
        {
            message[index] = c;
            index++;
        }
        message[index] = 0;

        close(fd);
        return 0;
    }
    else // child
    {
        fd = open("fifo", O_WRONLY);
        if (MyStat(args[ARGS_INDEX_FILE], perm) == 0)
        {
            perm_size = strlen(perm);
            write(fd, &perm_size, sizeof(int));
            for (int i = 0; i < perm_size; ++i)
            {
                write(fd, &perm[i], sizeof(char));
            }
        }
        else
        {
            perm_size = -1;
            write(fd, &perm_size, sizeof(int));
        }

        close(fd);
        exit(1);
    }

    return 0;
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
        if (strcmp(args[index_args], "-r") == 0)
        {
            recursive = 0;
        }
        if (strcmp(args[index_args], "-d") == 0)
        {
            strcpy(dir, args[index_args + 1]);
            dir_provided = 0;
        }
        if (strcmp(args[index_args], "-f") == 0)
        {
            strcpy(file_name, args[index_args + 1]);
            file_provided = 0;
        }
        index_args++;
    }

    if (file_provided == 1)
    {
        strcpy(message, "File not provided.");
        return 1;
    }
    if (dir_provided == 1)
    {
        strcpy(message, "Directory not provided.");
        return 1;
    }

    if (Is_directory(file_name) == 0)
    {
        strcpy(message, "Filename is directory. Unable to stat.");
        printf("filename: %s\n", file_name);
        return 1;
    }

    Find(dir, file_name, recursive, perm, &found);

    if (found == 0)
    {
        strcpy(message, perm);
    }
    else
    {
        strcpy(message, "Unable to find the file.");
    }
    return 0;
}

int Lognew_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    if (Check_existing_username(args[ARGS_INDEX_USERNAME]) == 0)
    {
        strcpy(message, "Sorry, username already taken.");
        return 1;
    }
    Insert_new_user(args[ARGS_INDEX_USERNAME], args[ARGS_INDEX_PASSWORD]);
    strcpy(message, "User inserted.");
    return 0;
}

int Logout_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
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
           "\tquit\n");
    return 0;
}

int Quit_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    strcpy(message, "Goodbye!");
    return 0;
}

int Exec_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    return 0;
}

int Download_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{

    FILE *fp;
    fp = fopen(args[0], "r");
    if (fp == NULL)
    {
        sprintf(message, "Unable to open file %s", args[0]);
        return -1;
    }

    CHECKSHOW(fread(message, sizeof(char), BUFFER_SIZE - 1, fp) > 0, "Read 0 bytes from file %s", args[0]);

    return 0;
}

int Unkown_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    strcpy(message, "Unkown command!");
    return 0;
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
    EXEC_COMMAND,
    DOWNLOAD_COMMAND,
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
    if (strcmp(command, "download") == 0)
    {
        return DOWNLOAD_COMMAND;
    }
    if (strcmp(command, "exec") == 0)
    {
        return EXEC_COMMAND;
    }
    return UNKOWN_COMMAND;
}

void Serve_client(SSL *ssl)
{
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
        Exec_command,
        Download_command,
        Unkown_command};

    int auth = (!AUTHENTICATED);

    do
    {
        memset(client_message, 0, BUFFER_SIZE);
        memset(server_message, 0, BUFFER_SIZE);

        Recv_message(client_message, ssl);
        Parse_input(client_message, command, args);
        // Print_cmd_args(command, args);

        command_type = Command_type(command);
        commands[command_type](&auth, server_message, args);

        Send_message(server_message, ssl);

    } while (command_type != QUIT_COMMAND);

    SSL_free(ssl);
}

// TODO
// *

int main(int count, char *strings[])
{
    CHECK(isRoot(), -1,
          "This program must be run as root/sudo user!");
    CHECK(count == 2, -1,
          "Wrong number of params. Params must be <PORT_to_set_listener>");

    SSL_CTX *ctx;
    SSL *ssl;
    pid_t pid;
    socklen_t address_size = sizeof(struct sockaddr_in);
    char *portnum;
    int server_socket;
    struct Client clients[MAX_CONNECTIONS_ALLOWED];
    int nr_clients = 0;

    portnum = strings[1];

    SSL_library_init();
    ctx = InitServerCTX();
    Load_certificates(ctx, "server_cert.pem", "server_cert.pem");

    server_socket = Open_listener(atoi(portnum));

    while (1)
    {
        clients[nr_clients].socket = accept(server_socket, (struct sockaddr *)&clients[nr_clients].address, &address_size);
        CHECK(clients[nr_clients].socket != -1, 1, "Unable to accept client!");
        LOG("client accepted: %s:%d", , inet_ntoa(clients[nr_clients].address.sin_addr), ntohs(clients[nr_clients].address.sin_port));

        ssl = SSL_new(ctx);
        SSL_set_fd(ssl, clients[nr_clients].socket);

        CHECK(SSL_accept(ssl) != FAIL, -1, "Could not ssl accept");
        Show_certs(ssl);

        FORK(pid);
        if (pid == 0)
        {
            Serve_client(ssl);
            close(clients[nr_clients].socket);
            return 0;
        }
        nr_clients++;
    }
    close(server_socket);
    SSL_CTX_free(ctx);
    return 0;
}
