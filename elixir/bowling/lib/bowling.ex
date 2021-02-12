defmodule Bowling do
  @last_frame 10
  @game_over 11
  @errors %{
    :pins => {:error, "Pin count exceeds pins on the lane"},
    :negative_roll => {:error, "Negative roll is invalid"},
    :game_over => {:error, "Cannot roll after game is over"},
    :game_in_progress => {:error, "Score cannot be taken until the end of the game"}
  }
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @spec start() :: any
  # {frame number, ball number, roll history}
  def start, do: {1, :first_ball, []}

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """
  @spec roll(any, integer) :: any | String.t()

  # error handling
  def roll(_, roll) when roll < 0, do: @errors[:negative_roll]
  def roll({@game_over, _, _}, _), do: @errors[:game_over]
  def roll({_, :first_ball, _}, roll) when roll > 10, do: @errors[:pins]
  def roll({_, :second_ball, [roll1 | _]}, roll2) when roll1 + roll2 > 10, do: @errors[:pins]

  # spare in last frame
  def roll({@last_frame, :second_ball, rolls = [roll1 | _]}, roll2) when roll1 + roll2 == 10,
    do: {:spare, :first_ball, [roll2 | rolls]}

  def roll({:spare, :first_ball, rolls}, roll), do: {@game_over, nil, [roll | rolls]}

  # strike in last frame
  def roll({@last_frame, :first_ball, rolls}, 10), do: {:strike1, :first_ball, [10 | rolls]}
  def roll({:strike1, :first_ball, rolls}, 10), do: {:strike2, :first_ball, [10 | rolls]}
  def roll({:strike1, :first_ball, rolls}, roll), do: {:strike2, :second_ball, [roll | rolls]}
  def roll({:strike2, _, rolls}, roll), do: {@game_over, nil, [roll | rolls]}

  # strike
  def roll({frame, :first_ball, rolls}, 10), do: {frame + 1, :first_ball, [10 | rolls]}

  # continue
  def roll({frame, :first_ball, rolls}, roll), do: {frame, :second_ball, [roll | rolls]}

  # open / spare
  def roll({frame, :second_ball, rolls}, roll), do: {frame + 1, :first_ball, [roll | rolls]}

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """
  @spec score(any) :: integer | String.t()
  def score({@game_over, _, rolls}), do: rolls |> Enum.reverse() |> score(0)
  def score(_), do: @errors[:game_in_progress]

  defp score([], acc), do: acc
  defp score([x, y, z], acc) when x == 10 or x + y == 10, do: acc + x + y + z
  defp score([x, y, z | rolls], acc) when x == 10, do: score([y, z | rolls], acc + x + y + z)
  defp score([x, y, z | rolls], acc) when x + y == 10, do: score([z | rolls], acc + 10 + z)
  defp score([x, y | rolls], acc) when x + y < 10, do: score(rolls, acc + x + y)
end
