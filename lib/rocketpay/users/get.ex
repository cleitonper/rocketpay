defmodule Rocketpay.Users.Get do
  alias Rocketpay.{Repo, User}

  def call(%{"email" => _email} = field), do: do_call(field)
  def call(%{"nickname" => _nickname} = field), do: do_call(field)
  def call([email: _email] = field), do: get_user_by(field)
  def call([nickname: _nickname] = field), do: get_user_by(field)
  def call(_field), do: {:error, "Invalid field"}

  defp do_call(field) do
    field
    |> to_keywordlist()
    |> get_user_by()
  end

  defp get_user_by(field) do
    user =
      User
      |> Repo.get_by(field)
      |> Repo.preload([:account])

    case user do
      %User{} = user -> {:ok, user}
      nil -> {:error, :not_found}
    end
  end

  defp to_keywordlist(map) do
    map
    |> Map.to_list()
    |> Enum.map(fn {key, value} -> {String.to_existing_atom(key), value} end)
  end
end
