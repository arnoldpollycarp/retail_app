use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :thamani, ThamaniWeb.Endpoint,
  secret_key_base: "+WFv3dqP7oC+Od1GxnQFKwkdyf0i6ipSiTfKtARYSQShO0BwcuvPDLOizPRIiUH/"

# Configure your database
config :thamani, Thamani.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "thamani",
  username: "root",
  password: "G4ntOHr4KBKXvqa",
  hostname: "localhost",
  pool_size: 10
