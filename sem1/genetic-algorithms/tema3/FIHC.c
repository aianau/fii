#define _CRT_SECURE_NO_WARNINGS
#include "../Ardo.h"
#include <iostream>
#include <memory>
#include <deque>
#include <cstdint>
#include <string.h>
#include <fstream>
#include <deque>
#include <cuda.h>
#include <curand_kernel.h>
#include <stdlib.h>
FILE *fp_out_2;
#define POPSIZE 30
int *neg_val;
bool *assi;
int *neg_val_h = (int*)malloc(sizeof(int) * 500000);
int max_val;
float temp=1000;
__global__ void Evaluate_gpu(bool *assi, int *neg_val, int *rasp, int size, int max_val)
{
	int i = threadIdx.x + blockIdx.x * blockDim.x;
	int num = 0;

	for (int k = 0; k < max_val; k = k + 2)
	{
		if ((assi[i*size + neg_val[k]] & assi[i*size + neg_val[k + 1]]) == false)
			num++;
	}
	rasp[i] = num;
}

// For terminology check: "https://en.wikipedia.org/wiki/Valuation_(logic)"
class Proposition
{
public:
	// the index represents the variable. The value of the index represents the assignment of the variable.

	// taken form the file_name. filename: <frb\d+_(\d+)_cnf>. clauses_positive_length = $1.
	uint32_t clauses_positive_length;
	// used for efficiency. To be checked when the fitness function is calculated. 
	// if true, then the number_true_clauses must be calculated again.
	// if false, get value from number_true_clauses.
	bool changed_assignements;
	uint32_t number_true_clauses;
	std::deque<int> location_pos_assig;
	std::deque<bool> assignements;
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
		float chance_of_mutation = 0.3;
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
		assignements.at(index_long_line * clauses_positive_length+location_pos_assig[index_long_line]) = 0;
		float j = clauses_positive_length * Ardo::Numbers::Get_random<float>(0, 1);
		assignements.at(index_long_line * clauses_positive_length + int(j)) = 1;
		location_pos_assig[index_long_line] = j;
		return true;
	}
};
bool Mutation(std::deque<Proposition>&population, int run_index)
{
	for (Proposition& subject : population)
	{
		subject.Mutate(run_index);
	}
	return true;
}
bool evaluate_GPU(std::deque<Proposition>& population, std::deque<std::pair<uint32_t, uint32_t>>& clauses_negative, Proposition& proposition_aux)
{
	int max_fitness = 0;
	int max_index;
	int size = population.at(0).assignements.size();
	unsigned int populationSize = POPSIZE;
	std::deque<Proposition> population_2;
	population_2.resize(populationSize, proposition_aux);
	int *rasp;
	int rasp_h[5000];
	cudaMalloc(&rasp, sizeof(int) * populationSize);
	bool *assi_h = (bool*)malloc(sizeof(bool)*size*populationSize * 10);



	int k = 0;
	for (Proposition& subject : population)
	{

		for (int i = 0; i < size; i++)
			assi_h[k*size + i] = subject.assignements.at(i);
		k++;

	}					
	cudaMemcpy(assi, assi_h, sizeof(bool)*size * populationSize, cudaMemcpyHostToDevice);
	Evaluate_gpu << <1, POPSIZE >> > (assi, neg_val, rasp, size, max_val);
	cudaDeviceSynchronize();
	cudaMemcpy(rasp_h, rasp, sizeof(float)*populationSize, cudaMemcpyDeviceToHost);
	for (int p = 0; p < POPSIZE; p++)
		fprintf(fp_out_2, "%d ", rasp_h[p]);
	fprintf(fp_out_2, "\n");
	for (int i = 0; i < populationSize; i++)
	{
		population.at(i).fitness = rasp_h[i];
		if (population.at(i).fitness > max_fitness)
		{
			max_fitness = population.at(i).fitness;
			max_index = i;
		}
	}
	int number_of_long_lines = population[0].assignements.size() / population[0].clauses_positive_length;
	int clauses_pos = population[0].clauses_positive_length;
	int sol[1000][POPSIZE];

	for (int pp = 0; pp < 100; pp++)
	{

		auto start = std::chrono::system_clock::now();
		for (int i = 0; i < number_of_long_lines; i++)
		{
			for (int j = 0; j < population[0].clauses_positive_length; j++)
			{
				for (int k = 0; k < populationSize; k++)
				{
					assi_h[k*size + i * clauses_pos + population[k].location_pos_assig[i]] = 0;
					assi_h[k*size + i * clauses_pos + j] = 1;
				}
				cudaMemcpy(assi, assi_h, sizeof(bool)*size * populationSize, cudaMemcpyHostToDevice);
				Evaluate_gpu << <1, POPSIZE >> > (assi, neg_val, rasp, size, max_val);
				cudaDeviceSynchronize();
				cudaMemcpy(rasp_h, rasp, sizeof(float)*populationSize, cudaMemcpyDeviceToHost);
				for (int p = 0; p < populationSize; p++)
				{
					if (rasp_h[p] < population.at(p).fitness)
					{
						assi_h[p*size + i * clauses_pos + j] = 0;
						assi_h[p*size + i * clauses_pos + population[p].location_pos_assig[i]] = 1;

					}
					else
					{
						population.at(p).fitness = rasp_h[p];
						population.at(p).location_pos_assig[i] = j;
						population.at(p).assignements[i*clauses_pos + j] = 1;
					}


					if (rasp_h[p] > sol[pp][p])
					{
						sol[pp][p] = rasp_h[p];
						max_index = i;
					}
				}
			}

		}		
		int ok = 0;
		for (int p = 0; p < POPSIZE; p++)
		{
			if (sol[pp - 1][p] != sol[pp][p])
			{
				ok = 1;

			}
		}
		if (ok == 0)
			break;
		for (int p = 0; p < POPSIZE; p++)
			fprintf(fp_out_2,"%d ",sol[pp][p]);
		fprintf(fp_out_2, "\n");

		fflush(fp_out_2);
		auto end = std::chrono::system_clock::now();
		std::chrono::duration<double> elapsed_seconds = end - start;
		printf("elapsed time: %f\n", elapsed_seconds.count());
	}
	cudaFree(&rasp);
	free(assi_h);
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

	int k = 0;
	while (i < number_clauses_negative && fscanf(fp_in, "-%d -%d 0\n", &clauses_negative_first, &clauses_negative_second) != NULL)
	{
		clauses_negative[i].first = clauses_negative_first - 1;
		clauses_negative[i].second = clauses_negative_second - 1;
		neg_val_h[k] = clauses_negative_first - 1;
		neg_val_h[k + 1] = clauses_negative_second - 1;
		k = k + 2;
		++i;
	}
	max_val = k;

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
	unsigned int populationSize = POPSIZE;

	population.resize(populationSize, proposition_aux);
	int best_result = 0;
	int number_of_long_lines = population[0].assignements.size() / population[0].clauses_positive_length;
	for (int i = 0; i < POPSIZE; i++)
		population.at(i).location_pos_assig.resize(number_of_long_lines);

	for (int i = 0; i < POPSIZE; i++)
	{
		population.at(i).Mutate(0);
	}
	cudaMemcpy(neg_val, neg_val_h, sizeof(int) * 500000, cudaMemcpyHostToDevice);
		
	evaluate_GPU(population, clauses_negative, proposition_aux);
		// TODO: if not so bad at performance, print the best out of this itteration to a sepparate file for graphic of how the overall population evolves/behaves.

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
	output_file.append(".FIHC");

	fp_out_2 = fopen(output_file.c_str(), "w+");
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
	cudaMalloc(&neg_val, sizeof(int) * 500000);
	cudaMalloc(&assi, sizeof(int) * 1000000);
	srand(time(NULL));

	Main(".\\input\\frb40-19-cnf\\frb40-19-1.cnf");

	return 0;
}