#pragma once
#ifndef __MATH_FUNCTIONS_H__
#define __MATH_FUNCTIONS_H__

#include <math.h>
#define PI acos(-1.0)
#define CHECK_VALUE_IN_BOUNDS(vector, i, min, max)\
CHECKBK(min <= vector[i] && vector[i] <= max, "x value is out of bounds");

#define CHECK_VECTOR_IN_BOUNDS(vector, size, min, max)\
for (size_t i = 0; i < size; ++i)\
{\
    CHECK_VALUE_IN_BOUNDS(vector, i, min, max);\
}

#define SHUBERT_BOUND 5.12f
#define EASOM_BOUND 100
#define BOOTH_BOUND 10
#define RASTRIGIN_BOUND 5.12f


namespace MathFunctions
{
    template<typename T>
    T Shubert(T* x, size_t size, int lowerBound = -SHUBERT_BOUND, int upperBound = SHUBERT_BOUND)
    {
        CHECK_VECTOR_IN_BOUNDS(x, size, lowerBound, upperBound);
        T rez1 = 0;
        T rez2 = 0;
        for (size_t i = 0; i < 5; ++i)
        {
            rez1 += i * cos((i + 1) * x[0] + i);
            rez2 += i * cos((i + 1) * x[1] + i);
        }
        T rezult = rez1 * rez2;
        return rezult;
    }

    template <typename T>
    T Booth(T* x, size_t size, int lowerBound = -BOOTH_BOUND, int upperBound = BOOTH_BOUND)
    {
        CHECK_VECTOR_IN_BOUNDS(x, 2, lowerBound, upperBound);
        return static_cast<T>(pow((x[0] + 2 * x[1] - 7), 2) + pow((2 * x[0] + x[1] - 5), 2));
    }
    
    template<typename T>
    T Rastrigin(T* x, size_t size, int lowerBound = -RASTRIGIN_BOUND, int upperBound = RASTRIGIN_BOUND)
    {
        T rezult = 10 * size;
        for (size_t i = 0; i < size; ++i)
        {
            CHECK_VALUE_IN_BOUNDS(x, i, lowerBound, upperBound);
            rezult += (pow(x[i], 2) - 10 * cos(2 * PI * x[i]));
        }
        return rezult;
    }

    template<typename T>
    T Easom(T* x, size_t size, int lowerBound = -EASOM_BOUND, int upperBound = EASOM_BOUND)
    {
        CHECK_VECTOR_IN_BOUNDS(x, size, lowerBound, upperBound);
        T rezult = -cos(x[0])* cos(x[1]) * exp(-pow(x[0]-PI, 2) - pow(x[1] - PI, 2));
        return rezult;
    }

}
#endif // !__MATH_FUNCTIONS_H__
