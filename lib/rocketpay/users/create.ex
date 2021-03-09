defmodule Rocketpay.Users.Create do
  alias Ecto.{Multi, Changeset}
  alias Rocketpay.{Repo, Account, User}

  @spec call(User.params()) :: {:ok, User.t} | {:error, Changeset.t}
  def call(user) do
    Multi.new()
    |> Multi.insert(:user, User.changeset(user))
    |> Multi.run(:account, &create_account/2)
    |> Multi.run(:format, &format/2)
    |> run_transaction()
  end

  @spec create_account(Ecto.Repo.t, %{user: User.t}) :: {:ok, Account.t}
  defp create_account(repo, %{user: user}) do
    %{user_id: user.id}
    |> Account.changeset()
    |> repo.insert()
  end

  @spec format(Ecto.Repo.t, %{user: User.t}) :: {:ok, User.t}
  defp format(repo, %{user: user}) do
    {:ok, repo.preload(user, :account)}
  end

  @spec run_transaction(Multi.t) :: {:ok, User.t} | {:error, Changeset.t}
  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _opration, reason, _changes} -> {:error, reason}
      {:ok, %{format: user}} -> {:ok, user}
    end
  end
end
