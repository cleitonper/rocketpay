defmodule RocketpayWeb.UsersControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.Fake

  describe "Controller: Users ⇾" do
    setup [:user, :auth]

    test "when the id is valid, should show an user", %{conn: conn, user: user} do
      expected_response = %{
        "id" => user.id,
        "name" => user.name,
        "nickname" => user.nickname,
        "email" => user.email,
        "age" => user.age,
        "account" => %{
          "id" => user.account.id,
          "balance" => "0.00"
        }
      }

      response =
        conn
        |> get(Routes.users_path(conn, :show, user.id))
        |> json_response(:ok)

      assert expected_response === response
    end

    test "when the id is invalid, should return Not Found in the response", %{conn: conn} do
      expected_response = %{
        "error" => %{
          "message" => "Not Found"
        }
      }

      response =
        conn
        |> get(Routes.users_path(conn, :show, "INVALID_USER_ID"))
        |> json_response(:not_found)

      assert expected_response === response
    end

    test "should create an user", %{conn: conn} do
      params = Fake.params(:user)

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

        expected_response = %{
          "message" => "User created",
          "user" => %{
            "id" => response["user"]["id"],
            "name" => params[:name],
            "nickname" => params[:nickname],
            "email" => params[:email],
            "age" => params[:age],
            "account" => %{
              "id" => response["user"]["account"]["id"],
              "balance" => "0.00"
            }
          }
        }

      assert expected_response === response
    end
  end

  defp user(_context) do
    Rocketpay.Setup.create(:user)
  end

  defp auth(%{conn: conn}) do
    Rocketpay.Setup.auth(conn)
  end
end
