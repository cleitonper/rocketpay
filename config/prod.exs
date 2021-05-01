import Config

# Database
config :rocketpay, Rocketpay.Repo,
  database: "rocketpay"

# Web
config :rocketpay, RocketpayWeb.Endpoint,
  http: [
    transport_options: [socket_opts: [:inet6]]
  ],
  server: true

# Logger
config :logger, level: :info
