defmodule Rocketpay.Users.ShowTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{User, Users, Account}

  describe "Resource: User/Show ⇾" do
    setup [:user]

    test "when the user id is valid, should show the user", %{user: user} do
      %User{
        id: id,
        name: name,
        nickname: nickname,
        email: email,
        age: age,
        account: %Account{
          id: account_id,
          balance: balance,
        }
      } = user

      assert {:ok, %User{
        id: ^id,
        name: ^name,
        nickname: ^nickname,
        email: ^email,
        age: ^age,
        account: %Account{
          id: ^account_id,
          balance: ^balance,
        }
      }} = Users.Show.call(id)
    end
  end

  defp user(_context) do
    Rocketpay.Setup.create(:user)
  end
end
