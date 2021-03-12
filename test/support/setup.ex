defmodule Rocketpay.Setup do
  alias Plug.Conn
  alias Rocketpay.Guardian
  alias Rocketpay.Accounts.Deposit
  alias Rocketpay.{Repo, User, Account}

  def create(:user) do
    {:ok, %User{} = user} = Rocketpay.Fake.create(:user)
    %{user: user}
  end

  def create(:account) do
    {:ok, %User{account: account}} = Rocketpay.Fake.create(:user)
    %{account: account}
  end

  def create(:accounts) do
    {:ok, %User{account: from}} = Rocketpay.Fake.create(:user)
    {:ok, %User{account: to}} = Rocketpay.Fake.create(:user)

    Deposit.call(%{"id" => from.id, "amount" => "10.00"})

    %Account{} = from = Repo.get(Account, from.id)

    %{from: from, to: to}
  end

  def auth(%Conn{} = unauthorized) do
    {:ok, user} = Rocketpay.Fake.create(:user)
    %Conn{} = conn = Guardian.Plug.sign_in(unauthorized, user)
    %{conn: conn}
  end
end
