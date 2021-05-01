import Config

# Database
config :rocketpay, Rocketpay.Repo,
  port: System.get_env("DB_PORT", "5432"),
  hostname: System.get_env("DB_HOSTNAME"),
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  pool_size: String.to_integer(System.get_env("DB_POOL_SIZE", "10"))

# Web
config :rocketpay, RocketpayWeb.Endpoint,
  url: [
    host: System.fetch_env!("HOST"),
    port: System.fetch_env!("SSL_PORT")
  ],
  http: [
    port: System.fetch_env!("PORT")
  ],
  https: [
    port: System.fetch_env!("SSL_PORT"),
    keyfile: System.fetch_env!("SSL_KEY_PATH"),
    certfile: System.fetch_env!("SSL_CERT_PATH")
  ],
  live_view: [
    signing_salt: System.fetch_env!("SIGNING_SALT")
  ],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

# Authentication
config :rocketpay, :basic_auth,
  username: System.fetch_env!("AUTH_USERNAME"),
  password: System.fetch_env!("AUTH_PASSWORD")

config :rocketpay, Rocketpay.Guardian,
  secret_key: System.fetch_env!("AUTH_SECRET")


# Check database config
db_dev_config = ["DB_PORT", "DB_HOSTNAME", "DB_USERNAME", "DB_PASSWORD"]
db_prod_config = "DB_URL"

if config_env() !== :prod do
  Enum.each(db_dev_config, fn(config) ->
    if System.get_env(config) === nil, do: raise "Required environment variable #{config}"
  end)
else
  if System.get_env(db_prod_config) === nil, do: raise "Required environment variable #{db_prod_config}"
end
