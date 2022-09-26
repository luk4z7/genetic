defmodule Genetic do
  def hello do
    :world
  end

  # opts \\ [] indicates an optional parameter that will 
  # default to an empty list if you pass nothing in its place
  def run(fitness_function, genotype, max_fitness, opts \\ []) do
    population = initialize(genotype)
    # you pass the population into a function evolve
    population
    |> evolve(fitness_function, genotype, max_fitness, opts)
  end

  # evolve is designed to model a single evolution in your genetic algorithm
  def evolve(population, fitness_function, genotype, max_fitness, opts \\ []) do
    population = evaluate(population, fitness_function, opts)

    best = hd(population)
    IO.write("\nCurrent Best: #{fitness_function.(best)}")
    # check blank value
    # if ... == max_fitness do
    if fitness_function.(best) == max_fitness do
      best
    else
      population
      |> select(opts)
      |> crossover(opts)
      |> mutation(opts)
      |> evolve(fitness_function, genotype, max_fitness, opts)
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
    |> Enum.sort_by(fitness_function, &>=/2)
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
        cx_point = :rand.uniform(length(p1))

        {{h1, t1}, {h2, t2}} = {
          Enum.split(p1, cx_point),
          Enum.split(p2, cx_point)
        }

        {c1, c2} = {h1 ++ t2, h2 ++ t1}
        [c1, c2 | acc]
      end
    )
  end

  def mutation(population, opts \\ []) do
    population
    |> Enum.map(fn chromosome ->
      if :rand.uniform() < 0.05 do
        Enum.shuffle(chromosome)
      else
        chromosome
      end
    end)
  end
end
