defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    isbn
    |> String.replace("-", "")
    |> (&(String.match?(&1, ~r/^(\d{9}X|\d{10})$/) and valid_isbn(&1))).()
  end

  defp valid_isbn(isbn) do
    isbn
    |> String.graphemes()
    |> Enum.map(&digit_to_int/1)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {digit, index}, acc -> acc + (10 - index) * digit end)
    |> Integer.mod(11) === 0
  end

  defp digit_to_int("X"), do: 10
  defp digit_to_int(d), do: String.to_integer(d)
end
