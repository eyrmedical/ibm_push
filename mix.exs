defmodule IBMPush.Mixfile do
  use Mix.Project

  def project do
    [app: :ibm_push,
     version: "0.1.0",
     elixir: "~> 1.4",
     description: "Wrapper to use IBM Bluemix Push notification REST API.",
     docs: [extras: ["README.md"]],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps()]
  end

  def package do
    [ 
      name: :ibm_push,
      files: ["lib", "mix.exs"],
      maintainers: ["Vyacheslav Voronchuk"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/eyrmedical/ibm_push"},
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [
      :logger,
      :httpoison
    ]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:hackney, "1.6.1"},
      {:httpoison, "~> 0.9.2"},
      {:poison, "~> 3.0"},
      {:uuid, "~> 1.1"},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end
end
