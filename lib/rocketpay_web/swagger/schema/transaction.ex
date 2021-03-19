defmodule RocketpayWeb.Swagger.Schema.Transaction do
  use PhoenixSwagger

  def generate do
    swagger_schema do
      title "Transerência"
      description """
      Dados necessários para realizar uma transferência.
      """
      properties do
        amount :string, "Valor da transferência", required: true
        from :string, "ID da conta de origem", required: true
        to :string, "ID da conta de destino", required: true
      end
    end
  end
end
