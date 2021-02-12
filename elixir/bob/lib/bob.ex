defmodule Bob do
  def hey(input) do
    input_trimmed = input |> String.trim()

    empty? = input_trimmed |> String.length() == 0

    shouting? =
      input_trimmed == input_trimmed |> String.upcase() &&
        input_trimmed != input_trimmed |> String.downcase()

    question? = input_trimmed |> String.ends_with?("?")

    cond do
      question? && shouting? ->
        "Calm down, I know what I'm doing!"

      question? ->
        "Sure."

      shouting? ->
        "Whoa, chill out!"

      empty? ->
        "Fine. Be that way!"

      true ->
        "Whatever."
    end
  end
end
