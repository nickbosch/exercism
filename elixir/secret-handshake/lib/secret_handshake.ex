defmodule SecretHandshake do
  @commands ["wink", "double blink", "close your eyes", "jump"]

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    code
    |> Integer.digits(2)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce([], &reducer/2)
  end

  defp reducer({1, index}, acc) when index === 4, do: Enum.reverse(acc)
  defp reducer({1, index}, acc) when index < 4, do: acc ++ Enum.slice(@commands, index..index)
  defp reducer({_digit, _index}, acc), do: acc
end
