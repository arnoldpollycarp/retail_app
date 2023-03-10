defmodule Thamani.Mixfile do
  use Mix.Project

  def project do
    [
      app: :thamani,
      version: "0.0.2",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
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
      mod: {Thamani.Application, []},
      applications: [
        :sentix,
        :phoenix,
        :phoenix_pubsub,
        :phoenix_html,
        :postgrex,
        :cowboy,
        :guardian,
        :logger,
        :gettext,
        :phoenix_ecto,
        :mariaex,
        :comeonin,
        :arc_ecto,
        :rummage_ecto,
        :rummage_phoenix,
        :arc,
        :drab,
        :pdf_generator,
        :bamboo,
        :mailgun,
        :edeliver,
        :distillery,
        :tzdata
      ],
      extra_applications: [:logger, :runtime_tools]
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
      {:phoenix, "~> 1.3.0", override: true},
      {:phoenix_pubsub, "~> 1.0"},
      {:poison, "~> 3.1", override: true},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:mariaex, "~> 0.8.2"},
      {:phoenix_html, "~> 2.13.4"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:plug_cowboy, "~> 1.0"},
      {:comeonin, "~> 2.2 "},
      {:guardian, "~> 0.14.5"},
      {:arc, "~> 0.8"},
      {:arc_ecto, "~> 0.7"},
      {:rummage_ecto, "~> 1.0.0", override: true},
      {:rummage_phoenix, "~> 1.2.0", override: true},
      {:json, "~> 1.2"},
      {:edeliver, "~> 1.4.3"},
      {:distillery, "~> 1.5.2", override: true},
      {:drab, "~> 0.8.3"},
      {:bamboo, "~> 1.1"},
      {:mailgun, "~> 0.1.2"},
      {:ja_serializer, "~> 0.12.0"},
      {:pdf_generator, "~>0.3.7"},
      {:sentix, "~> 1.0"},
      {:secure_random, "~> 0.5"},
      {:mpesa_elixir, "~> 0.1.0"},
      {:ex_gtin, "~> 0.3.3"},
      {:xml_builder, "~> 2.1"},
      {:sweet_xml, "~> 0.6.6"},
      {:quantum, "~> 2.3"},
      {:qrcode, "~> 1.0.4", git: "https://github.com/netflakes/qrcode.git"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
