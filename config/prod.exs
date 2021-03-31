use Mix.Config

# Database
config :rocketpay, Rocketpay.Repo,
  ssl: true,
  url: System.get_env("DB_URL"),
  pool_size: String.to_integer(System.get_env("DB_POOL_SIZE", "10"))

# Web
config :rocketpay, RocketpayWeb.Endpoint,
  url: [
    host: System.get_env("HOST"),
    port: System.get_env("SSL_PORT")
  ],
  http: [
    port: System.get_env("PORT"),
    transport_options: [socket_opts: [:inet6]]
  ],
  https: [
    port: System.get_env("PORT"),
    keyfile: System.get_env("SSL_KEY_PATH"),
    certfile: System.get_env("SSL_CERT_PATH"),
    transport_options: [socket_opts: [:inet6]],
    cipher_suite: :strong
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Logger
config :logger, level: :info
