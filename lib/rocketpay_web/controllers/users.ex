defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller
  use PhoenixSwagger

  action_fallback RocketpayWeb.FallbackController

  swagger_path :show do
    get "/users/{id}"
    summary "Exibir usuário"
    description """
    **Exibe detalhes de um usuário**
    * Caso a requisição não esteja autenticada, retorna **401**
    * Caso o usuário logado não seja proprietário da conta, retorna **401**
    * Caso contrário, retorna **200** e os dados do usuário solicitado
    """
    security [%{JWT: []}]
    parameters do
      id :path, :string, "ID do usuário", required: true
    end
    response 200, "Success"
    response 401, "Unauthorized"
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Rocketpay.show_user(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  swagger_path :create do
    post "/users"
    summary "Criar usuário"
    description """
    **Cria um novo usuário**
    * Caso algum campo informado seja inválido, retorna **400**
    * Caso contrário, retorna **200** e os dados do usuário criado
    """
    parameters do
      user :body, Schema.ref(:user), "Dados do usuário", required: true
    end
    response 200, "Success"
    response 400, "Bad Request"
  end

  def create(conn, params) do
    with {:ok, user} <- Rocketpay.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end

  # coveralls-ignore-start
  def swagger_definitions do
    alias RocketpayWeb.Swagger.Schema
    %{user: Schema.generate(:user)}
  end
  # coveralls-ignore-end
end
