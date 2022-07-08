defmodule Tello.MixProject do
  use Mix.Project

  def project do
    [
      app: :tello,
      version: "0.1.0",
      elixir: "~> 1.13",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Tello",
      source_url: "https://github.com/linjunpop/tello"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Tello.Application, []}
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Tello SDK in Elixir"
  end

  defp package do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/linjunpop/tello"}
    ]
  end
end
