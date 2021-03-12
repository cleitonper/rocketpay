defmodule RocketpayWeb.AuthController do
  use RocketpayWeb, :controller

  alias Rocketpay.Guardian
  alias Rocketpay.Auth.Validate

  action_fallback RocketpayWeb.FallbackController

  def login(conn, credentials) do
    with {:ok, user} <- Validate.call(credentials) do
      conn
      |> Guardian.Plug.sign_in(user)
      |> put_status(:ok)
      |> render("login.json")
    end
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> send_resp(:no_content, "")
  end
end
