#define _CRT_SECURE_NO_WARNINGS
#include "../Ardo.h"
#include <iostream>
#include <memory>
#include <vector>

#define MathFunctionDefinition(T, R)\
R(*MathFunction)(T* x, size_t size)

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
        CHECK(index_mutation < totalBits, false, "Index of mutation bigger than size");
        
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
                BitNum()
    {
        precision = 0;
        lowerBound = 0;
        upperBound = 0;
        nrElements = 0;
        allocated = 0;
        size = 0;
        totalBits = 0;
        nrElements = 0;
        bits = nullptr;
        valuesDecoded = nullptr;
    }
                BitNum(size_t _precision, double _lowerBound, double _upperBound, size_t _nrElements)
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
            memset(bits, 0, sizeof(int) * totalBits);
            memset(valuesDecoded, 0, sizeof(double) * nrElements);
            Ardo::Numbers::CreateRandomBitstr(bits, totalBits);
        }
    }
                BitNum(const BitNum& bitnumcopy)
    {
        this->precision = bitnumcopy.precision;
        this->lowerBound = bitnumcopy.lowerBound;
        this->upperBound = bitnumcopy.upperBound;
        this->nrElements = bitnumcopy.nrElements;
        this->size = bitnumcopy.size;
        this->allocated = bitnumcopy.allocated;
        this->totalBits = bitnumcopy.totalBits;
        this->bits = new int[bitnumcopy.totalBits];
        for (int i = 0; i < bitnumcopy.totalBits; ++i)
        {
            this->bits[i] = bitnumcopy.bits[i];
        }
        this->valuesDecoded = new double[bitnumcopy.nrElements];
        for (int i = 0; i < bitnumcopy.nrElements; ++i)
        {
            this->valuesDecoded[i] = bitnumcopy.valuesDecoded[i];
        }
    }
                ~BitNum()
    {
        if (bits != nullptr)
        {
            delete[] bits;
            bits = nullptr;
        }
        if (valuesDecoded != nullptr)
        {
            delete[] valuesDecoded;
            valuesDecoded = nullptr;
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
    bool        Evolve(std::unique_ptr<Ardo::Math::MathFunction<double, double>> &mathFunction, bool simulatedAnnealing = false, bool firstImprovement = false)
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
             
            double funcResultAux = mathFunction->Calculate(result1, nrElements);
            double funcResultBest = mathFunction->Calculate(resultBest, nrElements);


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
    bool        EvolveNaturally()
    {
        for (size_t i = 0; i < totalBits; ++i)
        {
            if (Ardo::Numbers::GetRandom<double>(0, 1) < 0.01f)
            {
                Mutate(bits, i);
            }
        }
        return true;
    }
    bool        GetBits(std::vector<int>& bits, std::pair<int, int> range)const
    {
        CHECK(range.first >= 0 && range.second < totalBits, false, "range out of bounds");
        for (int i = 0; i < range.second; ++i)
        {
            bits.push_back(this->bits[i]);
        }
        return true;
    }
    bool        SetBits(std::vector<int>& bits, std::pair<int, int> range)
    {
        CHECK(range.first >= 0 && range.second < totalBits, false, "range out of bounds");
        for (int i = range.first; i < range.second; ++i)
        {
            this->bits[i] = bits[i];
        }
        return true;
    }

    BitNum      operator=(const BitNum& bitnumcopy)
    {
        BitNum res;
        res.precision = bitnumcopy.precision;
        res.lowerBound = bitnumcopy.lowerBound;
        res.upperBound = bitnumcopy.upperBound;
        res.nrElements = bitnumcopy.nrElements;
        res.size = bitnumcopy.size;
        res.allocated = bitnumcopy.allocated;
        res.totalBits = bitnumcopy.totalBits;
        res.bits = new int[bitnumcopy.totalBits];
        for (int i = 0; i < bitnumcopy.totalBits; ++i)
        {
            res.bits[i] = bitnumcopy.bits[i];
        }
        res.valuesDecoded = new double[bitnumcopy.nrElements];
        for (int i = 0; i < bitnumcopy.nrElements; ++i)
        {
            res.valuesDecoded[i] = bitnumcopy.valuesDecoded[i];
        }
        return res;
    }

    size_t      GetNrElements()const
    {
        return nrElements;
    } 
    size_t      GetTotalNrBits()const
    {
        return totalBits;
    }
};

bool Mutation(std::vector<BitNum> &population)
{
    for (BitNum& subject : population)
    {
        subject.EvolveNaturally();
    }
    return true;
}

bool CrossOver(std::vector<BitNum> &population)
{

    for (int i = 0; i < population.size() - 1; i++)
    {
        for (int j = i + 1; j < population.size(); ++j)
        {
            if (Ardo::Numbers::GetRandom<double>(0, 100) < 25.0f)
            {
                std::vector<int> bitsi, bitsj;
                std::pair<int, int> range = std::make_pair<int, int>(Ardo::Numbers::GetRandom<int>(0, population[i].GetNrElements()),
                                                                    Ardo::Numbers::GetRandom<int>(0, population[i].GetNrElements()));
                if (range.first > range.second)
                {
                    std::swap(range.first, range.second);
                }
                bitsi.reserve(range.second + 1);
                bitsj.reserve(range.second + 1);


                population[i].GetBits(bitsi, range);
                population[j].GetBits(bitsj, range);

                population[j].SetBits(bitsj, range);
                population[i].SetBits(bitsi, range);
            }
        }
    }
    return true;
}

int IndexOfSelected(std::vector<double>& selection)
{
    double position = Ardo::Numbers::GetRandom<double>(selection[0], selection[selection.size() - 1]);
    if (position <= selection[0])
    {
        return 0;
    }
    for (int i = 0; i < selection.size() - 1; ++i) 
    {
        if (selection[i] <= position && position < selection[i + 1])
        {
            return i;
        }
    }
    if (position >= selection[selection.size() - 1])
    {
        return selection.size() - 1;
    }
    SHOW("Reached an \"shouldn't reach this point\" point. Analyse why.");
    return 0; // should never reach this return.
}

bool Selection(std::vector<BitNum>& population, std::unique_ptr<Ardo::Math::MathFunction<double, double>> &function)
{
    std::vector<double> fitness;
    std::vector<double> selection;
    fitness.reserve(population.size());
    selection.reserve(population.size());

    double* decodedSelf;
    double max = std::numeric_limits<double>::min();
    double functionResult;


    for (const auto& subject : population)
    {
        decodedSelf = subject.DecodeSelf();
        functionResult = function->Calculate(decodedSelf, subject.GetNrElements());
        fitness.push_back(std::numeric_limits<double>::max() - functionResult);
    }

    selection.push_back(fitness[0]);
    for (int i = 1; i < fitness.size(); ++i)
    {
        selection.push_back(fitness[i] + selection[i-1]);
    }

    for (int i = 0; i < population.size(); ++i)
    {
        int toBeDeleted = IndexOfSelected(selection);
        CHECKSHOW(toBeDeleted < population.size(), "The index of the one that should be deleted is > pop.size()");
        
        int randomWinner = Ardo::Numbers::GetRandom<int>(0, population.size() - 1);
        while (randomWinner == toBeDeleted)
        {
            randomWinner = Ardo::Numbers::GetRandom<int>(0, population.size() - 1);
        }
        population[toBeDeleted] = population[randomWinner];
    }
    return true;
}

bool Iteration(FILE *fp)
{
    std::unique_ptr<Ardo::Math::MathFunction<double, double>> function = std::make_unique<Ardo::Math::Booth<double, double>>();
    
    size_t nrElements = 2; //////////////////////////////////////////////////////// NR DIMENSIONS
    size_t count = 0;
    
    std::vector<BitNum> population;
    unsigned int populationSize = 100;

    population.reserve(populationSize);
    double result;
    double bestResult = std::numeric_limits<double>::max();

    for (int i = 0; i < populationSize; ++i)
    {
        BitNum num(5, -function->GetBound(), function->GetBound(), nrElements);
        population.push_back(num);
    }

    for (int i = 0; i < Ardo::Numbers::Constants::ITERATIONS; ++i)
    {
        Mutation(population);
        CrossOver(population);
        Selection(population, function);
    }

    for (int i = 0; i < population.size(); ++i)
    {
        result = function->Calculate(population[i].DecodeSelf(), population[i].GetNrElements());
        if (result < bestResult)
        {
            bestResult = result;
        }
    }
    fprintf(fp, "%.10f\n", bestResult);
    printf("%.10f\n", bestResult);
    return true;
}

bool Main(const char *output_file)
{
    OPEN_CLEAN_FILE_WRITE(fp, output_file);
    
    for (int i = 0; i < Ardo::Numbers::Constants::STATISTIC_NUMBER_TIMES_MIN; ++i)
    {
        auto start = std::chrono::system_clock::now();
        printf("iteration %d\n", i);
        Iteration(fp);
        auto end = std::chrono::system_clock::now();
        printf("iteration %d - ended\n", i);
        std::chrono::duration<double> elapsed_seconds = end - start;
        printf("elapsed time: %f\n", elapsed_seconds.count());
    }
    
    fclose(fp);
}

int main()
{
    srand(time(NULL));
    Main("booth_2d.result");

    return 0;
}  
