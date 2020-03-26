#pragma once
#ifndef __ARDO_H__
#define __ARDO_H__

#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */
#include <stdio.h>
#include <limits>
#include <math.h>
#include <typeinfo>
#include <chrono>


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                              VISUAL STUDIO SPECIFIC PREPROCESORS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define _CRT_SECURE_NO_WARNINGS


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                              PRINTERS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define SEPARATOR "\n"\
"==============\n"

#define LOG(format, ...)\
printf( SEPARATOR\
        "File - %s |||| "\
        "Line - %d |||| "\
        "Fnc - %s  |||| "\
        format,\
        __FILE__, __LINE__, __FUNCTION__, __VA_ARGS__);\


#define _NO_CRT_STDIO_INLINE
#define _printf(format, ...)\
printf(SEPARATOR format, __VA_ARGS__);\

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                              CHECKERS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define CHECK(c, ret, format, ...)\
if(!(c))\
{\
    printf( SEPARATOR\
        "File - %s |||| "\
        "Line - %d |||| "\
        "Fnc - %s  |||| "\
        "Cond - %s  |||| "\
        format,\
        __FILE__, __LINE__, __FUNCTION__, #c, __VA_ARGS__);\
    return ret;\
}\

#define CHECKBK(c, format, ...)\
if(!(c))\
{\
    printf( SEPARATOR\
        "File - %s |||| "\
        "Line - %d |||| "\
        "Fnc - %s  |||| "\
        "Cond - %s  |||| "\
        format,\
        __FILE__, __LINE__, __FUNCTION__, #c, __VA_ARGS__);\
    break;\
}\


#define SHOW(format, ...)\
{\
    printf( SEPARATOR\
        "File - %s |||| "\
        "Line - %d |||| "\
        "Fnc - %s  |||| "\
        format,\
        __FILE__, __LINE__, __FUNCTION__, __VA_ARGS__);\
}\

#define CHECKSHOW(c, format, ...)\
if(!(c))\
{\
    printf( SEPARATOR\
        "File - %s |||| "\
        "Line - %d |||| "\
        "Fnc - %s  |||| "\
        "Cond - %s  |||| "\
        format,\
        __FILE__, __LINE__, __FUNCTION__, #c, __VA_ARGS__);\
}\


#define CHECKALLOCATED(ptr)\
{CHECK(ptr!=nullptr, false, "Unable to allocated memory");}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                              FILES
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# define OPEN_CLEAN_FILE_WRITE(fp, file_name)\
FILE* ##fp = fopen(file_name.c_str(), "w+");\
CHECK(##fp != nullptr, false, "Unable to init file pointer");\
fprintf(##fp, "");\
fclose(##fp);\
##fp = fopen(file_name.c_str(), "a");\
CHECK(##fp != nullptr, false, "Unable to init file pointer");

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                              MATH
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define PI acos(-1.0)
#define CHECK_VALUE_IN_BOUNDS(vector, i, min, max)\
CHECKBK(min <= vector[i] && vector[i] <= max, "%f value is out of bounds[%d, %d]", vector[i], min, max);\


#define CHECK_VECTOR_IN_BOUNDS(vector, size, min, max)\
for (size_t i = 0; i < size; ++i)\
{\
    CHECK_VALUE_IN_BOUNDS(vector, i, min, max);\
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                              LIB
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

namespace Ardo
{
    namespace OS
    {
        class File
        {

        };
    }

    namespace Collections
    {
        template <typename T>
        bool Copy_buffer(T* dst, T* src, size_t size)
        {
            CHECK(size > 0, false, "Size must be > 0");

            for (size_t i = 0; i < size; ++i)
            {
                dst[i] = src[i];
            }
            return true;
        }
    }

    namespace Math
    {
        namespace Constants
        {
            const double EULER = 0.5772156649f;
            const double EPSILON = 0.00001f;
        }

        template<typename Ret_type, typename Vec_type>
        class Math_function
        {
        public:
            Math_function() {}
            ~Math_function() {}
            virtual Ret_type Calculate(Vec_type* vector, size_t size) = 0;
            virtual double Get_bound() = 0;
        };


        // https://www.sfu.ca/~ssurjano/shubert.html
        template<typename Ret_type, typename Vec_type>
        class Shubert : public Math_function<Ret_type, Vec_type>
        {
            const double SHUBERT_BOUND = 5.12f;
        public:
            Shubert() {}
            ~Shubert() {}
            Ret_type Calculate(Vec_type* vector, size_t size)
            {
                CHECK_VECTOR_IN_BOUNDS(vector, size, -SHUBERT_BOUND, SHUBERT_BOUND);
                Ret_type rez = 0;
                Ret_type rezult = 1;
                for (size_t ja = 0; ja < size; ++ja)
                {
                    for (size_t i = 0; i < 5; ++i)
                    {
                        rez += i * cos((i + 1) * vector[i] + i);
                    }
                    rezult *= rez;
                }
                return rezult;
            }
            virtual double Get_bound()
            {
                return SHUBERT_BOUND;
            }
        };

        // https://www.sfu.ca/~ssurjano/booth.html
        template<typename Ret_type, typename Vec_type>
        class Booth : public Math_function<Ret_type, Vec_type>
        {
            const double BOOTH_BOUND = 10.0f;
        public:
            Booth() {}
            ~Booth() {}
            Ret_type Calculate(Vec_type* vector, size_t size)
            {
                Ret_type rezult = 10 * size;
                for (size_t i = 0; i < size; ++i)
                {
                    CHECK_VALUE_IN_BOUNDS(vector, i, -BOOTH_BOUND, BOOTH_BOUND);
                    rezult += static_cast<Ret_type>(pow(vector[i], 2));
                }
                return rezult;
            }
            virtual double Get_bound()
            {
                return BOOTH_BOUND;
            }
        };

        // https://www.sfu.ca/~ssurjano/rastr.html
        template<typename Ret_type, typename Vec_type>
        class  Rastrigin : public Math_function<Ret_type, Vec_type>
        {
            const double RASTRIGIN_BOUND = 5.12f;
        public:
            Rastrigin() {}
            ~Rastrigin() {}
            Ret_type Calculate(Vec_type* vector, size_t size)
            {
                Ret_type rezult = 10 * size;
                for (size_t i = 0; i < size; ++i)
                {
                    CHECK_VALUE_IN_BOUNDS(vector, i, -RASTRIGIN_BOUND, RASTRIGIN_BOUND);
                    rezult += (pow(vector[i], 2) - 10 * cos(2 * PI * vector[i]));
                }
                return rezult;
            }
            virtual double Get_bound()
            {
                return RASTRIGIN_BOUND;
            }
        };

        // https://www.sfu.ca/~ssurjano/easom.html
        template<typename Ret_type, typename Vec_type>
        class  Easom : public Math_function<Ret_type, Vec_type>
        {
            const double EASOM_BOUND = 100;
        public:
            Easom() {}
            ~Easom() {}
            Ret_type Calculate(Vec_type* vector, size_t size)
            {
                CHECK_VECTOR_IN_BOUNDS(vector, size, -EASOM_BOUND, EASOM_BOUND);
                Ret_type rezult = -cos(vector[0]) * cos(vector[1]) * exp(-pow(vector[0] - PI, 2) - pow(vector[1] - PI, 2));
                return rezult;
            }
            virtual double Get_bound()
            {
                return EASOM_BOUND;
            }
        };
    }

    namespace Numbers
    {
        namespace Constants
        {
            const unsigned int STATISTIC_NUMBER_TIMES_MIN = 30;
            const unsigned int STATISTIC_NUMBER_TIMES_MEDIUM = 100;
            const unsigned int STATISTIC_NUMBER_TIMES_HIGH = 300;
            const unsigned int PRECISION = 6;
            const unsigned int ITERATIONS = 1000;
            const double CHANCE_OF_MUTATION = 0.01;
            const double CHANCE_OF_CROSSOVER = 0.35;
        }

        size_t Get_number_of_bits_for(size_t decimals_number, double lower_bound, double upper_bound)
        {
            return ceil(decimals_number * log2(10) * (upper_bound - lower_bound));
        }

        template <typename T>
        T Get_random(T min, T max)
        {
            if (min == max)
            {
                return min;
            }
            if (min > max)
            {
                std::swap(min, max);
            }
            T result = static_cast <T> (rand()) / (static_cast <T> (RAND_MAX / (max - min)));
            if (result < static_cast <T> (min))
                return result + static_cast <T> (min);
            else if (result > static_cast <T> (max))
                return result + static_cast <T> (min) - static_cast <T> (max);
            return result;
        }

        template <typename T>
        T Get_random_bit()
        {
            return (rand() % 2);
        }

        template <typename T>
        bool Create_random_vector(T* v, unsigned int size, int min, int max)
        {
            CHECK(v != nullptr, false, "Expected an initialized pointer");
            for (int i = 0; i < size; ++i)
            {
                v[i] = Get_random<T>(min, max);
            }
        }

        template <typename T>
        bool Create_random_bitstr(T* v, unsigned int size)
        {
            CHECK(v != nullptr, false, "Expected an initialized pointer");
            for (int i = 0; i < size; ++i)
            {
                v[i] = Get_random_bit<T>(0,1);
            }
        }

        template <typename T>
        T Get_max_value()
        {
            return std::numeric_limits<T>::max();
        }

        template <typename T>
        T Get_min_value()
        {
            return std::numeric_limits<T>::min();
        }

        bool Decode_bitstr(int* bitstr, size_t size, size_t nr_elements, double* result, double lower_bound, double upper_bound)
        {
            double x;
            for (size_t i = 0; i < nr_elements; ++i)
            {
                x = 0;
                for (size_t i = 0; i < size; ++i)
                {
                    x = 2 * x;
                    x += bitstr[i];
                }
                x = x / (pow(2, size) - 1);
                x *= (upper_bound - lower_bound);
                x += lower_bound;
                result[i] = x;
            }
            return true;
        }


        /// <param name='v1'>Vector1. not null</param>
        /// <param name='v2'>Vector2. not null</param>
        /// <param name='result'>Will get the pointer to the min. must be null or not allocated.</param>
        /// <param name='sizeOfVec'>Size of the 2 vectors. Must be greater then 0</param>
        /// <returns>failed=false; true=succeded</returns>
        template <typename T>
        bool Min(T* v1, T* v2, T* result, size_t nr_of_elements)
        {
            CHECK(nr_of_elements > 0, false, "Size must be >0");
            CHECK(v1 != nullptr, false, "Expected non null v1");
            CHECK(v2 != nullptr, false, "Expected non null v2");
            CHECK(result == nullptr, false, "Expected null result. Otherwise, the result memory will leak.");

            result = v2;
            for (size_t i = 0; i < nr_of_elements; ++i)
            {
                if (v1[i] < v2[i])
                {
                    result = v1;
                    return true;
                }
                else
                {
                    result = v2;
                    return true;
                }
            }
            return false;
        }

    }

    namespace Printers
    {
#define CreateTemplatePrintBufferFunction(type, printfId)\
        template<>\
        void Print_buffer<type>(type* v, const size_t size)\
        {\
            _printf("[ BUFFER - %s]\n", typeid(v).name());\
            for (unsigned int i = 0; i < size; ++i)\
            {\
                printf("%"#printfId", ", v[i]);\
            }\
        }\

        template <typename T>
        void Print_buffer(T* v, const size_t size)
        {
            printf("Could not print the buffer. Not implemented.\n");
        }

        CreateTemplatePrintBufferFunction(const char*, c);
        CreateTemplatePrintBufferFunction(char*, c);
        CreateTemplatePrintBufferFunction(const char, c);
        CreateTemplatePrintBufferFunction(char, c);
        CreateTemplatePrintBufferFunction(double, f);
        CreateTemplatePrintBufferFunction(int, d);

#undef CreateTemplatePrintBufferFunction
    }

}

#endif // !__ARDO_H__
