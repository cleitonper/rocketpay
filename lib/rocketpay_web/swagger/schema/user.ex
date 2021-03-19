defmodule RocketpayWeb.Swagger.Schema.User do
  use PhoenixSwagger

  def generate do
    swagger_schema do
      title "Usuário"
      description """
      Informações de um usuário da aplicação.
      """
      properties do
        name :string, "Nome", required: true
        age :integer, "Idade", required: true
        email :string, "E-mail da conta", required: true
        nickname :string, "Nome de usuário", required: true
        password :string, "Senha de acesso", required: true
      end
    end
  end
end
