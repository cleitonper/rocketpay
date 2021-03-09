defmodule RocketpayWeb.AccountsView do
  alias Rocketpay.{Account, Transaction}

  def render("update.json", %{account: %Account{} = account}) do
    %{
      message: "Balance updated successfully!",
      account: account
    }
  end

  def render("transaction.json", %{transaction: %Transaction{from: from, to: to, amount: amount}}) do
    %{
      message: "Transaction done soccessfully!",
      transaction: %{
        amount: amount,
        from: from,
        to: to
      }
    }
  end
end
