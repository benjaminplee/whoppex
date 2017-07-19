defmodule Sample.Mixfile do
  use Mix.Project

  def project do
    [app: :sample,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      applications: [:httpoison, :hulaaki, :whoppex],
      extra_applications: [:logger],
      mod: {Sample.Application, []}
    ]
  end

  defp deps do
    [
      {:whoppex, "~> 0.1.0"},
      {:httpoison, "~> 0.11.1"},
      {:hulaaki, "~> 0.0.4"}
    ]
  end
end
