#pragma once
#define _CRT_SECURE_NO_WARNINGS
#include "utils.h"
#include "MathFunctions.h"
#include <ctime>
#include <stdio.h>

bool Init()
{
    /* initialize random seed: */
    srand(time(NULL));
    return true;
}


CreateTema0Random(Booth, -BOOTH_BOUND, BOOTH_BOUND);
CreateTema0Random(Rastrigin, -RASTRIGIN_BOUND, RASTRIGIN_BOUND);
CreateTema0Random(Easom, -EASOM_BOUND, EASOM_BOUND);
CreateTema0Random(Shubert, -SHUBERT_BOUND, SHUBERT_BOUND);

CreateRunIterations(Booth);
CreateRunIterations(Rastrigin);
CreateRunIterations(Easom);
CreateRunIterations(Shubert);

CreateMain(Booth);
CreateMain(Rastrigin);
CreateMain(Easom);
CreateMain(Shubert); 

bool UpdatePosition(double* x, size_t size, double eps)
{
    for (size_t i = 0; i < size; ++i)
    {
        x[i] += eps;
    }
    return true;
}

bool Copy(double* source, double *dest, size_t size)
{
    for (size_t i = 0; i < size; ++i)
    {
        dest[i] = source[i];
    }
    return true;
}

bool IsPositionBetter(double* x, double* xOld, size_t size,double(*mathFunction)(double* x, size_t size, int lowerBound, int upperBound))
{
    return (mathFunction(x, size, -10000, 10000) <
            mathFunction(xOld, size, -10000, 10000));
}

double Min(double *vec, size_t dimensions, int lowerBound, int upperBound, double(*mathFunction)(double*x, size_t size, int lowerBound, int upperBound))
{
    double eps = pow(1, -100000);
    size_t maxSteps = 100000;
    size_t steps = 0;

    double* vOld = new double[dimensions];
    Copy(vec, vOld, dimensions);

    while (steps < maxSteps)
    {
        UpdatePosition(vec, dimensions, -eps);
        if (IsPositionBetter(vec, vOld, dimensions, mathFunction))
        {
            Copy(vec, vOld, dimensions);
        }
        else
        {
            eps = eps / 2;
        }
        steps++;
    }

    delete[] vOld;
    return mathFunction(vec, dimensions, lowerBound, upperBound);
}

bool HillClimbingDet(size_t dimensions, int lowerBound, int upperBound, double(*mathFunction)(double* x, size_t size, int lowerBound, int upperBound), const char* file_name)
{
    // idc about the overflow. It's just a value to jump to another starting point.
    size_t diff = ((lowerBound + upperBound) + 10 ) % 100; 
    double* v = new double[dimensions];
    double min = upperBound;
    double min_aux;

    // init the starting point
    for (size_t i = 0; i < dimensions; ++i)
    {
        v[i] = lowerBound+upperBound;
    }

    
    for (size_t i = 0; i < 10; ++i)
    {
        min_aux = Min(v, dimensions, lowerBound, upperBound, mathFunction);
        printf("%f\n", min_aux);
        if (min > min_aux)
        {
            min = min_aux;
        }
        UpdatePosition(v, dimensions, diff);
    }

    OPEN_CLEAN_FILE_WRITE(fp, file_name);
    CHECK(fprintf(fp, "%f\n", min), false, "Unable to write to file");
    CHECK(fclose(fp) == 0, false, "Uable to close file pointer");
    delete[] v;
    return true;
}

int main()
{
    MainBooth("tema0_booth.txt"); 
    MainRastrigin("tema0_rastrigin.txt");
    MainEasom("tema0_easom.txt");
    MainShubert("tema0_shubert.txt");
    
    //CHECK(HillClimbingDet(2, -BOOTH_BOUND, BOOTH_BOUND, MathFunctions::Booth, "det_booth.result"),
    //    1,
    //    "HillClimbingdet Failed");
    //CHECK(HillClimbingDet(20, -EASOM_BOUND, EASOM_BOUND, MathFunctions::Easom, "det-easom_20.result"),
    //    1,
    //    "HillClimbingdet Failed");
    //CHECK(HillClimbingDet(5, -EASOM_BOUND, EASOM_BOUND, MathFunctions::Easom, "det-easom_5.result"),
    //    1,
    //    "HillClimbingdet Failed");
    //CHECK(HillClimbingDet(2, -EASOM_BOUND, EASOM_BOUND, MathFunctions::Easom, "det-easom_2.result"),
    //    1,
    //    "HillClimbingdet Failed");
    //CHECK(HillClimbingDet(20, -SHUBERT_BOUND, SHUBERT_BOUND, MathFunctions::Shubert, "det-shubert_20.result"),
    //    1,
    //    "HillClimbingdet Failed");
    //CHECK(HillClimbingDet(5, -SHUBERT_BOUND, SHUBERT_BOUND, MathFunctions::Shubert, "det-shubert_5.result"),
    //    1,
    //    "HillClimbingdet Failed");
    //CHECK(HillClimbingDet(2, -SHUBERT_BOUND, SHUBERT_BOUND, MathFunctions::Shubert, "det-shubert_2.result"),
    //    1,
    //    "HillClimbingdet Failed");
    //CHECK(HillClimbingDet(20, -RASTRIGIN_BOUND, RASTRIGIN_BOUND, MathFunctions::Rastrigin, "det-rastrigin_20.result"),
    //    1,
    //    "HillClimbingdet Failed");
    //CHECK(HillClimbingDet(5, -RASTRIGIN_BOUND, RASTRIGIN_BOUND, MathFunctions::Rastrigin, "det-rastrigin_5.result"),
    //    1,
    //    "HillClimbingdet Failed");
    //CHECK(HillClimbingDet(2, -RASTRIGIN_BOUND, RASTRIGIN_BOUND, MathFunctions::Rastrigin, "det-rastrigin_2.result"),
    //    1,
    //    "HillClimbingdet Failed");
    return 0;
}
