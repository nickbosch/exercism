defmodule RomanNumerals do
  @roman_numerals [
    ["I", "V", "X"],
    ["X", "L", "C"],
    ["C", "D", "M"],
    ["M", "", ""]
  ]
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    number |> Integer.to_string() |> (&numeral(&1, &1 |> String.length())).()
  end

  def numeral(number_str, place) do
    apply(
      RomanNumerals,
      :roman_numeral,
      [String.first(number_str)] ++ (@roman_numerals |> Enum.at(place - 1))
    ) <>
      cond do
        # recursion: remove the first character from number_str and recurse
        place > 0 -> number_str |> String.slice(1..-1) |> numeral(place - 1)
        # base case: when place is 0 we have reached the end of the number
        true -> ""
      end
  end

  @doc """
  Returns the roman numeral equivalent for a single digit `arabic_numeral`. 
  """
  def roman_numeral(arabic_numeral, ones_symbol, fives_symbol, tens_symbol) do
    case arabic_numeral do
      "9" -> ones_symbol <> tens_symbol
      "8" -> fives_symbol <> (ones_symbol |> String.duplicate(3))
      "7" -> fives_symbol <> (ones_symbol |> String.duplicate(2))
      "6" -> fives_symbol <> ones_symbol
      "5" -> fives_symbol
      "4" -> ones_symbol <> fives_symbol
      "3" -> ones_symbol |> String.duplicate(3)
      "2" -> ones_symbol |> String.duplicate(2)
      "1" -> ones_symbol
      _ -> ""
    end
  end
end
