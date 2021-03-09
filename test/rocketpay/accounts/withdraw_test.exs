defmodule Rocketpay.Accounts.WithdrawTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.Accounts.{Deposit, Withdraw}

  describe "Resource: Account/Withdraw ⇾" do
    setup [:account]

    test "when the amount is valid, should withdraw in the account balance", %{account: account} do
      amount = "10.00"
      number_of_withdrawals = 3
      initial_deposit = "50.00"
      total_withdraw = Decimal.mult(amount, number_of_withdrawals)

      deposit = %{"id" => account.id, "amount" => initial_deposit}
      withdraw = %{"id" => account.id, "amount" => amount}

      expected_balance = Decimal.sub(initial_deposit, total_withdraw)

      {:ok, _} = Deposit.call(deposit)
      {:ok, _} = Withdraw.call(withdraw)
      {:ok, _} = Withdraw.call(withdraw)
      {:ok, %{balance: balance}} = Withdraw.call(withdraw)

      assert expected_balance == balance
    end

    test "should not reduce the balance below zero", %{account: account} do
      withdraw = %{"id" => account.id, "amount" => "10.00"}
      {:error, changeset} = Withdraw.call(withdraw)
      assert "is invalid" in errors_on(changeset).balance
    end

    test "when the amount is invalid, should return an error", %{account: account} do
      amount = "teen"
      deposit = %{"id" => account.id, "amount" => amount}
      assert {:error, {:amount, reason}} = Withdraw.call(deposit)
      assert "Invalid withdraw value" === reason
    end
  end

  defp account(_context) do
    Rocketpay.Setup.create(:account)
  end
end
