defmodule Rocketpay.MixProject do
  use Mix.Project

  def project do
    [
      app: :rocketpay,
      version: "0.0.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      compilers: compilers(),
      dialyzer: dialyzer(),
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ]
    ]
  end

  def application do
    [
      mod: {Rocketpay.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.5.7"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:guardian, "~> 2.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:decimal, "~> 2.0"},
      {:plug_cowboy, "~> 2.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:prometheus_ex, "~> 3.0.5"},
      {:prometheus_ecto, "~> 1.4.3"},
      {:prometheus_plugs, "~> 1.1.5"},
      {:prometheus_phoenix, "~> 1.3.0"},
      {:prometheus_process_collector, "~> 1.6.0"},
      {:ex_json_schema, "~> 0.7"},
      {:phoenix_swagger, "~> 0.8"},
      {:excoveralls, "~> 0.10", only: :test},
      {:faker_elixir_octopus, "~> 1.0.0", only: :test},
      {:dialyxir, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end

  defp compilers() do
    [:phoenix, :gettext]
    ++ Mix.compilers()
    ++ [:phoenix_swagger]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp aliases do
    [
      seed: ["run priv/repo/seeds.exs"],
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
