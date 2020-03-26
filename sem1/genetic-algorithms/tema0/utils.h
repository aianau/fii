#pragma once
#ifndef __UTILS_H__
#define __UTILS_H__

#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */
#include <stdio.h>
#include <limits>
#include <typeinfo>

/////////////////////////////////////////
//              DEFINES
/////////////////////////////////////////

// CONSTANTS
#define NUMBER_OF_ITERATIONS 5000U
#define STATISTIC_NUMBER_OF_TIMES 3000

// PRINTERS
#define SEPARATOR "\n"\
"==============\n"\
"==============\n"

#define _NO_CRT_STDIO_INLINE
#define _printf(...)\
printf(SEPARATOR __VA_ARGS__);



// CHECKERS
#define CHECK(c, ret, ...)\
if(!(c))\
{\
    printf("\n"\
            "##############\n"\
            "##############\n"\
            __VA_ARGS__);\
    return ret;\
}

#define CHECKBK(c, ...)\
if(!(c))\
{\
    printf("\n"\
            "##############\n"\
            "##############\n"\
            __VA_ARGS__);\
    break;\
}

#define CHECKSHOW(c, ...)\
if(!(c))\
{\
    printf("\n"\
            "##############\n"\
            "##############\n"\
            __VA_ARGS__);\
}


// FILES
# define OPEN_CLEAN_FILE_WRITE(fp, file_name)\
FILE* ##fp = fopen(file_name, "w+");\
CHECK(##fp != nullptr, false, "Unable to init file pointer");\
fprintf(##fp, "");\
fclose(##fp);\
##fp = fopen(file_name, "a");\
CHECK(##fp != nullptr, false, "Unable to init file pointer");

///@brief alalal
namespace Utils
{

    /////////////////////////////////////////
    //              CREATORS
    /////////////////////////////////////////

    template <typename T>
    T GetRandom(int min, int max)
    {
        T result = static_cast <T> (rand()) / (static_cast <T> (RAND_MAX / (max - min)));
        if (result < static_cast <T> (min))
            return result + static_cast <T> (min);
        else if (result > static_cast <T> (max))
            return result + static_cast <T> (min) - static_cast <T> (max);
        return result;
    }

    template <typename T>
    void CreateRandomVector(T* v, unsigned int size, int min, int max)
    {
        for (int i = 0; i < size; ++i)
        {
            v[i] = GetRandom<T>(min, max);
        }
    }

    template <typename T>
    T GetMaxValue()
    {
        return std::numeric_limits<T>::max();
    }

#define CreateTema0Random(mathFunction, minValue, maxValue)\
template <typename T>\
T Tema0##mathFunction(const size_t vectorSize)\
{\
    T* v;\
    v = new T[vectorSize];\
    Utils::CreateRandomVector<T>(v, vectorSize, minValue, maxValue);\
    T result = MathFunctions::##mathFunction<T>(v, vectorSize);\
    delete[] v;\
    return result;\
}

#define CreateRunIterations(mathFunction)\
template <typename T>\
bool RunIterations##mathFunction(size_t numIter, FILE*& fp)\
{\
    T min = Utils::GetMaxValue<T>();\
    T min_aux;\
    for (unsigned int i = 0; i < numIter; ++i)\
    {\
        min_aux = Tema0##mathFunction<T>(5);\
        if (min_aux < min)\
        {\
            min = min_aux;\
        }\
    }\
    CHECK(fprintf(fp, "%f\n", min), false, "Unable to write to file")\
        return true;\
}
#define CreateMain(mathFunction)\
bool Main##mathFunction(const char* output_file)\
{\
    Init();\
    OPEN_CLEAN_FILE_WRITE(fp, output_file);\
\
    std::clock_t begin = clock();\
    for (int i = 0; i < STATISTIC_NUMBER_OF_TIMES; ++i)\
    {\
        RunIterations##mathFunction<double>(NUMBER_OF_ITERATIONS, fp);\
    }\
    std::clock_t end = clock();\
    CHECK(fclose(fp) == 0, false, "Uable to close file pointer");\
    double elapsedSecs = double(end - begin) / CLOCKS_PER_SEC;\
    _printf("[ TIME IN TOTAL ] %f", elapsedSecs);\
}


    /////////////////////////////////////////
    //              PRINTERS
    /////////////////////////////////////////




#define CreateTemplatePrintBufferFunction(type, printfId)\
    template<>\
    void PrintBuffer<type>(type* v, const size_t size)\
    {\
        _printf("[ BUFFER - %s]\n", typeid(v).name());\
        for (unsigned int i = 0; i < size; ++i)\
        {\
            printf("%"#printfId", ", v[i]);\
        }\
    }


    template <typename T>
    void PrintBuffer(T* v, const size_t size)
    {
        _printf("Could not print the buffer. Not implemented.\n");
    }

    CreateTemplatePrintBufferFunction(const char*, c);
    CreateTemplatePrintBufferFunction(char*, c);
    CreateTemplatePrintBufferFunction(const char, c);
    CreateTemplatePrintBufferFunction(char, c);
    CreateTemplatePrintBufferFunction(double, f);
    CreateTemplatePrintBufferFunction(int, d)

}
#endif // !__UTILS_H__