#ifndef __MACROS_H__
#define __MACROS_H__

#include <time.h>

////////////////////////////////////////////////////////
//                      PRE COMPILATION OPTIONS
///////////////////////////////////////////////////////

////////////////////////////////////////////////////////
//                      MACROS
///////////////////////////////////////////////////////

#define LOG(message)               \
    {                              \
        printf("[" message "]\n"); \
        fflush(stdout);            \
    }

#define PRINT(...)           \
    {                        \
        printf(__VA_ARGS__); \
        printf("\n");        \
        fflush(stdout);      \
    }

#ifdef __DEBUG__
#define DEBUG(...)           \
    {                        \
        printf("[DBG] ");    \
        printf(__VA_ARGS__); \
        printf("\n");        \
        fflush(stdout);      \
    }
#else
#define DEBUG(...) \
    {              \
    }
#endif

#ifdef __DEBUG__
#define DEBUG_VERBOSE(...)     \
    {                          \
        printf("[DBG] ");      \
        printf("%s %d %d -- ", \
               __FUNCTION__,   \
               __LINE__,       \
               getpid());      \
        printf(__VA_ARGS__);   \
        printf("\n");          \
        fflush(stdout);        \
    }
#else
#define DEBUG_VERBOSE(...) \
    {                      \
    }
#endif

#define CHECK(c, ret, ...)   \
    if (!(c))                \
    {                        \
        printf(__VA_ARGS__); \
        printf("\n");        \
        fflush(stdout);      \
        return ret;          \
    }

#define CHECKSHOW(c, ...)    \
    if (!(c))                \
    {                        \
        printf(__VA_ARGS__); \
        printf("\n");        \
        fflush(stdout);      \
    }

#define CHECKNOTNULL(ptr, ret)                  \
    if (ptr == NULL)                            \
    {                                           \
        printf("Expected not null poitner!\n"); \
        fflush(stdout);                         \
        return ret;                             \
    }

#define CHECKEXIT(c, exit_code, ...) \
    if (!(c))                        \
    {                                \
        printf(__VA_ARGS__);         \
        perror(__VA_ARGS__);         \
        fflush(stdout);              \
        exit(exit_code);             \
    }

#define CHECKCONT(c, ...)    \
    if (!(c))                \
    {                        \
        printf(__VA_ARGS__); \
        perror(__VA_ARGS__); \
        fflush(stdout);      \
        continue;            \
    }

#define PIPE(p)                                                                    \
    {                                                                              \
        CHECK(pipe(p) != -1, -1, "Unable to create pipe for pid: %d\n", getpid()); \
    }

#define FORK(pid)                                                   \
    {                                                               \
        pid = fork();                                               \
        CHECK(pid != -1, -1, "Unable to fork pid: %d\n", getpid()); \
    }

#define DUP(oldfd, newfd)                                                                                   \
    {                                                                                                       \
        CHECK((newfd = dup(oldfd)) == 0, -1, "Unable to duplicate fd: %d, for pid: %d\n", oldfd, getpid()); \
    }

#define DUPSIMPLE(fd)                                                                              \
    {                                                                                              \
        CHECK(dup(fd) == 0, -1, "Unable to duplicate simply fd: %d, for pid: %d\n", fd, getpid()); \
    }

#define CLOSE(fd)                                                                          \
    {                                                                                      \
        CHECK(close(fd) != -1, -1, "Unable to close fd: %d, for pid: %d\n", fd, getpid()); \
    }

#define SOCKETPAIR(domain, type, protocol, fds_pointer)                                                     \
    {                                                                                                       \
        CHECK(socketpair(domain, type, protocol, fds_pointer) >= 0, -1, "Unable to create socket pair.\n"); \
    }

#endif // !__MACROS_H__