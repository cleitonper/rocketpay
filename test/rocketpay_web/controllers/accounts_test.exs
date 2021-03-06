defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.Accounts.Deposit

  describe "Controller: Accounts ⇾ Deposit ⇾" do
    setup [:deposit]

    test "when the amount is valid, should make a deposit", %{conn: conn, account: account} do
      deposit = %{amount: "10.00"}

      expected_response = %{
        "message" => "Balance updated successfully!",
        "account" => %{"balance" => "10.00", "id" => account.id}
      }

      response =
        conn
        |> put(Routes.accounts_path(conn, :deposit, account.id, deposit))
        |> json_response(:ok)

      assert expected_response === response
    end

    test "when the amount is invalid, should return an error", %{conn: conn, account: account} do
      deposit = %{amount: "teen"}

      expected_response = %{
        "error" => %{
          "message" => "Bad Request",
          "details" => %{"amount" => ["Invalid deposit value"]}
        }
      }

      response =
        conn
        |> put(Routes.accounts_path(conn, :deposit, account.id, deposit))
        |> json_response(:bad_request)

      assert expected_response === response
    end
  end

  describe "Controller: Accounts ⇾ Withdraw ⇾" do
    setup [:withdraw]

    test "when the amount is valid, make a withdraw", %{conn: conn, account: account} do
      withdraw = %{amount: "10.00"}

      expected_response = %{
        "message" => "Balance updated successfully!",
        "account" => %{"balance" => "0.00", "id" => account.id}
      }

      response =
        conn
        |> put(Routes.accounts_path(conn, :withdraw, account.id, withdraw))
        |> json_response(:ok)

      assert expected_response === response
    end

    test "when the amount is invalid, should return an error", %{conn: conn, account: account} do
      withdraw = %{amount: "teen"}

      expected_response = %{
        "error" => %{
          "details" => %{"amount" => ["Invalid withdraw value"]},
          "message" => "Bad Request"
        }
      }

      response =
        conn
        |> put(Routes.accounts_path(conn, :withdraw, account.id, withdraw))
        |> json_response(:bad_request)

      assert expected_response === response
    end
  end

  describe "Controller: Accounts ⇾ Transaction ⇾" do
    setup [:transaction]

    test "when the balance is enough, should transfer the requested amount", %{
      conn: conn,
      from: from,
      to: to
    } do
      transaction = %{from: from.id, to: to.id, amount: "10.00"}

      expected_response = %{
        "message" => "Transaction done soccessfully!",
        "transaction" => %{
          "amount" => "10.00",
          "from" => %{
            "id" => from.id,
            "balance" => "0.00"
          },
          "to" => %{
            "id" => to.id,
            "balance" => "10.00"
          }
        }
      }

      response =
        conn
        |> put(Routes.accounts_path(conn, :transaction, transaction))
        |> json_response(:ok)

      assert expected_response === response
    end
  end

  defp deposit(%{conn: conn}) do
    %{account: account} = Rocketpay.Setup.create(:account)
    %{conn: conn} = Rocketpay.Setup.create(:account, conn)
    %{conn: conn, account: account}
  end

  defp withdraw(%{conn: conn}) do
    %{conn: conn, account: account} = Rocketpay.Setup.create(:account, conn)
    Deposit.call(%{"id" => account.id, "amount" => "10.00"})
    %{conn: conn, account: account}
  end

  defp transaction(%{conn: conn}) do
    Rocketpay.Setup.create(:accounts, conn)
  end
end
