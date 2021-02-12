defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    Regex.scan(~r/(.)\1*/, string, capture: :first)
    |> Enum.map_join(fn [match] -> encode_char(String.first(match), String.length(match)) end)
  end

  # def encode(string) do
  #   string
  #   |> String.codepoints()
  #   |> encode(1, "")
  # end

  # defp encode([c1, c2 | arr], count, output) when c1 == c2,
  #   do: encode([c2 | arr], count + 1, output)

  # defp encode([c1, c2 | arr], count, output),
  #   do: encode([c2 | arr], 1, output <> encode_char(c1, count))

  # defp encode([c1], count, output), do: output <> encode_char(c1, count)
  # defp encode([], _, _), do: ""

  defp encode_char(char, 1), do: char
  defp encode_char(char, n), do: to_string(n) <> char

  @spec decode(String.t()) :: String.t()
  def decode(string) do
  end
end
