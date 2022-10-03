defmodule Speller do
  @behaviour Problem
  alias Types.Chromosome

  # Stream will continuously apply a function
  # the function you want it to apply is Enum.random/1 over every single alphabetical character
  def genotype do
    genes =
      Stream.repeatedly(fn -> Enum.random(?a..?z) end)
      |> Enum.take(34) # 34 different characters
    %Chromosome{genes: genes, size: 34}
  end

  def fitness_function(chromosome) do
    target = "supercalifragilisticexpialidocious"
    guess = List.to_string(chromosome.genes)

    String.jaro_distance(target, guess) # returns the similarity between the two words
  end

  def terminate?([best | _]), do: best.fitness == 1

end

soln = Genetic.run(Speller)
IO.write("\n")
IO.write(soln)
