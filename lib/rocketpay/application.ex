defmodule Rocketpay.Application do
  use Application

  def start(_type, _args) do
    children = [
      Rocketpay.Repo,
      RocketpayWeb.Telemetry,
      {Phoenix.PubSub, name: Rocketpay.PubSub},
      RocketpayWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Rocketpay.Supervisor]

    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    RocketpayWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
