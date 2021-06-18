defmodule RocketpayWeb.Router do
  use RocketpayWeb, :router

  import Redirect
  import Plug.BasicAuth

  @version Mix.Project.config()[:version]

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :basic_auth, Application.get_env(:rocketpay, :basic_auth)
  end

  pipeline :authenticated do
    plug Rocketpay.Auth.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :owner do
    plug Rocketpay.Auth.Owner
  end

  scope "/", RocketpayWeb do
    pipe_through :api

    post "/auth/login", AuthController, :login
    post "/auth/logout", AuthController, :logout

    post "/users", UsersController, :create
  end

  scope "/", RocketpayWeb do
    pipe_through [:api, :authenticated]

    put "/accounts/:id/deposit", AccountsController, :deposit
  end

  scope "/", RocketpayWeb do
    pipe_through [:api, :authenticated, :owner]

    get "/users/:id", UsersController, :show

    put "/accounts/:id/withdraw", AccountsController, :withdraw
    put "/accounts/transaction", AccountsController, :transaction
  end

  forward "/swagger", PhoenixSwagger.Plug.SwaggerUI,
    otp_app: :rocketpay,
    swagger_file: "swagger.json"

  redirect "/", "/swagger", :permanent

  def swagger_info do
    %{
      info: %{
        version: @version,
        title: "Rocketpay",
        description: "Sistema para processamento de transações financeiras",
        contact: %{
          name: "Cleiton da Silva",
          email: "cleiton.spereira@live.com"
        }
      },
      securityDefinitions: %{
        JWT: %{
          in: "header",
          type: "apiKey",
          name: "Authorization",
          description: "Um token JWT válido deve ser fornecido"
        }
      },
      consumes: ["application/json"],
      produces: ["application/json"]
    }
  end
end
