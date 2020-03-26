#define _CRT_SECURE_NO_WARNINGS
#include "../Ardo.h"
#include <iostream>
#include <memory>

class BitNum
{
private:
    int*        bits;
    size_t      size;
    size_t      nrElements;
    size_t      allocated;
    size_t      totalBits;
    size_t      precision;
    double      lowerBound;
    double      upperBound;
    double*     valuesDecoded;

    size_t      CalculateBitsForCertainPrecision()
    {
        return floor(log2(pow(10, precision) * (upperBound - lowerBound) + 1));
    }
    bool        Mutate(int *bits, size_t index_mutation)
    {
        CHECK(index_mutation < size, false, "Index of mutation bigger than size");
        
        if (bits[index_mutation] == 0)
        {
            bits[index_mutation] = 1;
        }
        else
        {
            bits[index_mutation] = 0;
        }
    }
public:
    explicit    BitNum(size_t _precision, double _lowerBound, double _upperBound, size_t _nrElements)
    {
        precision = _precision;
        lowerBound = _lowerBound;
        upperBound = _upperBound;
        nrElements = _nrElements;
        size = CalculateBitsForCertainPrecision();
        allocated = size * nrElements;
        totalBits = allocated;
        bits = new int[totalBits];
        valuesDecoded = new double[nrElements];

        if (bits == nullptr || valuesDecoded == nullptr)
        {
            allocated = size = 0;
            precision = 0;
            lowerBound = 0;
            upperBound = 0;
        }
        else
        {
            memset(bits, 0, totalBits);
            Ardo::Numbers::CreateRandomBitstr(bits, totalBits);
        }
    }
                ~BitNum()
    {
        if (bits != nullptr)
        {
            delete[]bits;
        }
        if (valuesDecoded != nullptr)
        {
            delete[]valuesDecoded;
        }
    }
    double      DecodeElement(size_t index) const
    {
        CHECK(index < nrElements, false, "Index > nrElements");
        
        double x = 0;
        for (size_t i = index * size; i < (index + 1) * size; ++i)
        {
            x = 2 * x;
            x += bits[i];
        }
        x = x / (pow(2, size) - 1);
        x *= (upperBound - lowerBound);
        x += lowerBound;
        return x;
    }
    /// <returns>Pointer to valuesDecoded member that contains the vector with the decoded bits.</returns>
    double*     DecodeSelf() const
    {
        Ardo::Numbers::DecodeBitstr(bits, size, nrElements, valuesDecoded, lowerBound, upperBound);
        return valuesDecoded;
    }
    double*     RetDecodedSelf() const
    {
        return valuesDecoded;
    }
    bool        Evolve(MathFunctionDefinition(double, double), bool simulatedAnnealing = false, bool firstImprovement = false)
    {
        float temp = 800;
        bool transformed = false;
        int* aux = new int[totalBits];
        int* best = new int[totalBits];

        double* result1 = new double[totalBits];
        double* resultBest = new double[totalBits];

        CHECKALLOCATED(aux);
        CHECKALLOCATED(best);

        memcpy(best, bits, totalBits*sizeof(int));

        for (size_t i = 0; i < size; ++i)
        {
            memcpy(aux, bits, totalBits*sizeof(int));
            Mutate(aux, i);
            
            Ardo::Numbers::DecodeBitstr(aux, size, nrElements, result1, lowerBound, upperBound);
            Ardo::Numbers::DecodeBitstr(best, size, nrElements, resultBest, lowerBound, upperBound);
             
            double funcResultAux = MathFunction(result1, nrElements);
            double funcResultBest = MathFunction(resultBest, nrElements);


            if(funcResultAux < funcResultBest)
            {
                memcpy(best, aux, totalBits * sizeof(int));
                transformed = true;
            }
            else if ( simulatedAnnealing && Ardo::Numbers::GetRandom<double>(0, 1) < pow(Ardo::Math::Constants::EULER, -abs(funcResultAux - funcResultBest)/temp));
            {
                memcpy(best, aux, totalBits * sizeof(int));
                transformed = true;
            }
            temp = temp * 0.65;
            if (transformed && firstImprovement)
            {
                break;
            }
        }
        
        memcpy(bits, best, totalBits * sizeof(int));

        delete[] result1;
        delete[] resultBest;
        delete[] aux;
        delete[] best;
    }
    size_t      GetNrElements()const
    {
        return nrElements;
    } 
    operator double() const
    {
        return DecodeElement(0);
    }
    friend bool operator!= (const BitNum& c1, const BitNum& c2);
    friend bool operator< (const BitNum& c1, const BitNum& c2);
};

/// <summary> Compares the decoded values of the b1 and b2 </summary>
bool operator!= (const BitNum& b1, const BitNum& b2)
{
    CHECK(b1.GetNrElements() == b2.GetNrElements(), true, "");
    
    for (size_t i = 0; i < b1.nrElements; ++i)
    {
        
    }
}
/// <summary> Compares the decoded values of the b1 and b2 </summary>
bool operator< (const BitNum& b1, const BitNum& b2)
{
    if (b1.GetNrElements() < b2.GetNrElements())
    {
        return true;
    }
    if (b1.GetNrElements() > b2.GetNrElements())
    {
        return false;
    }
    double* b1decoded = b1.DecodeSelf();
    double* b2decoded = b2.DecodeSelf();
    double* min = nullptr;
    Ardo::Numbers::Min<double>(b1decoded, b2decoded, min, b1.GetNrElements());
    if (min == b1decoded)
        return true;
    return false;
}



bool Iteration(double lowerBound, double upperBound, FILE *fp)
{
    double max_value = Ardo::Numbers::GetMaxValue<double>();
    size_t nrElements = 1; ////////////////////////// NR DIMENSIONS
    size_t count = 0;
    
    BitNum num(5, 0, 31, nrElements);

    double* min = new double[num.GetNrElements()];

    for (int i = 0; i < num.GetNrElements(); ++i)
    {
        min[i] = max_value;
    }
    for (int i = 0; i < Ardo::Numbers::Constants::ITERATIONS; ++i)
    {
        num.Evolve(Ardo::Math::Tema1p<double, double>, false, true);  //// EVOLVE
        double* decodedNum = num.DecodeSelf();
    }

    double result = Ardo::Math::Tema1p<double>(num.RetDecodedSelf(), nrElements);
    fprintf(fp, "%.10f\n", result);
    delete[] min;
    return true;
}

bool Main(const char *output_file)
{
    OPEN_CLEAN_FILE_WRITE(fp, output_file);
    
    for (int i = 0; i < Ardo::Numbers::Constants::STATISTIC_NUMBER_TIMES_MIN; ++i)
    {
        Iteration(0, 31, fp);
    }
    
    fclose(fp);
}

int main()
{
    srand(time(NULL));
    Main("tema1p-hill-climbing-first-improvement-2D.result");
}  
