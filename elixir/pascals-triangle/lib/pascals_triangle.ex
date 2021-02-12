defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(1), do: [[1]]

  def rows(num) do
    prev = rows(num - 1)

    curr =
      List.last(prev)
      |> Enum.chunk_every(2, 1)
      |> Enum.map(&Enum.sum/1)

    prev ++ [[1] ++ curr]
  end
end
