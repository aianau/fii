#ifndef __SHA256_H__
#define __SHA256_H__

#include <stdint.h>
#include <string.h>

#define CHUNK_SIZE 64
#define TOTAL_LEN_LEN 8

void calc_sha_256(uint8_t hash[32], const void * input, size_t len);

#endif // !__SHA256_H__