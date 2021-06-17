defmodule Rocketpay.Auth.Owner do
  use RocketpayWeb, :controller

  alias Rocketpay.{User, Account, Guardian}

  def init(_opts), do: []

  def call(conn, _opts) do
    with {:ok, requester} <- get_requester(conn),
         {:ok, resource} <- get_resource(conn),
         {:ok, true} <- authorize(requester, resource) do
      conn
    else
      _error ->
        conn
        |> put_status(:unauthorized)
        |> put_view(RocketpayWeb.ErrorView)
        |> render("401.json")
        |> halt()
    end

  end

  defp get_requester(conn) do
    case Guardian.Plug.current_resource(conn) do
      %User{id: id, account: %Account{id: account_id}} -> {:ok, %{user_id: id, account_id: account_id}}
      nil -> {:error, :unauthorized}
    end
  end

  defp get_resource(conn) do
    conn = fetch_query_params(conn)
    name = get_resource_name(conn)
    id = get_resource_id(conn)

    resource = %{String.to_existing_atom("#{name}_id") => id}

    {:ok, resource}
  end

  defp get_resource_name(%Plug.Conn{path_info: [name | _others]}), do: String.slice(name, 0..-2)
  defp get_resource_id(%Plug.Conn{params: %{"from" => id}}), do: id
  defp get_resource_id(%Plug.Conn{params: %{"id" => id}}), do: id

  defp authorize(%{user_id: id}, %{user_id: id}), do: {:ok, true}
  defp authorize(%{account_id: id}, %{account_id: id}), do: {:ok, true}
  defp authorize(_requester, _resource), do: {:error, false}
end
