#ifndef __RSA_H__
#define __RSA_H__

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <string.h>

#include "macros.h"
#include "constants.h"

#define MAX_DIGITS 50

struct public_key_class{
  long long modulus;
  long long exponent;
};

struct private_key_class{
  long long modulus;
  long long exponent;
};

int Rsa_gen_keys(struct public_key_class *pub, struct private_key_class *priv);
long long *Rsa_encrypt(const char *message, const unsigned long message_size, const struct public_key_class *pub);
char *Rsa_decrypt(const long long *message, const unsigned long message_size, const struct private_key_class *pub);

#endif // !__RSA_H__
