defmodule RocketpayWeb.ErrorViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  describe "View: Error ⇾" do
    test "should render 404.json" do
      assert render(RocketpayWeb.ErrorView, "404.json", []) == %{error: %{message: "Not Found"}}
    end

    test "should render 500.json" do
      assert render(RocketpayWeb.ErrorView, "500.json", []) == %{error: %{message: "Internal Server Error"}}
    end
  end
end
