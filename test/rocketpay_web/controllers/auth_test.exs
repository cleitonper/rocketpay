defmodule RocketpayWeb.AuthControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.User

  describe "Controller: Auth ⇾" do
    test "when the credentials are valid, should login the user", %{conn: conn} do
      params = Rocketpay.Fake.params(:user)
      credentials = %{"email" => params[:email], "password" => params[:password]}
      {:ok, %User{}} = Rocketpay.create_user(params)

      response =
        conn
        |> post(Routes.auth_path(conn, :login, credentials))
        |> json_response(:ok)

      assert %{
        "token" => _token,
        "user" => _user
      } = response
    end

    test "when the credentials are invalid, should return unauthorized in the response", %{conn: conn} do
      credentials = %{"email" => "email", "password" => "password"}

      conn
      |> post(Routes.auth_path(conn, :login, credentials))
      |> response(:unauthorized)
    end

    test "should logout the logged in user", %{conn: conn} do
      conn
      |> post(Routes.auth_path(conn, :logout))
      |> response(:no_content)
    end
  end
end
