defmodule Rocketpay.Fake do
  def create(:user) do
    :user
    |> params
    |> Rocketpay.create_user()
  end

  def params(:user) do
    %{
      name: FakerElixir.Name.name(),
      email: FakerElixir.Internet.email(:popular),
      nickname: FakerElixir.Internet.user_name(),
      password: FakerElixir.Internet.password(:strong),
      age: FakerElixir.Number.between(18..70)
    }
  end
end
