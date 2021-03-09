defmodule Rocketpay.HomeControllerTest do
  use RocketpayWeb.ConnCase, async: true

  describe "Controller: Home ⇾" do
    test "should show api details", %{conn: conn} do
      routes = Rocketpay.list_routes()

      response =
        conn
        |> get(Routes.home_path(conn, :index))
        |> json_response(:ok)

      assert %{
        "name" => "Rocketpay API",
        "version" => _version,
        "routes" => ^routes
      } = response
    end
  end
end
