defmodule Rocketpay.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :rocketpay,
    error_handler: Rocketpay.Auth.ErrorHandler,
    module: Rocketpay.Guardian

    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
    plug Guardian.Plug.LoadResource, allow_blank: true
end
