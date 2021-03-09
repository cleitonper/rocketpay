use Mix.Config

# Database
config :rocketpay, Rocketpay.Repo,
  database: "rocketpay_test#{System.get_env("MIX_TEST_PARTITION")}",
  username: System.fetch_env!("DB_USERNAME"),
  password: System.fetch_env!("DB_PASSWORD"),
  hostname: System.fetch_env!("DB_HOSTNAME"),
  pool: Ecto.Adapters.SQL.Sandbox

# Web
config :rocketpay, RocketpayWeb.Endpoint,
  http: [port: 4002],
  server: false

# Bcrypt
config :bcrypt_elixir, :log_rounds, 4

# Logger
config :logger, level: :warn
