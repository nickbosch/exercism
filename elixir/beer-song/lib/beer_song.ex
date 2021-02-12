defmodule BeerSong do
  defp how_many_bottles(-1), do: "99 bottles"
  defp how_many_bottles(0), do: "no more bottles"
  defp how_many_bottles(1), do: "1 bottle"
  defp how_many_bottles(n), do: "#{n} bottles"

  defp action(0), do: "Go to the store and buy some more"
  defp action(n), do: "Take #{pronoun(n)} down and pass it around"

  defp pronoun(1), do: "it"
  defp pronoun(_), do: "one"

  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(n) do
    """
    #{String.capitalize(how_many_bottles(n))} of beer on the wall, #{how_many_bottles(n)} of beer.
    #{action(n)}, #{how_many_bottles(n - 1)} of beer on the wall.
    """
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    Enum.map_join(range, "\n", &verse/1)
  end
end
