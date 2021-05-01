defmodule Rocketpay.Repo do
  use Ecto.Repo,
    otp_app: :rocketpay,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    case System.get_env("DB_URL") do
      nil -> {:ok, config}
      url -> {:ok, Keyword.put(config, :url, url)}
    end
  end
end
