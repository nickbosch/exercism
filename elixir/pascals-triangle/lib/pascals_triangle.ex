defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num), do: pascals(num) |> Enum.reverse()

  defp pascals(1), do: [[1]]

  defp pascals(num) do
    all = [prev | _] = pascals(num - 1)

    [
      [0 | prev]
      |> Enum.chunk_every(2, 1)
      |> Enum.map(&Enum.sum/1)
      | all
    ]
  end
end
