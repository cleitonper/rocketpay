use Mix.Config

# Ecto
config :rocketpay,
  ecto_repos: [Rocketpay.Repo]

# Database
config :rocketpay, Rocketpay.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# Web
config :rocketpay, RocketpayWeb.Endpoint,
  pubsub_server: Rocketpay.PubSub,
  render_errors: [
    view: RocketpayWeb.ErrorView,
    accepts: ~w(json),
    layout: false
  ],
  live_view: [
    signing_salt: System.fetch_env!("SIGNING_SALT")
  ]

# Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Swagger
config :rocketpay, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: RocketpayWeb.Router,
      endpoint: RocketpayWeb.Endpoint
    ]
  }

config :phoenix_swagger, json_library: Jason

# Authentication
config :rocketpay, :basic_auth,
  username: System.fetch_env!("AUTH_USERNAME"),
  password: System.fetch_env!("AUTH_PASSWORD")

config :rocketpay, Rocketpay.Guardian,
  issuer: "rocketpay",
  secret_key: System.fetch_env!("AUTH_SECRET")

# Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config
import_config "#{Mix.env()}.exs"
