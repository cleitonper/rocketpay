defmodule Rocketpay.Accounts.DepositTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{Account, Accounts}

  describe "Resource: Account/Deposit ⇾" do
    setup [:account]

    test "when the amount is valid, should deposit in the account balance", %{account: account} do
      amount = "10.00"
      deposit = %{"id" => account.id, "amount" => amount}
      number_of_deposits = 3

      expected_balance = Decimal.mult(amount, number_of_deposits)

      {:ok, _} = Accounts.Deposit.call(deposit)
      {:ok, _} = Accounts.Deposit.call(deposit)
      {:ok, %Account{balance: balance}} = Accounts.Deposit.call(deposit)

      assert expected_balance === balance
    end

    test "when the amount is invalid, should return an error", %{account: account} do
      amount = "teen"
      deposit = %{"id" => account.id, "amount" => amount}
      assert {:error, {:amount, reason}} = Accounts.Deposit.call(deposit)
      assert "Invalid deposit value" === reason
    end
  end

  defp account(_context) do
    Rocketpay.Setup.create(:account)
  end
end
