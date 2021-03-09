defmodule Rocketpay do
  @moduledoc """
  Módulo responsável por gerenciar os recursos da aplicação,
  como usuários e transações.

  É usado como uma *fachada* que encapsula os detalhes
  de implementação de outros recursos da aplicação, facilitando
  o acesso a funcionalidades internas e servindo também como
  um mapa de quais são as responsabilidades do sistema.
  """

  alias Rocketpay.{Routes, Users}
  alias Rocketpay.Accounts.{Transaction, Deposit, Withdraw}

  defdelegate list_routes(), to: Routes.List, as: :call
  defdelegate show_user(id), to: Users.Show, as: :call
  defdelegate get_user_by(field), to: Users.Get, as: :call
  defdelegate create_user(params), to: Users.Create, as: :call
  defdelegate transaction(params), to: Transaction, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
  defdelegate deposit(params), to: Deposit, as: :call
end
