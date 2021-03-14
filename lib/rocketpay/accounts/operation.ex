defmodule Rocketpay.Accounts.Operation do
  alias Ecto.{UUID, Multi}
  alias Rocketpay.{Account, Transaction, Repo}
  alias __MODULE__, as: Operation

  @type t :: %{
    required(id::String.t) => UUID.t,
    required(amount::String.t) => Decimal.t
  }

  @type operation :: :deposit | :withdraw
  @type account_type :: :account_for_deposit | :account_for_withdraw

  @type response :: {:ok, Account.t} | {:ok, Transaction.t}
  @type error :: {target::atom, message::String.t} | :not_found

  @spec call(params::t, type::operation) :: Multi.t
  def call(%{"id" => id, "amount" => amount}, operation) do
    operations = get_operation_names(operation)

    Multi.new()
    |> Multi.run(operations[:account], Operation, :get_account, [id])
    |> Multi.run(operations[:balance], Operation, :update_balance, [amount, operation])
  end

  @spec get_account(Ecto.Repo.t, any, UUID.t) :: {:ok, Account.t} | {:error, error}
  def get_account(repo, _changes, id) do
    case repo.get(Account, id) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  rescue
    Ecto.Query.CastError -> {:error, :not_found}
  end

  @spec update_balance(Ecto.Repo.t, %{atom => Account.t}, Decimal.t, operation) :: {:ok, Account.t} | {:error, error}
  def update_balance(repo, %{account: account}, amount, operation) do
    operation
    |> run(account, amount)
    |> update_account(repo, account)
  end

  def update_balance(repo, %{account_for_withdraw: account}, amount, :withdraw) do
    update_balance(repo, %{account: account}, amount, :withdraw)
  end

  def update_balance(repo, %{account_for_deposit: account}, amount, :deposit) do
    update_balance(repo, %{account: account}, amount, :deposit)
  end

  @spec update_account(Decimal.t, Ecto.Repo.t, Account.t) :: {:ok, Account.t}
  defp update_account(%Decimal{} = balance, repo, %Account{} = account) do
    %{balance: balance}
    |> Account.changeset(account)
    |> repo.update()
  end

  @spec update_account({:error, error}, Ecto.Repo.t, Account.t) :: {:error, error}
  defp update_account({:error, _reason} = error, _repo, _account) do
    error
  end

  @spec run(operation, Account.t, Decimal.t) :: Decimal.t | {:error, error}
  defp run(operation, %Account{balance: balance}, amount) do
    amount
    |> validate()
    |> calc(balance, operation)
  end

  defp validate(amount), do: Decimal.cast(amount)
  defp calc({:ok, amount}, balance, :deposit), do: Decimal.add(balance, amount)
  defp calc({:ok, amount}, balance, :withdraw), do: Decimal.sub(balance, amount)
  defp calc(:error, _balance, operation), do: {:error, {:amount, "Invalid #{operation} value"}}

  @spec prefix(operation) :: account_type
  defp prefix(operation) do
    String.to_existing_atom("account_for_#{operation}")
  end

  @spec get_operation_names(operation) :: %{account: account_type, balance: operation}
  defp get_operation_names(operation) do
    %{account: prefix(operation), balance: operation}
  end

  @spec run_transaction(Multi.t, Decimal.t | nil) :: response | {:error, error}
  def run_transaction(multi, amount \\ nil) do
    case Repo.transaction(multi) do
      {:error, _opration, reason, _changes} -> {:error, reason}
      {:ok, %{withdraw: from, deposit: to}} -> {:ok, Transaction.build(amount, from, to)}
      {:ok, %{withdraw: account}} -> {:ok, account}
      {:ok, %{deposit: account}} -> {:ok, account}
    end
  end
end
