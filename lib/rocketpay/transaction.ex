defmodule Rocketpay.Transaction do
  alias Rocketpay.Account
  alias __MODULE__, as: Transaction

  defstruct [:amount, :from, :to]

  @type t :: %Transaction{
    amount: Decimal.t,
    from: Account.t,
    to: Account.t
  }

  @spec build(amount :: Decimal.t, from :: Account.t, to :: Account.t) :: t
  def build(amount, %Account{} = from, %Account{} = to) do
    %Transaction{
      amount: amount,
      from: %Account{
        id: from.id,
        balance: from.balance
      },
      to: %Account{
        id: to.id,
        balance: to.balance
      }
    }
  end
end
