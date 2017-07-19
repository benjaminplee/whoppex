defmodule WhoppexRunner.Mixfile do
  use Mix.Project

  def project do
    [app: :whoppex_runner,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      applications: [:whoppex],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:whoppex, "~> 0.1.0"},
      {:distillery, "~> 1.4", runtime: false}
    ]
  end
end
