defmodule RocketpayWeb.HomeView do
  def render("routes.json", %{routes: routes}) do
    %{
      name: "Rocketpay API",
      version: "0.0.0",
      routes: routes
    }
  end
end
