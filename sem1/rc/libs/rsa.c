#include "rsa.h"

long long Gcd(long long a, long long b)
{
    long long c;
    while (a != 0)
    {
        c = a;
        a = b % a;
        b = c;
    }
    return b;
}

long long Euclid(long long a, long long b)
{
    long long x = 0, y = 1, u = 1, v = 0, gcd = b, m, n, q, r;
    while (a != 0)
    {
        q = gcd / a;
        r = gcd % a;
        m = x - u * q;
        n = y - v * q;
        gcd = a;
        a = r;
        x = u;
        y = v;
        u = m;
        v = n;
    }
    return y;
}

long long Rsa_mod(long long b, long long e, long long m)
{
    CHECKEXIT(b >= 0 && e>=0 && m>0, 1, "Wrong params in Rsa_mod");
    b = b % m;
    if (e == 0)
        return 1;
    if (e == 1)
        return b;
    if (e % 2 == 0)
    {
        return (Rsa_mod(b * b % m, e / 2, m) % m);
    }
    if (e % 2 == 1)
    {
        return (b * Rsa_mod(b, (e - 1), m) % m);
    }
    return 0;
}


int Rsa_gen_keys(struct public_key_class *pub, struct private_key_class *priv)
{
    FILE *fp;
    CHECK((fp = fopen(PRIMES_FILE, "r")) != NULL, -1, "Unable to open primes file");
    char buffer[BUFFER_SIZE_1024];
    memset(buffer, 0, BUFFER_SIZE_1024);

    long long p = 0;
    long long q = 0;

    long long e = powl(2, 8) + 1;
    long long d = 0;
    char prime_buffer[MAX_DIGITS];
    long long modulus = 0;
    long long phi_max = 0;

    srand(time(NULL));

    do
    {
        // get two random prime numbers
        int rand_pos1 = rand() % (MAX_NUMBER_PRIMES * 5) - 10;
        int rand_adder = rand() % (MAX_NUMBER_PRIMES * 5);

        CHECK(fseek(fp, rand_pos1, SEEK_SET) == 0, -1, "Unable to set file pointer");
        fgets(prime_buffer, sizeof(prime_buffer) - 1, fp);
        fgets(prime_buffer, sizeof(prime_buffer) - 1, fp);
        p = atol(prime_buffer);

        CHECK(fseek(fp, (rand_pos1 + rand_adder) % (MAX_NUMBER_PRIMES * 5), SEEK_SET) == 0, -1, "Unable to set file pointer");
        fgets(prime_buffer, sizeof(prime_buffer) - 1, fp);
        fgets(prime_buffer, sizeof(prime_buffer) - 1, fp);
        q = atol(prime_buffer);

        modulus = p * q;
        phi_max = (p - 1) * (q - 1);
    } while (!(p && q) || (p == q) || (Gcd(phi_max, e) != 1));

    d = Euclid(phi_max, e);
    while (d < 0)
    {
        d = d + phi_max;
    }

    pub->modulus = modulus;
    pub->exponent = e;

    priv->modulus = modulus;
    priv->exponent = d;

    return 0;
}

long long *Rsa_encrypt(const char *message, const unsigned long message_size,
                       const struct public_key_class *pub)
{
    long long *encrypted = (long long*)malloc(sizeof(long long) * message_size);
    CHECK(encrypted != NULL, NULL, "Unable to allocate memory");
    
    for (long long i = 0; i < message_size; i++)
    {
        encrypted[i] = Rsa_mod(message[i], pub->exponent, pub->modulus);
    }
    return encrypted;
}

char *Rsa_decrypt(const long long *message,
                  const unsigned long message_size,
                  const struct private_key_class *priv)
{
    CHECK (message_size % sizeof(long long) == 0, NULL, "Wrong size of message_size");
    char *decrypted = (char *)malloc(message_size / sizeof(long long));
    char *temp = (char *)malloc(message_size);
    CHECKNOTNULL(decrypted, NULL);
    CHECKNOTNULL(temp, NULL);
    
    for (long long i = 0; i < message_size / 8; i++)
    {
        temp[i] = Rsa_mod(message[i], priv->exponent, priv->modulus);
    }
    for (long long i = 0; i < message_size / 8; i++)
    {
        decrypted[i] = temp[i];
    }
    free(temp);
    return decrypted;
}
