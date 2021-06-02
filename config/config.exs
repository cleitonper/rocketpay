import Config

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
  http: [
    port: 4000
  ],
  render_errors: [
    view: RocketpayWeb.ErrorView,
    accepts: ~w(json),
    layout: false
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

config :rocketpay, Rocketpay.Guardian,
  issuer: "rocketpay"

# Phoenix
config :phoenix, :json_library, Jason

config :prometheus, Rocketpay.PipelineInstrumenter,
  registry: :default,
  duration_unit: :microseconds,
  labels: [:status_class, :status, :method, :path, :host, :scheme]

# Import environment specific config
import_config "#{config_env()}.exs"
