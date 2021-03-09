defmodule Rocketpay.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Rocketpay.Account
  alias __MODULE__, as: User

  @type t :: %User{
    name: String.t,
    email: String.t,
    password: String.t,
    password_hash: String.t,
    nickname: String.t,
    inserted_at: Date.t,
    updated_at: Date.t,
    age: integer
  }

  @type params :: %{
    name: String.t,
    email: String.t,
    password: String.t,
    nickname: String.t,
    age: integer
  }

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:name, :age, :email, :password, :nickname]

  @derive {Jason.Encoder, only: [:id, :name, :nickname, :email, :age, :account]}

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :nickname, :string
    has_one :account, Account

    timestamps()
  end

  def changeset(params) do
    %User{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:password, min: 6)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> unique_constraint([:nickname])
    |> unique_constraint([:email])
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
