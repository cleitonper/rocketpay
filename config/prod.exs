use Mix.Config

# Database
config :rocketpay, Rocketpay.Repo,
  ssl: true,
  url: System.fetch_env!("DB_URL"),
  pool_size: String.to_integer(System.get_env("DB_POOL_SIZE", "10"))

# Web
config :rocketpay, RocketpayWeb.Endpoint,
  url: [
    host: System.fetch_env!("HOST"),
    port: System.fetch_env!("SSL_PORT")
  ],
  http: [
    port: System.fetch_env!("PORT"),
    transport_options: [socket_opts: [:inet6]]
  ],
  https: [
    port: System.fetch_env!("PORT"),
    keyfile: System.fetch_env!("SSL_KEY_PATH"),
    certfile: System.fetch_env!("SSL_CERT_PATH"),
    transport_options: [socket_opts: [:inet6]],
    cipher_suite: :strong
  ],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

# Logger
config :logger, level: :info
