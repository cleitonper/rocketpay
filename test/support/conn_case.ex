defmodule RocketpayWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      import RocketpayWeb.ConnCase

      alias RocketpayWeb.Router.Helpers, as: Routes

      @endpoint RocketpayWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Rocketpay.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Rocketpay.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
