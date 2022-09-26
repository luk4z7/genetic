# list of size 100
population = for _ <- 1..100, do: for _ <- 1..1000, do: Enum.random(0..1)

# list of chromosomes sorted by sum
evaluate = 
  fn population -> 
    Enum.sort_by(population, &Enum.sum/1, &>=/2)  
  end

# function should return a list of tuples 
# consisting of a pair of parents to be combined
selection = 
  fn population -> 
    population
    |> Enum.chunk_every(2) # create a list of pairs
    # This function transforms the list of lists to a list of tuples
    |> Enum.map(&List.to_tuple(&1))
  end

# Crossover is analogous to reproduction
crossover = 
  fn population ->
    # Enum.reduce receive an anonymous function
    # acc is an accumulator
    # p1 and p2 represents parent1 and parent2
    Enum.reduce(population, [], fn {p1, p2}, acc -> 
        # Erlang’s rand module 
        # produces uniform integer between 0 and N-1
        cx_point = :rand.uniform(1000)

        {{h1, t1}, {h2, t2}} = {
          # split returns a tuple of two enumerables 
          Enum.split(p1, cx_point),
          Enum.split(p2, cx_point)
        }

        [h1 ++ t2, h2 ++ t1 | acc]
      end
    )
  end

# This function iterates over the entire population and
# randomly shuffles a chromosome with a probability of 5%.
mutation = 
  fn population -> 
    population
    |> Enum.map(
      fn chromosome ->
        # mutate a small percentage of the population
        if :rand.uniform() < 0.05 do
          Enum.shuffle(chromosome)
        else
          chromosome
        end
      end
    )
  end

# lambda function, that get the reference of it self
# and population
# recursive anonymous function
algorithm = 
  fn population, algorithm -> 
    best = Enum.max_by(population, &Enum.sum/1)
    IO.write("\rCurrent Best: " <> Integer.to_string(Enum.sum(best)))
    if Enum.sum(best) == 1000 do
      best
    else
      population      # Initial Population
      |> evaluate.()  # Evaluate Population
      |> selection.() # Select Parents
      |> crossover.() # Create Children
      |> mutation.()  # Mutate a small percentage of your population
      |> algorithm.(algorithm) # Repeat the Process with new Population
    end
  end

solution = algorithm.(population, algorithm)
IO.write("\n Answer is \n")
IO.inspect solution

