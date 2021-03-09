defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  action_fallback RocketpayWeb.FallbackController

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Rocketpay.show_user(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  def create(conn, params) do
    with {:ok, user} <- Rocketpay.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end
