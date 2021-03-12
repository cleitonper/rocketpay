defmodule Rocketpay.Auth.ValidateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{User, Auth}

  describe "Resource: Auth/Validate ⇾" do
    test "when the credentials are valid, should return an user" do
      params = Rocketpay.Fake.params(:user)
      {:ok, %User{}} = Rocketpay.create_user(params)

      %{email: email, nickname: nickname, password: password} = params

      assert {:ok, %User{}} = Auth.Validate.call(email, password)
      assert {:ok, %User{}} = Auth.Validate.call(nickname, password)
      assert {:ok, %User{}} = Auth.Validate.call(%{"email" => email, "password" => password})
      assert {:ok, %User{}} = Auth.Validate.call(%{"nickname" => nickname, "password" => password})
    end

    test "when the credentials are insvalid, should return an error" do
      assert {:error, :unauthorized} = Auth.Validate.call("fake", "pass")
    end
  end
end
