#include "../libs/utilities.h"

////////////////////////////////////////////////////////
//                      HELPERS
///////////////////////////////////////////////////////

void Print_args(char args[MAX_ARGS][BUFFER_SIZE])
{
    int i = 0;
    while (args[i])
    {
        PRINT("%s", args[i]);
        i++;
    }
}

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

// @return 0 if succeded.
int Parse_input(char *client_message, char *command, char args[MAX_ARGS][BUFFER_SIZE])
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
    memset(client_message, 0, BUFFER_SIZE);
    return 0;
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
    DEBUG_VERBOSE("cmd:%s", cmd);
    int index_args = 0;
    while (strcmp(args[index_args], "") != 0)
    {
        DEBUG_VERBOSE("arg %d:%s", index_args, args[index_args]);
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
           "\tcd <path>\n"
           "\tcwd\n"
           "\texec <command>\n"
           "\tquit\n");
    return 0;
}

int Quit_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    strcpy(message, "Goodbye!");
    return 0;
}

int Cwd_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    if (*auth == AUTHENTICATED)
    {
        CHECK(getcwd(message, BUFFER_SIZE) != NULL, -1, "Unable to run cwd");
    }
    else
    {
        strcpy(message, "Not authenticated");
    }

    return 0;
}

int Cd_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    if (*auth == AUTHENTICATED)
    {
        if (chdir(args[0]) == 0)
        {
            CHECK(getcwd(message, BUFFER_SIZE) != NULL, -1, "Unable to run cwd");
        }
        else
        {
            strcpy(message, "Unable to run cd");
        }
    }
    else
    {
        strcpy(message, "Not authenticated");
    }
    return 0;
}

enum CONTROL_OPS
{
    AND_OP,
    OR_OP,
    SEMICOLON_OP,
    CONTROL_OPS_NUMBER
};

// @ret -1 if is NOT control op; else return the enum
int Control_op_type(char arg[BUFFER_SIZE])
{
    if (strcmp(arg, "&&") == 0)
    {
        return AND_OP;
    }
    if (strcmp(arg, "||") == 0)
    {
        return OR_OP;
    }
    if (strcmp(arg, ";") == 0)
    {
        return SEMICOLON_OP;
    }
    return -1;
}

// @ret -1 if not found control op; else return its position
int Found_control_op(char args[MAX_ARGS][BUFFER_SIZE], int from_index)
{
    int i = from_index;
    while (args[i][0])
    {
        if (Control_op_type(args[i]) != -1)
        {
            return i;
        }
        i++;
    }
    return -1;
}

// ** accepted operators:
// * redirect ops:
// cmd1 | cmd2 -- redirects the output from cmd1 to cmd2 as input.
// cmd1 < fd -- redirects the contents from fd (which is file) to cmd1
// cmd1 > fd -- redirects ouput from cmd1 to fd
// cmd1 2> fd -- redirects the stderr from cmd1 to fd
// * control ops:
// cmd1 && cmd2 -- executes cmd2 only if cmd1 is true
// cmd1 || cmd2 -- executes cmd2 only if cmd1 is false
// cmd1 ; cmd2 -- executes both commands sequentially
int Exec_command(int *auth, char *message, char args[MAX_ARGS][BUFFER_SIZE])
{
    // if (*auth != AUTHENTICATED)
    // {
    //     strcpy(message, "You are not authenticated");
    //     return 0;
    // }

    char command[BUFFER_SIZE];
    memset(command, 0, BUFFER_SIZE);
    strcpy(message, "");
    int to_index = 0;
    int from_index = 0;
    pid_t pid;
    int status = 0;
    int stop = 0;
    int first_run = 1;
    // until i can't find any more control ops
    // I will take the args up to the control ops

    to_index = Found_control_op(args, from_index);
    if (to_index == -1)
    {
        to_index = MAX_ARGS;
    }

    do
    {
        // concatenate up to the index;
        for (int i = from_index; i < to_index && args[i]; ++i)
        {
            strcat(command, args[i]);
            strcat(command, " ");
        }

        FORK(pid);

        if (pid == 0)
        { // child
            PRINT("command for exec: %s", command);
            return system(command);
        }

        wait(&status);
        from_index = to_index + 1;
        first_run = 0;

        // make the control ops logic.
        switch (Control_op_type(args[to_index]))
        {
        case AND_OP:
        {
            if (status == -1)
            {
                from_index = to_index + 1;
                stop = 1;
            }
            break;
        }
        case OR_OP:
        {
            if (status != -1 && !first_run)
            {
                stop = 1;
            }

            break;
        }
        default:
        {
            break;
        }
        }
    } while ((to_index = Found_control_op(args, from_index)) != -1 && !stop);

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
    MSTAT_COMMAND,
    MYFIND_COMMAND,
    CWD_COMMAND,
    CD_COMMAND,
    QUIT_COMMAND,
    EXEC_COMMAND,
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
        return MSTAT_COMMAND;
    }
    if (strcmp(command, "myfind") == 0)
    {
        return MYFIND_COMMAND;
    }
    if (strcmp(command, "cwd") == 0)
    {
        return CWD_COMMAND;
    }
    if (strcmp(command, "cd") == 0)
    {
        return CD_COMMAND;
    }
    if (strcmp(command, "help") == 0)
    {
        return HELP_COMMAND;
    }
    if (strcmp(command, "quit") == 0)
    {
        return QUIT_COMMAND;
    }
    if (strcmp(command, "exec") == 0)
    {
        return EXEC_COMMAND;
    }
    return UNKOWN_COMMAND;
}

void Serve_client(int client_socket, struct public_key_class pub_his[1],
                  struct private_key_class priv_mine[1])
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
        Cwd_command,
        Cd_command,
        Quit_command,
        Exec_command,
        Unkown_command};

    int auth = (!AUTHENTICATED);

    do
    {
        Recv_message(client_message, client_socket, priv_mine);
        Parse_input(client_message, command, args);

        Print_cmd_args(command, args);

        command_type = Command_type(command);
        commands[command_type](&auth, server_message, args);

        Send_message(server_message, client_socket, pub_his);

