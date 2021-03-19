defmodule RocketpayWeb.AuthController do
  use RocketpayWeb, :controller
  use PhoenixSwagger

  alias Rocketpay.Guardian
  alias Rocketpay.Auth.Validate
  alias PhoenixSwagger.Schema

  action_fallback RocketpayWeb.FallbackController

  swagger_path :login do
    post "/auth/login"
    summary "Login"
    description """
    **Autentica um usuário na aplicação**
    O login pode ser feito usando `nickname` ou `email`, e a `senha` da conta.
    * Caso as _credenciais_ fornecidas sejam válidas, retorna **200** e um **token**
    * Caso contrário, retorna **401**

    **Uso do token**
    O token retornado deve ser enviado nas próximas requisições via `header`
    da seguinte forma: `Authorization: Bearer token`
    """
    parameters do
      credentials :body, Schema.ref(:credentials), "Credenciais de acesso"
    end
    response 200, "Success"
    response 401, "Unauthorized"
  end

  def login(conn, credentials) do
    with {:ok, user} <- Validate.call(credentials) do
      conn
      |> Guardian.Plug.sign_in(user)
      |> put_status(:ok)
      |> render("login.json")
    end
  end

  swagger_path :logout do
    post "/auth/logout"
    summary "Logout"
    description """
    **Remove dados de autenticação da seção**
    Não é necessário usar essa rota para fazer logout,
    pois não é possível invalidar um token JWT.
    Em uma próxima versão, ela poderá usada para por tokens
    em uma _lista de bloqueio_.
    **Então como fazer logout?**
    Para fazer logout, na aplicação cliente, basta apagar
    o token recebido na requisição de login.
    """
    response 204, "No Content"
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> send_resp(:no_content, "")
  end

  # coveralls-ignore-start
  def swagger_definitions do
    alias RocketpayWeb.Swagger.Schema
    %{credentials: Schema.generate(:credentials)}
  end
  # coveralls-ignore-end
end
