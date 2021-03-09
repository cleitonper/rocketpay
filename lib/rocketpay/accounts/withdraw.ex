defmodule Rocketpay.Accounts.Withdraw do
  alias Rocketpay.Account
  alias Rocketpay.Accounts.Operation

  @spec call(Operation.t) :: {:ok, Account.t} | {:error, Operation.error}
  def call(params) do
    params
    |> Operation.call(:withdraw)
    |> Operation.run_transaction()
  end
end
