defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(n) do
    {how_many_bottles, action, remaing_bottles} =
      case n do
        2 -> {"2 bottles", "Take one down and pass it around", "1 bottle"}
        1 -> {"1 bottle", "Take it down and pass it around", "no more bottles"}
        0 -> {"no more bottles", "Go to the store and buy some more", "99 bottles"}
        _ -> {"#{n} bottles", "Take one down and pass it around", "#{n - 1} bottles"}
      end

    """
    #{String.capitalize(how_many_bottles)} of beer on the wall, #{how_many_bottles} of beer.
    #{action}, #{remaing_bottles} of beer on the wall.
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
