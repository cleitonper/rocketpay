defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias Rocketpay.Fake
  alias RocketpayWeb.UsersView

  describe "View: Users ⇾" do
    setup [:user]

    test "should render show.json", %{user: user} do
      view = render(UsersView, "show.json", user: user)
      expected_view = user

      response = Jason.encode!(view)
      expected_response = Jason.encode!(expected_view)

      assert expected_response === response
    end

    test "should render create.json", %{user: user} do
      view = render(UsersView, "create.json", user: user)
      expected_view = %{message: "User created", user: user}

      response = Jason.encode!(view)
      expected_response = Jason.encode!(expected_view)

      assert expected_response === response
    end
  end

  defp user(_context) do
    {:ok, user} = Fake.create(:user)
    %{user: user}
  end
end
