defmodule Rocketpay.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rocketpay.User
  alias __MODULE__, as: Account

  @type t :: %Account{
    id: Ecto.UUID.t,
    balance: Decimal.t
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:balance, :user_id]

  @derive {Jason.Encoder, only: [:id, :balance]}

  schema "accounts" do
    field :balance, :decimal
    belongs_to :user, User

    timestamps()
  end

  def changeset(params, account \\ %Account{})

  def changeset(%{balance: _balance} = params, account) do
    account
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end

  def changeset(%{user_id: user_id}, account) do
    changeset(%{user_id: user_id, balance: "0.00"}, account)
  end
end
