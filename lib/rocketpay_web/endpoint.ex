defmodule RocketpayWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :rocketpay

  socket "/socket", RocketpayWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug Plug.Static,
    at: "/",
    from: :rocketpay,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :rocketpay
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    pass: ["*/*"],
    parsers: [:urlencoded, :multipart, :json],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug :session
  plug Rocketpay.PrometheusExporter
  plug Rocketpay.PipelineInstrumenter
  plug RocketpayWeb.Router

  defp session(conn, _opts) do
    opts = Plug.Session.init(RocketpayWeb.Session.options())
    Plug.Session.call(conn, opts)
  end
end
