defmodule RocketpayWeb.Swagger.Schema do
  alias RocketpayWeb.Swagger.Schema

  def generate(:user), do: Schema.User.generate()
  def generate(:credentials), do: Schema.Credentials.generate()
  def generate(:transaction), do: Schema.Transaction.generate()
  def generate(:operation), do: Schema.Operation.generate()
end
