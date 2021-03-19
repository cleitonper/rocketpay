defmodule RocketpayWeb.Swagger.Schema.Operation do
  use PhoenixSwagger

  def generate do
    swagger_schema do
      title "Operação"
      description """
      Dados necessários para realizar uma operação de saque ou depósito em conta.
      """
      properties do
        amount :string, "Valor da operação", required: true
      end
    end
  end
end
