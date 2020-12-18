defmodule PgCase.MixProject do
  use Mix.Project

  def project do
    [
      app: :pg_case,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),

      # Docs
      name: "PgCase",
      docs: docs(),

      # Hex
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "test"]
    ]
  end

  defp docs do
    [
      main: "PgCase",
      extras: ["README.md"],
      source_url: "https://github.com/Elonsoft/pg_case"
    ]
  end

  defp description do
    """
    Elixir helper macros to work with PostgreSQL `case` expression
    """
  end

  defp package do
    [
      links: %{"GitHub" => "https://github.com/Elonsoft/pg_case"},
      licenses: ["MIT"],
      files: ~w(.formatter.exs mix.exs README.md LICENSE.md lib)
    ]
  end
end
