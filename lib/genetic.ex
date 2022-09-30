alias Types.Chromosome

defmodule Genetic do
  def hello do
    :world
  end

  # opts \\ [] indicates an optional parameter that will 
  # default to an empty list if you pass nothing in its place
  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0)
    # you pass the population into a function evolve
    population
    |> evolve(problem, opts)
  end

  # evolve is designed to model a single evolution in your genetic algorithm
  def evolve(population, problem, opts \\ []) do
    population = evaluate(population, &problem.fitness_function/1, opts)

    best = hd(population)
    IO.write("\nCurrent Best: #{best.fitness}")
    # check blank value
    # if ... == max_fitness do
    if problem.terminate?(population) do
      best
    else
      population
      |> select(opts)
      |> crossover(opts)
      |> mutation(opts)
      |> evolve(problem, opts)
    end
  end

  # This function is a list comprehension that generates 
  # chromosomes using the provided genotype/0 function
  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  # sort chromosomes based on the provided fitness_function
  def evaluate(population, fitness_function, opts \\ []) do
    population
    |> Enum.map(fn chromosome ->
      fitness = fitness_function.(chromosome)
      age = chromosome.age + 1
      %Chromosome{chromosome | fitness: fitness, age: age}
    end)
    |> Enum.sort_by(& &1.fitness, &>=/2)
  end

  # The resulting population is an enumerable of tuples
  def select(population, opts \\ []) do
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple(&1))
  end

  def crossover(population, opts \\ []) do
    population
    |> Enum.reduce(
      [],
      fn {p1, p2}, acc ->
        cx_point = :rand.uniform(length(p1.genes))

        {{h1, t1}, {h2, t2}} = {
          Enum.split(p1.genes, cx_point),
          Enum.split(p2.genes, cx_point)
        }

        {c1, c2} = {
          %Chromosome{p1 | genes: h1 ++ t2},
          %Chromosome{p2 | genes: h2 ++ t1}
        }

        [c1, c2 | acc]
      end
    )
  end

  def mutation(population, opts \\ []) do
    population
    |> Enum.map(fn chromosome ->
      if :rand.uniform() < 0.05 do
        %Chromosome{chromosome | genes: Enum.shuffle(chromosome.genes)}
      else
        chromosome
      end
    end)
  end
end
