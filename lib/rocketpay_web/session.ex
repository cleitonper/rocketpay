defmodule RocketpayWeb.Session do
  def options do
    [
      store: :cookie,
      key: "__rocketpay",
      signing_salt: System.get_env("SIGNING_SALT")
    ]
  end
end
