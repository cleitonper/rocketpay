defmodule Rocketpay.Accounts.Deposit do
  alias Rocketpay.Account
  alias Rocketpay.Accounts.Operation

  @spec call(Operation.t) :: {:ok, Account.t} | {:error, Operation.error}
  def call(deposit) do
    deposit
    |> Operation.call(:deposit)
    |> Operation.run_transaction()
  end
end
