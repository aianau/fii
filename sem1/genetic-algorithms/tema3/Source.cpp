#define _CRT_SECURE_NO_WARNINGS
#include "../Ardo.h"
#include <iostream>
#include <memory>
#include <deque>
#include <cstdint>
#include <string.h>
#include <fstream>
#include <deque>

// For terminology check: "https://en.wikipedia.org/wiki/Valuation_(logic)"
class Proposition
{
private:
    // the index represents the variable. The value of the index represents the assignment of the variable.
    std::deque<bool> assignements; 
    // taken form the file_name. filename: <frb\d+_(\d+)_cnf>. clauses_positive_length = $1.
    uint32_t clauses_positive_length;
    // used for efficiency. To be checked when the fitness function is calculated. 
    // if true, then the number_true_clauses must be calculated again.
    // if false, get value from number_true_clauses.
    bool changed_assignements;
    uint32_t number_true_clauses;
public:
	int fitness;
    explicit Proposition(const uint32_t &number_variables_, uint32_t clauses_positive_length_)
    {
        clauses_positive_length = clauses_positive_length_;
        number_true_clauses = 0;
        changed_assignements = false;
    
        assignements.resize(number_variables_, false);
        for (uint32_t i = 0; i < assignements.size(); i += clauses_positive_length)
        {
            assignements[i] = true;
        }
    }   
    Proposition(const Proposition& copyable)
    {
        *(this) = copyable;
    }
    Proposition(const Proposition&& movable) noexcept 
    {
        clauses_positive_length = movable.clauses_positive_length;
        changed_assignements = movable.changed_assignements;
        number_true_clauses = movable.number_true_clauses;

        assignements = std::move(movable.assignements);
    } 

    Proposition& operator=(const Proposition& copyable)
    {
        clauses_positive_length = copyable.clauses_positive_length;
        changed_assignements = copyable.changed_assignements;
        number_true_clauses = copyable.number_true_clauses;

        assignements.resize(copyable.assignements.size());
        assignements = copyable.assignements;

        return *this;
    }
	bool Subject_cpy(Proposition& cpy)
	{
		changed_assignements = true;
		clauses_positive_length = cpy.clauses_positive_length;

		fitness = cpy.fitness;
		for (int i = 0; i < cpy.assignements.size(); i++)
			assignements.at(i) = cpy.assignements.at(i);
		return 1;
	}
    const uint32_t Get_number_variables() const 
    {
        return assignements.size();
    }
    const uint32_t Get_clauses_positive_length() const 
    {
        return clauses_positive_length;
    }
    const uint32_t Get_number_true_clauses() const 
    {
        return number_true_clauses;
    }
    std::deque<bool> *Get_assignements()
    {
        return &assignements;
    }

    const uint32_t Evaluate(const std::deque<std::pair<uint32_t, uint32_t>> &clauses_negative)
    {
        if (changed_assignements)
        {
            changed_assignements = false;
            uint32_t number_true_clauses_aux = 0;

            for (const auto& it : clauses_negative)
            {
                if ((assignements[it.first] & assignements[it.second]) == false)
                    number_true_clauses_aux += 1;
            }

            number_true_clauses = number_true_clauses_aux;
        }

        return number_true_clauses;
    }
    // TODO silviu: changes the assignements of random variables with a certain chance.
    bool Mutate(int run_index)
    {
		int chance_of_mutation = 0.05;
		if (run_index == 0)
			chance_of_mutation = 1;
        int number_of_long_lines = assignements.size() / clauses_positive_length;
		for (int i = 0; i < number_of_long_lines; i++)
        {
            if (Ardo::Numbers::Get_random<float>(0, 1) < chance_of_mutation)
            {
                changed_assignements = true;
				Mutate_chunk(i);
                // mutate here how you'd like to mutate.
            }
        }
        return true;
    }
	bool Mutate_chunk(int index_long_line)
	{
		//TODO make it more efficent
		for (int k = 0; k < clauses_positive_length; k++)
		{
			assignements.at(index_long_line * clauses_positive_length + k) = 0;
		}
		float j = clauses_positive_length * Ardo::Numbers::Get_random<float>(0, 1);
		assignements.at(index_long_line * clauses_positive_length + int(j)) = 1;
		return true;
	}
};

bool Mutation(std::deque<Proposition>&population,int run_index)
{
    for (Proposition& subject : population)
    {
        subject.Mutate(run_index);
    }
    return true;
}

bool Cross_genes(Proposition& prop1, Proposition& prop2, const uint32_t &point)
{
    std::deque<bool> assigments_aux;

    std::deque<bool> * prop1_assigs = prop1.Get_assignements();
    std::deque<bool> * prop2_assigs = prop2.Get_assignements();    
    
    for (uint32_t i = 0; i < prop1_assigs->size() - point; ++i)
    {
        prop1_assigs->at(i) = prop2_assigs->at(i);
    }
    for (uint32_t i = point; i < prop1_assigs->size(); ++i)
    {
        prop2_assigs->at(i) = prop1_assigs->at(i);
    }

    return true;
}

// Crosses the assigneements of two propositions singled point ( the index of the point depends on the chunks)
bool Cross_over(std::deque<Proposition> & population)
{
    uint32_t point;

    for (uint32_t i = 0; i < population.size() - 1; ++i)
    {
        point = Ardo::Numbers::Get_random<uint32_t>(0, population.at(0).Get_clauses_positive_length());
        point *= population.at(0).Get_clauses_positive_length();
        if (Ardo::Numbers::Get_random<float>(0, 1) < Ardo::Numbers::Constants::CHANCE_OF_CROSSOVER)
        {
            Cross_genes(population.at(i), population.at(i + 1), point);
        }
    }

    return true;
}


// TODO andrei: ruleta
// TODO silviu: 
bool Selection(std::deque<Proposition>& population, std::deque<std::pair<uint32_t, uint32_t>>& clauses_negative, Proposition& proposition_aux)
{
	int max_fit = 0, min_fit = 99999;
	float sum_fit = 0, sum_roulette = 0;
	unsigned int populationSize = 100;
	std::deque<Proposition> population_2;
	population_2.resize(populationSize, proposition_aux);

	std::deque<float> roulette;
	roulette.resize(populationSize);
	for (Proposition& subject : population)
	{
		subject.fitness = subject.Evaluate(clauses_negative);
		if (max_fit < subject.fitness)
			max_fit = subject.fitness;
		if (min_fit > subject.fitness)
			min_fit = subject.fitness;
		sum_fit = subject.fitness + sum_fit;
	}
	printf("max %d , min %d \n", max_fit, min_fit);
	sum_fit = 0;
	for (Proposition& subject : population)
	{
		subject.fitness = subject.fitness - min_fit +1;
		sum_fit = subject.fitness + sum_fit;
	}
	roulette.at(0) = ((float)population.at(0).fitness / (float)sum_fit);
	for (int i = 1; i < populationSize; i++)
	{
		roulette.at(i) = ((float)population.at(i).fitness / (float)sum_fit) + roulette.at(i - 1);
	}
	for (int i = 0; i < populationSize; i++)
	{
		float kk = Ardo::Numbers::Get_random<float>(0, 1);
		for (int j = 0; j < populationSize; j++)
			if (roulette.at(j) > kk)
			{
				population_2.at(i).Subject_cpy(population.at(j));
				break;
			}
	}
	for (int i = 0; i < populationSize; i++)
	{
		population.at(i).Subject_cpy(population_2.at(i));
	}

    return true;
}
int Tournament(int tsize, std::deque<Proposition>& population, unsigned int populationSize)
{
	float maxim_t = 0;
	int index_t = 0;
	std::deque<int> rand_pos;
	rand_pos.resize(populationSize);
	for (int i = 0; i < tsize; i++)
		rand_pos.at(i) = (Ardo::Numbers::Get_random<float>(0, 1) - 0.00001) * populationSize;
	for (int i = 0; i < tsize; i++)
		if (maxim_t < population.at(rand_pos.at(i)).fitness)
		{
			maxim_t = population.at(rand_pos.at(i)).fitness;
			index_t = rand_pos.at(i);
		}
	return index_t;
}
bool Tournament_Selection(std::deque<Proposition>& population, std::deque<std::pair<uint32_t, uint32_t>>& clauses_negative, Proposition& proposition_aux)
{
	int max_fitness = 0;
	unsigned int populationSize = 100;
	std::deque<Proposition> population_2;
	population_2.resize(populationSize, proposition_aux);

	for (Proposition& subject : population)
	{
		subject.fitness = subject.Evaluate(clauses_negative);
		if (subject.fitness > max_fitness)
			max_fitness = subject.fitness;
	}
	printf("%d \n", max_fitness);
	for (int i = 0; i < populationSize; i++)
	{
		int kk = Tournament(3, population, populationSize);
		population_2.at(i).Subject_cpy(population.at(kk));
	}
	for (int i = 0; i < populationSize; i++)
	{
		population.at(i).Subject_cpy(population_2.at(i));
	}

	return 1;
}
bool Init_values_from_file(
    const std::string &cnf_file,
    std::deque<std::pair<uint32_t, uint32_t>> &clauses_negative,
    uint32_t &clauses_positive_length,
    uint32_t &number_variables
    )
{
    FILE* fp_in = fopen(cnf_file.c_str(), "r");
    CHECKSHOW(fp_in != nullptr, "Unable to init file pointer for input");

    uint32_t number_clauses_negative;
    

    char buffer[1024];
    fgets(buffer, 1024, fp_in);
    fscanf(fp_in, "p cnf %d %d\n", &number_variables, &number_clauses_negative);

    std::string cnf_file_name = cnf_file.substr(cnf_file.rfind("\\") + 1);
    clauses_positive_length = atoi(cnf_file_name.substr(6, 2).c_str());
    uint32_t number_rows_positive_clauses = (number_variables / clauses_positive_length);
    number_clauses_negative -= number_rows_positive_clauses;

    clauses_negative.resize(number_clauses_negative);

    for (int i = 0; i < number_rows_positive_clauses; ++i)
    {
        fgets(buffer, 1024, fp_in);
    }

    uint32_t i = 0;
    uint32_t clauses_negative_first = 0;
    uint32_t clauses_negative_second = 0;

    while (i < number_clauses_negative && fscanf(fp_in, "-%d -%d 0\n", &clauses_negative_first, &clauses_negative_second) != NULL)
    {
        clauses_negative[i].first = clauses_negative_first - 1;
        clauses_negative[i].second = clauses_negative_second - 1;
        ++i;
    }
    
    return true;
}


bool Run(FILE *fp_out, std::string input_file)
{
    // we won't keep the first <number_variables/clauses_positive_length> lines because we can calculate them.
    // keep in mind that all the clauses_negative here are negated (because this is how we find them 
    //     in the input file). 
    std::deque<std::pair<uint32_t, uint32_t>> clauses_negative;
    uint32_t number_variables = 0, clauses_positive_length = 0;

    Init_values_from_file(input_file, clauses_negative, clauses_positive_length, number_variables);

    Proposition proposition_aux(number_variables, clauses_positive_length);
    
    std::deque<Proposition> population;
    unsigned int populationSize = 100;
    
    population.resize(populationSize, proposition_aux);
    int best_result = 0;

    
    for (int i = 0; i < Ardo::Numbers::Constants::ITERATIONS; ++i)
    {
        Mutation(population,i);
        Cross_over(population);
		Tournament_Selection(population, clauses_negative, proposition_aux);
        // TODO: if not so bad at performance, print the best out of this itteration to a sepparate file for graphic of how the overall population evolves/behaves.
    }

    uint32_t number_true_clauses;
    for (int i = 0; i < population.size(); ++i)
    {
        number_true_clauses = population.at(i).Get_number_true_clauses();
        if (best_result < number_true_clauses)
        {
            best_result = number_true_clauses;
        }
    }
    fprintf(fp_out, "%d", best_result);
    printf("%d", best_result);

    return true;
}

bool Main(std::string input_file)
{
    std::string output_file(input_file);
    output_file.append(".result");
    
    OPEN_CLEAN_FILE_WRITE(fp_out, output_file);

    for (int i = 0; i < 1 /*Ardo::Numbers::Constants::STATISTIC_NUMBER_TIMES_MIN*/; ++i)
    {
        auto start = std::chrono::system_clock::now();
        printf("iteration %d\n", i);
        Run(fp_out, input_file);
        auto end = std::chrono::system_clock::now();
        printf("iteration %d - ended\n", i);
        std::chrono::duration<double> elapsed_seconds = end - start;
        printf("elapsed time: %f\n", elapsed_seconds.count());
    }
    
    fclose(fp_out);
}

int main()
{
    srand(time(NULL));

    Main(".\\input\\frb30-15-cnf\\frb30-15-1.cnf");

    return 0;
}  
