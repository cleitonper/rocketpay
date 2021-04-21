defmodule Rocketpay.PipelineInstrumenter do
  use Prometheus.PlugPipelineInstrumenter

  def label_value(:path, conn) do
    case Phoenix.Router.route_info(RocketpayWeb.Router, conn.method, conn.request_path, "") do
      %{route: path} -> path
      _info -> "unkown"
    end
  end

  def label_value(:status, conn) do
    conn.status
  end
end
