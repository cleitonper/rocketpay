defmodule Rocketpay.Routes.ListTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.Routes

  describe "Resource: Routes/List ⇾" do
    test "should list the api routes" do
      routes = Routes.List.call()
      assert Enum.count(routes) > 0
    end
  end
end
