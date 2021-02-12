defmodule Forth do
  defstruct stack: [], words: %{}
  defguard is_operator(x) when x in ["+", "-", "*", "/"]
  @opaque evaluator :: %Forth{}

  defp digit?(s), do: s =~ ~r/^[[:digit:]]+$/

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new, do: %Forth{}

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s),
    do: s |> String.downcase() |> String.split(~r/[\p{C}\s]/u) |> execute(ev)

  defp execute([], ev), do: ev

  defp execute([":", word | tokens], ev = %Forth{words: words}) do
    if digit?(word), do: raise(Forth.InvalidWord, word: word)

    {definition, [_ | tokens]} = Enum.split(tokens, Enum.find_index(tokens, &(&1 === ";")))

    execute(
      tokens,
      %{
        ev
        | words:
            Map.put(
              words,
              word,
              definition
            )
      }
    )
  end

  defp execute([t | _], %Forth{stack: stack}) when is_operator(t) and length(stack) < 2,
    do: raise(Forth.StackUnderflow)

  defp execute([t | tokens], ev = %Forth{stack: [x, y | stack]}) when is_operator(t) do
    try do
      Code.eval_string("trunc(a #{t} b)", a: y, b: x)
    rescue
      ArithmeticError -> raise Forth.DivisionByZero
    else
      {result, _} -> execute(tokens, %{ev | stack: [result | stack]})
    end
  end

  defp execute([t | tokens], ev = %Forth{stack: stack, words: words}) do
    cond do
      digit?(t) ->
        execute(tokens, %{ev | stack: [String.to_integer(t) | stack]})

      Map.has_key?(words, t) ->
        words
        |> Map.get(t)
        |> Enum.reverse()
        |> Enum.reduce(tokens, fn x, acc -> [x | acc] end)
        |> execute(ev)

      true ->
        execute(tokens, %{ev | stack: do_stack_op(t, stack)})
    end
  end

  defp do_stack_op("dup", []), do: raise(Forth.StackUnderflow)
  defp do_stack_op("dup", [x | stack]), do: [x, x | stack]
  defp do_stack_op("drop", []), do: raise(Forth.StackUnderflow)
  defp do_stack_op("drop", [_ | stack]), do: stack
  defp do_stack_op("swap", stack) when length(stack) < 2, do: raise(Forth.StackUnderflow)
  defp do_stack_op("swap", [x, y | stack]), do: [y, x | stack]
  defp do_stack_op("over", stack) when length(stack) < 2, do: raise(Forth.StackUnderflow)
  defp do_stack_op("over", [x, y | stack]), do: [y, x, y | stack]
  defp do_stack_op(word, _), do: raise(Forth.UnknownWord, word: word)

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(%Forth{stack: stack}), do: stack |> Enum.reverse() |> Enum.join(" ")

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
