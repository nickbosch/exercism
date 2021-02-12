defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split(" ")
    |> Enum.map_join(" ", fn word ->
      (word
       |> String.graphemes()
       |> Enum.reduce_while(word, fn letter, acc ->
         cond do
           word =~ ~r/^[xy][^aeiou]/i or
               (letter =~ ~r/[aeiou]/i and !(String.last(acc) <> letter === "qu")) ->
             {:halt, acc}

           true ->
             {:cont, String.slice(acc, 1..-1) <> letter}
         end
       end)) <> "ay"
    end)
  end
end
