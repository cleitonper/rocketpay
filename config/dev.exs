import Config

# Database
config :rocketpay, Rocketpay.Repo,
  database: "rocketpay_dev",
  port: System.get_env("DB_PORT", "5432"),
  hostname: System.get_env("DB_HOSTNAME"),
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  pool_size: String.to_integer(System.get_env("DB_POOL_SIZE", "10")),
  show_sensitive_data_on_connection_error: true

# Web
config :rocketpay, RocketpayWeb.Endpoint,
  url: [
    host: System.get_env("HOST", "localhost"),
    port: System.get_env("PORT", "4000")
  ],
  http: [
    port: System.get_env("PORT", "4000")
  ],
  https: [
    cipher_suite: :strong,
    certfile: "priv/cert/selfsigned.pem",
    keyfile: "priv/cert/selfsigned_key.pem",
    port: System.get_env("HTTPS_PORT", "4001")
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  debug_errors: true,
  code_reloader: true,
  check_origin: false

# Internacionalization
config :rocketpay, RocketpayWeb.Gettext, default_locale: "pt"

# Plugs
config :phoenix, :plug_init_mode, :runtime

# Stacktrace
config :phoenix, :stacktrace_depth, 20

# Logger
config :logger, :console, format: "[$level] $message\n"
