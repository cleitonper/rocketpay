defmodule RocketpayWeb.AuthView do
  alias Rocketpay.Guardian

  def render("login.json", %{conn: conn}) do
    %{
      token: Guardian.Plug.current_token(conn),
      user: Guardian.Plug.current_resource(conn)
    }
  end
end
