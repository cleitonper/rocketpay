defmodule Rocketpay.Auth.Validate do
  def call(%{"email" => email, "password" => password}) do
    call(email, password)
  end

  def call(%{"nickname" => nickname, "password" => password}) do
    call(nickname, password)
  end

  def call(username, password) do
    username
    |> parse()
    |> do_call(password)
  end

  defp do_call(field, password) do
    with {:ok, user} <- Rocketpay.get_user_by(field),
         true <- Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      _error ->
        Bcrypt.no_user_verify()
        {:error, :unauthorized}
    end
  end

  defp parse(username) do
    if String.contains?(username, "@"),
      do: [email: username],
      else: [nickname: username]
  end
end
