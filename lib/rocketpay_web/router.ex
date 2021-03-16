defmodule RocketpayWeb.Router do
  use RocketpayWeb, :router

  import Plug.BasicAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :basic_auth, Application.compile_env(:rocketpay, :basic_auth)
  end

  pipeline :authenticated do
    plug Rocketpay.Auth.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :owner do
    plug Rocketpay.Auth.Owner
  end

  scope "/api", RocketpayWeb do
    pipe_through :api

    get "/", HomeController, :index

    post "/auth/login", AuthController, :login
    post "/auth/logout", AuthController, :logout

    post "/users", UsersController, :create
  end

  scope "/api", RocketpayWeb do
    pipe_through [:api, :authenticated]

    put "/accounts/:id/deposit", AccountsController, :deposit
  end

  scope "/api", RocketpayWeb do
    pipe_through [:api, :authenticated, :owner]

    get "/users/:id", UsersController, :show

    put "/accounts/:id/withdraw", AccountsController, :withdraw
    put "/accounts/transaction", AccountsController, :transaction
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery, :auth]
      live_dashboard "/dashboard", metrics: RocketpayWeb.Telemetry
    end
  end
end
