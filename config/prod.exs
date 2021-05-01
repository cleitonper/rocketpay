import Config

# Database
config :rocketpay, Rocketpay.Repo,
  database: "rocketpay"

# Web
config :rocketpay, RocketpayWeb.Endpoint,
  http: [
    transport_options: [socket_opts: [:inet6]]
  ],
  https: [
    transport_options: [socket_opts: [:inet6]],
    cipher_suite: :strong
  ],
  server: true

# Logger
config :logger, level: :info
