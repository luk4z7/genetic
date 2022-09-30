# problem behaviour
defmodule Problem do
  # access the module Chromosome
  alias Types.Chromosome

  @callback genotype :: Chromosome.t()

  @callback fitness_function(Chromosome.t()) :: number()

  # The question-mark at the end is common to Boolean functions
  # https://hexdocs.pm/elixir/main/naming-conventions.html#trailing-question-mark-foo
  @callback terminate?(Enum.t()) :: boolean()
end
