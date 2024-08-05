# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :messaging_service_web, MessagingServiceWeb.PromEx,
  disabled: false,
  manual_metrics_start_delay: :no_delay,
  drop_metrics_groups: [],
  grafana: [
    host: "http://localhost:3000",
    # Authenticate via Basic Auth
    username: "admin",
    password: "admin",
    upload_dashboards_on_start: true
  ],
  metrics_server: :disabled

# Configure Mix tasks and generators
config :messaging_service,
  ecto_repos: [MessagingService.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :messaging_service, MessagingService.Mailer, adapter: Swoosh.Adapters.Local

config :messaging_service_web,
  ecto_repos: [MessagingService.Repo],
  generators: [context_app: :messaging_service]

# Configures the endpoint
config :messaging_service_web, MessagingServiceWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: MessagingServiceWeb.ErrorHTML, json: MessagingServiceWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: MessagingService.PubSub,
  live_view: [signing_salt: "PNzLW3Xn"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  messaging_service_web: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/messaging_service_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  messaging_service_web: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/messaging_service_web/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :messaging_service_web, MessagingServiceWeb.Guardian,
  issuer: "messaging_service_web",
  secret_key: "mix guardian.gen.secret"

config :kaffe,
  producer: [
    endpoints: [localhost: 9092],
    topics: ["messaging_topic"]
  ]

config :messaging_service, Oban,
  engine: Oban.Engines.Basic,
  queues: [default: 10],
  repo: MessagingService.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
