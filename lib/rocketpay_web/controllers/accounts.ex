defmodule RocketpayWeb.AccountsController do
  use RocketpayWeb, :controller
  use PhoenixSwagger

  alias Rocketpay.{Account, Transaction}
  alias PhoenixSwagger.Schema

  action_fallback RocketpayWeb.FallbackController

  swagger_path :deposit do
    put "/accounts/{id}/deposit"
    summary "Deposito"
    description """
    **Realiza um deposito**
    O deposito é feito na conta de `id` especificado na url da chamada.
    **Retorno da requisição**
    * Caso a requisição não esteja autenticada, retorna **401**
    * Caso o valor do depósito seja inválido, retorna **400**
    * Caso contrário, retorna **200** e a conta com saldo atualizado
    """
    security [%{JWT: []}]
    parameters do
      id :path, :string, "ID da conta", required: true
      operation :body, Schema.ref(:operation), "Valor do depósito", required: true
    end
    response 200, "Success"
    response 400, "Bad Request"
    response 401, "Unauthorized"
  end

  def deposit(conn, params) do
    with {:ok, %Account{} = account} <- Rocketpay.deposit(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  swagger_path :withdraw do
    put "/accounts/{id}/withdraw"
    summary "Saque"
    description """
    **Realiza um saque**
    O saque é feito na conta de `id` especificado na url da chamada.
    **Retorno da requisição**
    * Caso a requisição não esteja autenticada, retorna **401**
    * Caso o usuário logado não seja proprietário da conta, retorna **401**
    * Caso o valor do saque seja inválido ou maior que o saldo da conta, retorna **400**
    * Caso contrário, retorna **200** e a conta com saldo atualizado
    """
    security [%{JWT: []}]
    parameters do
      id :path, :string, "ID da conta", required: true
      operation :body, Schema.ref(:operation), "Valor do depósito", required: true
    end
    response 200, "Success"
    response 400, "Bad Request"
    response 401, "Unauthorized"
  end

  def withdraw(conn, params) do
    with {:ok, %Account{} = account} <- Rocketpay.withdraw(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  swagger_path :transaction do
    put "/accounts/transaction"
    summary "Transferência"
    description """
    **Realiza uma transferência**
    O `valor` da transferência é enviado da conta de `origem` para conta de `destino`.
    **Retorno da requisição**
    * Caso a requisição não esteja autenticada, retorna **401**
    * Caso o usuário logado não seja proprietário da conta de `origem`, retorna **401**
    * Caso o valor da transferência seja inválido ou maior que o saldo da conta de `origem`, retorna **400**
    * Caso contrário, retorna **200** e ambas as contas com saldo atualizado
    """
    security [%{JWT: []}]
    parameters do
      transaction :body, Schema.ref(:transaction), "Valor do depósito", required: true
    end
    response 200, "Success"
    response 400, "Bad Request"
    response 401, "Unauthorized"
  end

  def transaction(conn, params) do
    with {:ok, %Transaction{} = transaction} <- Rocketpay.transaction(params) do
      conn
      |> put_status(:ok)
      |> render("transaction.json", transaction: transaction)
    end
  end

  # coveralls-ignore-start
  def swagger_definitions do
    alias RocketpayWeb.Swagger.Schema

    %{
      operation: Schema.generate(:operation),
      transaction: Schema.generate(:transaction)
    }
  end
  # coveralls-ignore-end
end
