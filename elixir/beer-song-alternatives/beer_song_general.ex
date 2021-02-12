defmodule BeerSong do
  @object_name_singular "piece of cake"
  @object_name_plural "pieces of cake"
  @location "in the fridge"
  @preposition "out"

  defp how_many_objects(-1), do: "99 #{@object_name_plural}"
  defp how_many_objects(0), do: "no more #{@object_name_plural}"
  defp how_many_objects(1), do: "1 #{@object_name_singular}"
  defp how_many_objects(n), do: "#{n} #{@object_name_plural}"

  defp action(0), do: "Go to the store and buy some more"
  defp action(n), do: "Take #{pronoun(n)} #{@preposition} and pass it around"

  defp pronoun(1), do: "it"
  defp pronoun(n), do: "one"

  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(n) do
    """
    #{String.capitalize(how_many_objects(n))} #{@location}, #{how_many_objects(n)}.
    #{action(n)}, #{how_many_objects(n - 1)} #{@location}.
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
