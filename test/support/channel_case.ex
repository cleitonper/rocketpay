defmodule RocketpayWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Phoenix.ChannelTest
      import RocketpayWeb.ChannelCase

      @endpoint RocketpayWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Rocketpay.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Rocketpay.Repo, {:shared, self()})
    end

    :ok
  end
end
