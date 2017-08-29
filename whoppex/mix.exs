defmodule Whoppex.Mixfile do
  use Mix.Project

  @name :whoppex

  def project do
    [app: @name,
     description: "Erlixir based load generation tool",
     source_url: "https://github.com/benjaminplee/whoppex",
     package: package(),
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {Whoppex.Application, []}]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [
      name: @name,
      maintainers: ["Benjamin P Lee"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/benjaminplee/whoppex"}
    ]
  end
end
