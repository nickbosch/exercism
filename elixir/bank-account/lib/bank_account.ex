defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    spawn(&loop/0)
  end

  defp loop(account \\ %{balance: 0, open?: true})

  defp loop(account = %{balance: balance, open?: open?}) do
    receive do
      {:get_balance, caller} ->
        send(caller, account)
        loop(account)

      {:update, amount, caller} ->
        account =
          case open? do
            true ->
              %{account | balance: balance + amount}

            _ ->
              account
          end

        send(caller, account)
        loop(account)

      {:close, _caller} ->
        loop(%{account | open?: false})
    end
  end

  defp await_response() do
    receive do
      %{open?: false} -> {:error, :account_closed}
      %{balance: balance} -> balance
    end
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    send(account, {:close, self()})
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    send(account, {:get_balance, self()})
    await_response()
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    send(account, {:update, amount, self()})
    await_response()
  end
end
