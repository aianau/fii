#ifndef __SHA256_H__
#define __SHA256_H__


#include <stdint.h>
#include <string.h>

#define CHUNK_SIZE 64
#define TOTAL_LEN_LEN 8


/*
 * Limitations:
 * - Since input is a pointer in RAM, the data to hash should be in RAM, which could be a problem
 *   for large data sizes.
 * - SHA algorithms theoretically operate on bit strings. However, this implementation has no support
 *   for bit string lengths that are not multiples of eight, and it really operates on arrays of bytes.
 *   In particular, the len parameter is a number of bytes.
 */
void calc_sha_256(uint8_t hash[32], const void * input, size_t len);


#endif // !__SHA256_H__