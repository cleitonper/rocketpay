defmodule Rocketpay.Application do
  use Application

  def start(_type, _args) do
    instrument()

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

  defp instrument() do
    Rocketpay.EctoInstrumenter.setup()
    Rocketpay.PhoenixInstrumenter.setup()
    Rocketpay.PipelineInstrumenter.setup()
    Rocketpay.PrometheusExporter.setup()

    Prometheus.Registry.register_collector(:prometheus_process_collector)

    :telemetry.attach(
      "prometheus-ecto",
      [:rocketpay, :repo, :query],
      &Rocketpay.EctoInstrumenter.handle_event/4,
      %{}
    )
  end
end
