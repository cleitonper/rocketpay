defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{User, Users, Account}

  describe "Resource: User/Create ⇾" do
    test "when all params are valid, return an user with an empty account" do
      params = %{
        name: "Alonso",
        nickname: "alonso",
        email: "alonso@email.com",
        password: "123456",
        age: 20
      }

      assert {:ok, %User{account: %Account{} = account} = user} = Users.Create.call(params)

      assert user.name === params.name
      assert user.nickname === params.nickname
      assert user.email === params.email
      assert user.age === params.age

      assert account.balance === Decimal.new("0.00")

      assert user.id !== nil
      assert account.id !== nil
    end

    test "when some param is invalid, return an error" do
      params = %{
        name: "",
        email: "",
        nickname: "",
        password: "123",
        age: 15
      }

      {:error, changeset} = Users.Create.call(params)

      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).email
      assert "can't be blank" in errors_on(changeset).nickname
      assert "must be greater than or equal to 18" in errors_on(changeset).age
      assert "should be at least 6 character(s)" in errors_on(changeset).password
    end
  end
end
