# This code defines a module Types.Chromosome
defmodule Types.Chromosome do
  # Custom type t
  # __MODULE__ is a macro the replace by the name of the module
  @type t :: %__MODULE__{
          genes: Enum.t(),
          size: integer(),
          fitness: number(),
          age: integer()
        }

  # defstruct [:genes, :size, :fitness, :age]
  # make this chromosome require
  @enforce_keys :genes
  defstruct [:genes, size: 0, fitness: 0, age: 0]
end
