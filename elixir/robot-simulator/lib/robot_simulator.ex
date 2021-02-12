defmodule RobotSimulator do
  @directions [:north, :east, :south, :west]
  defguard is_position(x, y) when is_integer(x) and is_integer(y)
  defguard is_direction(direction) when direction in @directions

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, {x, y}) when is_direction(direction) and is_position(x, y) do
    %{direction: direction, position: {x, y}}
  end

  def create(direction, _) when not is_direction(direction) do
    {:error, "invalid direction"}
  end

  def create(_, _) do
    {:error, "invalid position"}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    instructions
    |> String.graphemes()
    |> Enum.reduce_while(robot, fn instruction, robot ->
      case instruction do
        "L" -> {:cont, turn(robot, :left)}
        "R" -> {:cont, turn(robot, :right)}
        "A" -> {:cont, advance(robot)}
        _ -> {:halt, {:error, "invalid instruction"}}
      end
    end)
  end

  defp turn(robot, direction) when is_atom(direction) do
    %{
      robot
      | direction:
          (Enum.find_index(@directions, fn x -> x == direction(robot) end) +
             case direction do
               :left -> -1
               :right -> 1
             end)
          |> Integer.mod(4)
          |> (&Enum.at(@directions, &1)).()
    }
  end

  defp advance(robot) do
    {x, y} = position(robot)

    %{
      robot
      | position:
          case direction(robot) do
            :north ->
              {x, y + 1}

            :south ->
              {x, y - 1}

            :east ->
              {x + 1, y}

            :west ->
              {x - 1, y}
          end
    }
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%{direction: dir}), do: dir

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%{position: pos}), do: pos
end
