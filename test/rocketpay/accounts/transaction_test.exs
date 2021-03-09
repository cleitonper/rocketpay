defmodule Rocketpay.Accounts.TransactionTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.Accounts.Transaction

  describe "Resource: Account/Transaction ⇾" do
    setup [:accounts]

    test "when the balance is enough, should transfer the requested amount", %{from: from, to: to} do
      transaction = %{"from" => from.id, "to" => to.id, "amount" => "10.00"}

      assert from.balance === Decimal.new("10.00")
      assert to.balance === Decimal.new("0.00")

      {:ok, %{from: from, to: to}} = Transaction.call(transaction)

      assert from.balance === Decimal.new("0.00")
      assert to.balance === Decimal.new("10.00")
    end
  end

  defp accounts(_context) do
    Rocketpay.Setup.create(:accounts)
  end
end
