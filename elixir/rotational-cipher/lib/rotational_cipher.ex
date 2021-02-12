defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    text
    |> String.to_charlist()
    |> Enum.map_join(fn
      c when c in ?a..?z -> <<Integer.mod(c - ?a + shift, 26) + ?a>>
      c when c in ?A..?Z -> <<Integer.mod(c - ?A + shift, 26) + ?A>>
      c -> <<c>>
    end)
  end
end
