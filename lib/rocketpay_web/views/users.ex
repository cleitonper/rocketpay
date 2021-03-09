defmodule RocketpayWeb.UsersView do
  alias Rocketpay.{User, Account}

  def render("show.json", %{user: %User{} = user}) do
    user
  end

  def render("create.json", %{user: %User{account: %Account{}} = user}) do
    %{
      message: "User created",
      user: user
    }
  end
end
