defmodule Rocketpay.Routes.List do
  def call do
    RocketpayWeb.Router.__routes__
    |> Stream.reject(fn %{path: path} -> String.contains?(path, "dashboard") end)
    |> Enum.map(fn %{path: path, verb: verb} -> "#{verb} #{path}" end)
  end
end
