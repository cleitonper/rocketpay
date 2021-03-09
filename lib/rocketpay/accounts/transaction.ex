defmodule Rocketpay.Accounts.Transaction do
  alias Ecto.{Multi, UUID}
  alias Rocketpay.Accounts.Operation
  alias __MODULE__, as: Transaction

  @type t :: %{
    required(amount::String) => Decimal.t,
    required(from::String) => UUID.t,
    required(to::String) => UUID.t
  }

  @spec call(t) :: {:ok, Rocketpay.Transaction.t} | {:error, Operation.error}
  def call(%{"from" => from, "to" => to, "amount" => amount}) do
    Multi.new()
    |> Multi.merge(Transaction, :run, [:withdraw, %{"id" => from, "amount" => amount}])
    |> Multi.merge(Transaction, :run, [:deposit, %{"id" => to, "amount" => amount}])
    |> Operation.run_transaction(amount)
  end

  @spec run(any, Operation.operation, Operation.t) :: Multi.t
  def run(_changes, name, params), do: Operation.call(params, name)
end
