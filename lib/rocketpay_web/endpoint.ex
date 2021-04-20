defmodule RocketpayWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :rocketpay

  @session_options [
    store: :cookie,
    key: "__rocketpay",
    signing_salt: System.fetch_env!("SIGNING_SALT")
  ]

  socket "/socket", RocketpayWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :rocketpay,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :rocketpay
  end

  plug Phoenix.LiveDashboard.RequestLogger, param_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    pass: ["*/*"],
    parsers: [:urlencoded, :multipart, :json],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug Rocketpay.PrometheusExporter
  plug Rocketpay.PipelineInstrumenter
  plug RocketpayWeb.Router
end
