defmodule Rocketpay.Users.GetTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{User, Users}

  describe "Resource: User/Get ⇾" do
    setup [:user]

    test "when the field is valid, should return an user", %{user: user} do
      assert {:ok, %User{}} = Users.Get.call(email: user.email)
      assert {:ok, %User{}} = Users.Get.call(nickname: user.nickname)
      assert {:ok, %User{}} = Users.Get.call(%{"email" => user.email})
      assert {:ok, %User{}} = Users.Get.call(%{"nickname" => user.nickname})
    end
  end

  defp user(_context) do
    Rocketpay.Setup.create(:user)
  end
end
