defmodule Rocketpay.Setup do
  import Plug.Conn, only: [put_req_header: 3]

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

  def auth(conn) do
    username = Application.get_env(:rocketpay, :basic_auth)[:username]
    password = Application.get_env(:rocketpay, :basic_auth)[:password]
    authorization = Plug.BasicAuth.encode_basic_auth(username, password)
    conn = put_req_header(conn, "authorization", authorization)
    %{conn: conn}
  end
end
