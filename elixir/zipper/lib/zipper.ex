defmodule Zipper do
  alias Zipper, as: Z
  alias BinTree, as: BT
  defstruct [:focus, :path]

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree), do: %Z{focus: bin_tree, path: []}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Z{focus: focus, path: []}), do: focus
  def to_tree(zipper), do: zipper |> up() |> to_tree()

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%Z{focus: %BT{value: value}}), do: value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Z{focus: %BT{left: nil}}), do: nil

  def left(%Z{focus: focus = %BT{left: left}, path: path}),
    do: %Z{focus: left, path: [{:left, focus} | path]}

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Z{focus: %BT{right: nil}}), do: nil

  def right(%Z{focus: focus = %BT{right: right}, path: path}),
    do: %Z{focus: right, path: [{:right, focus} | path]}

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil

  def up(%Z{path: []}), do: nil

  def up(%Z{focus: focus, path: [{:left, node} | path]}),
    do: %Z{focus: %{node | left: focus}, path: path}

  def up(%Z{focus: focus, path: [{:right, node} | path]}),
    do: %Z{focus: %{node | right: focus}, path: path}

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper = %Z{focus: focus}, value),
    do: %{zipper | focus: %{focus | value: value}}

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper = %Z{focus: focus}, left), do: %{zipper | focus: %{focus | left: left}}

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper = %Z{focus: focus}, right),
    do: %{zipper | focus: %{focus | right: right}}
end
