# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :thamani,
  ecto_repos: [Thamani.Repo],
  api_test_url: "https://apitest.sendyit.com/v1/##request",
  api_url: "https://api.sendyit.com/v1/##request",
  api_test_key: "c8bCNtEgtalP83p8U8pw",
  api_key: "FKiBHJIdIgG4GMm3FlTH",
  api_username: "thamani",
  aft_key: "0902d36a02514da9fa33a11586683f8d76e5207ea544363e7d41149e6c9a6718",
  aft_url: "https://api.africastalking.com/version1/messaging",
  aft_username: "gs1kenya"

config :rummage_ecto, Rummage.Ecto,
  default_repo: Thamani.Repo,
  default_per_page: 10

config :rummage_phoenix,
       Rummage.Phoenix,
       default_per_page: 10,
       default_max_page_links: 10

# Configures the endpoint
config :thamani, ThamaniWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "G4ntOHr4KBKXvqaJhtLmpeiGSiBIcW5JTAxIQkxR7TNa/24ms5z95C9xMuC/LaDZ",
  render_errors: [view: ThamaniWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Thamani.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# configures guardian
config :guardian, Guardian,
  issuer: "ThamaniWeb.#{Mix.env()}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: ThamaniWeb.GuardianSerializer,
  secret_key: to_string(Mix.env()) <> "SuPerseCret_aBraCadabrA"

# configures drab
config :phoenix, :template_engines,
  drab: Drab.Live.Engine,
  browser_response_timeout: :infinity

config :pdf_generator,
  # <-- this program actually doe$
  wkhtml_path: "/usr/bin/wkhtmltopdf",
  # <-- only needed for PDF encryp$
  pdftk_path: "/usr/bin/pdftk",
  command_prefix: "/usr/bin/xvfb-run"



# configuring porcelain
config :porcelain, :driver, Porcelain.Driver.Basic
# configures json serialiser
# config :phoenix, :format_encoders,
#  "json-api": Poison

# config :mime, :types, %{
#  "application/vnd.api+json" => ["json-api"]
# }

config :thamani, Thamani.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-a69d2d606116e30fd87ac93435a5aa81",
  domain: "https://api.mailgun.net/v3/sandbox587be400b0b34e7eb66e4ffc393ca9fa.mailgun.org"

config :thamani,
  mailgun_domain: "https://api.mailgun.net/v3/thamanionline.com",
  mailgun_key: "key-a69d2d606116e30fd87ac93435a5aa81"

# mpesa configurations

config :mpesa_elixir,
  api_url: "https://api.safaricom.co.ke/",
  consumer_key: "TVuwJ51FOhvAIsmln26ZgUJEevlRInyd",
  consumer_secret: "MPlCfwgVJWBH2nVm",
  pass_key: "",
  confirmation_url: "http://41.90.105.110:8000/callbacks/confirmation",
  validation_url: "http://41.90.105.110:8000/callbacks/validate",
  short_code: "601418",
  stk_short_code: "174379",
  security_cred: "LdLXF@8A",
  b2c_initiator_name: "apitest418",
  b2c_short_code: "",
  response_type: "Completed",
  certificate_path: "./lib/thamani_web/keys/live_cert.cer",
  initiator_name: "apitest418",
  b2c_queue_time_out_url: "http://41.90.105.110:8000/callbacks/balance",
  b2c_result_url: "http://41.90.105.110:8000/callbacks/balance",
  b2b_queue_time_out_url: "",
  b2b_result_url: "",
  balance_queue_time_out_url: "https://thamanionline.com/callbacks/balance",
  balance_result_url: "http://41.90.105.110:8000/callbacks/balance",
  status_queue_time_out_url: "http://41.90.105.110:8000/callbacks/status",
  status_result_url: "http://41.90.105.110:8000/callbacks/status",
  reversal_queue_time_out_url: "https://ff90ab8e1fa8.ngrok.io/callbacks/balance",
  reversal_result_url: "https://ff90ab8e1fa8.ngrok.io/callbacks/balance",
  stk_call_back_url: "https://thamanionline.com/callbacks/validate",
  keylock: "WFv3dqP7oC+Od1GxnQFKwkdyf0i6ipSiTfKtARYSQShO0BwcuvPDLOizPRIiUH"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
