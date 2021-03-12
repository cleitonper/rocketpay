defmodule RocketpayWeb.FallbackController do
  use RocketpayWeb, :controller

  alias Ecto.Changeset
  alias Rocketpay.Account

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(RocketpayWeb.ErrorView)
    |> render("401.json")
  end

  def call(conn, {:error, %Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(RocketpayWeb.ErrorView)
    |> render("400.json", changeset: changeset)
  end

  def call(conn, {:error, error}) do
    call(conn, {:error, to_changeset(error)})
  end

  defp to_changeset({name, message}, changeset \\ %Account{}) do
    changeset
    |> Changeset.change()
    |> Changeset.add_error(name, message)
  end
end
