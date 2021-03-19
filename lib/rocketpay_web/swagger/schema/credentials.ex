defmodule RocketpayWeb.Swagger.Schema.Credentials do
  use PhoenixSwagger

  def generate do
    swagger_schema do
      title "Credenciais"
      description """
      Dados necessários para identificar e autenticar um usuário na aplicação.
      É preciso fornecer o nome de usuário ou o e-mail da conta, e a senha de acesso.
      """
      properties do
        email :string, "E-mail da conta", required: false
        nickname :string, "Nome de usuário", required: false
        password :string, "Senha de acesso", required: true
      end
    end
  end
end
