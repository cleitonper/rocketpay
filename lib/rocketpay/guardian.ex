defmodule Rocketpay.Guardian do
  use Guardian, otp_app: :rocketpay

  alias Rocketpay.User

  def subject_for_token(%User{id: id}, _claims), do: {:ok, "User: #{id}"}
  def subject_for_token(_error, _claims), do: {:error, "Invalid user"}

  def resource_from_claims(%{"sub" => "User: " <> id}), do: Rocketpay.show_user(id)
  def resource_from_claims(_claim), do: {:error, "Invalid user"}
end
