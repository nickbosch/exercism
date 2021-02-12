defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    Regex.scan(~r/^[[:alpha:]]|(?<=[\s_-])[[:alpha:]]|[[:upper:]](?=[[:lower:]])/, string)
    |> List.to_string()
    |> String.upcase()
  end
end
