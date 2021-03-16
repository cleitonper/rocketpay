defmodule Rocketpay.Setup do
  alias Plug.Conn
  alias Rocketpay.Guardian
  alias Rocketpay.Accounts.Deposit
  alias Rocketpay.{Repo, User, Account}

  def create(resource, conn \\ nil)

  def create(:user, conn) do
    get(:user, conn)
  end

  def create(:account, conn) do
    get(:account, conn)
  end

  def create(:accounts, conn) do
    %{account: from, conn: conn} = get(:account, conn)
    %{account: to} = get(:account)

    Deposit.call(%{"id" => from.id, "amount" => "10.00"})

    %Account{} = from = Repo.get(Account, from.id)

    %{conn: conn, from: from, to: to}
  end

  def auth(%Conn{} = unauthorized) do
    {:ok, user} = Rocketpay.Fake.create(:user)
    %Conn{} = conn = Guardian.Plug.sign_in(unauthorized, user)
    %{conn: conn, user: user}
  end

  defp get(resource, conn \\ nil)

  defp get(:user, conn) do
    case conn do
      %Conn{} = conn ->
        %{conn: conn, user: user} = auth(conn)
        %{conn: conn, user: user}
      nil ->
        {:ok, user} = Rocketpay.Fake.create(:user)
        %{conn: conn, user: user}
    end
  end

  defp get(:account, conn) do
    case conn do
      %Conn{} = conn ->
        %{conn: conn, user: %User{account: account}} = auth(conn)
        %{conn: conn, account: account}
      nil ->
        {:ok, %User{account: account}} = Rocketpay.Fake.create(:user)
        %{conn: conn, account: account}
    end
  end
end
