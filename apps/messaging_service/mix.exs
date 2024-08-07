defmodule MessagingService.MixProject do
  use Mix.Project

  def project do
    [
      app: :messaging_service,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MessagingService.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :prometheus_ex,
        :prometheus_ecto,
        :prometheus_plugs
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.0"},
      {:dns_cluster, "~> 0.1.1"},
      {:phoenix_pubsub, "~> 2.1"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:swoosh, "~> 1.5"},
      {:finch, "~> 0.13"},
      {:broadway, "~> 1.0"},
      {:kaffe, "~> 1.0"},
      {:broadway_kafka, "~> 0.4.1"},
      {:oban, "~> 2.17"},
      {:tesla, "~> 1.11"},
      {:ex_machina, "~> 2.7.0", only: :test},
      # Observabilidade
      {:prometheus_ex, "~> 3.1"},
      {:prometheus_ecto, "~> 1.4.3"},
      {:prometheus_plugs, "~> 1.1.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
