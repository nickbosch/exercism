defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count([_ | tail]), do: 1 + count(tail)
  def count([]), do: 0

  @spec reverse(list) :: list
  def reverse(list, reversed \\ [])
  def reverse([head | tail], reversed), do: reverse(tail, [head | reversed])
  def reverse([], reversed), do: reversed

  @spec map(list, (any -> any)) :: list
  def map([head | tail], f), do: [f.(head) | map(tail, f)]
  def map([], _f), do: []

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([head | tail], f) do
    case(f.(head)) do
      true -> [head | filter(tail, f)]
      _ -> filter(tail, f)
    end
  end
  
  def filter([], _f), do: []

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([head | tail], acc, f), do: reduce(tail, f.(head, acc), f)
  def reduce([], acc, _f), do: acc

  @spec append(list, list) :: list
  def append([head | tail], b), do: [head | append(tail, b)]
  def append([], b), do: b

  @spec concat([[any]]) :: [any]
  def concat([head | tail]), do: append(head, concat(tail))
  def concat([]), do: []
end
