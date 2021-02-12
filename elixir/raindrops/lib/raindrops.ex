defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    [3, 5, 7]
    |> Enum.map_join(fn factor ->
      number |> Integer.mod(factor) |> raindrop(factor)
    end)
    |> digits_if_empty(number)
  end

  defp raindrop(0, 3), do: "Pling"
  defp raindrop(0, 5), do: "Plang"
  defp raindrop(0, 7), do: "Plong"
  defp raindrop(_, _), do: ""

  defp digits_if_empty("", number), do: to_string(number)
  defp digits_if_empty(s, _), do: s
end
