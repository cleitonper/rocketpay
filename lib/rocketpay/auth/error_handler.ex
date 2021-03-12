defmodule Rocketpay.Auth.ErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    RocketpayWeb.FallbackController.call(conn, {:error, :unauthorized})
  end
end
