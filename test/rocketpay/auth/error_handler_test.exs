defmodule Rocketpay.Auth.ErrorHandlerTest do
  use RocketpayWeb.ConnCase, async: true

  describe "Resource: Auth/ErrorHandler ⇾" do
    test "when the token is invalid, should return unauthorized in the response", %{conn: conn} do
      conn
      |> get(Routes.users_path(conn, :show, "ID"))
      |> json_response(:unauthorized)
    end
  end
end
