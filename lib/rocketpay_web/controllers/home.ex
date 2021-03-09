defmodule RocketpayWeb.HomeController do
  use RocketpayWeb, :controller

  action_fallback RocketpayWeb.FallbackController

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> render("routes.json", routes: Rocketpay.list_routes())
  end
end
