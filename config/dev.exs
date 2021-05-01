import Config

# Database
config :rocketpay, Rocketpay.Repo,
  database: "rocketpay_dev",
  show_sensitive_data_on_connection_error: true

# Web
config :rocketpay, RocketpayWeb.Endpoint,
  https: [
    cipher_suite: :strong,
  ],
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
