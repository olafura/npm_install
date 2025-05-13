defmodule NpmInstall.Mixfile do
  use Mix.Project

  def project do
    [
      app: :npm_install,
      version: "0.1.0",
      elixir: "~> 1.7",
      description: "Run npm install",
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.10", only: :dev},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Olafur Arason"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/olafura/npm_install"}
    ]
  end
end
