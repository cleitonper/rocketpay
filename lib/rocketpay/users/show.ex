defmodule Rocketpay.Users.Show do
  alias Rocketpay.{Repo, User}

  @spec call(Ecto.UUID.t) :: {:ok, User.t} | {:error, :not_found}
  def call(id) do
    case get_user(id) do
      %User{} = user -> {:ok, user}
      nil -> {:error, :not_found}
    end
  rescue
    Ecto.Query.CastError -> {:error, :not_found}
  end

  @spec get_user(Ecto.UUID.t) :: User.t | nil
  defp get_user(id) do
    User
      |> Repo.get(id)
      |> Repo.preload([:account])
  end
end
