defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.split()
    |> Enum.reduce(%{}, fn word, counts ->
      Map.update(counts, word, 1, fn count -> count + 1 end)
    end)
  end
end
