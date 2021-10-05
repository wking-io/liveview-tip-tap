# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :without_ceasing,
  ecto_repos: [WithoutCeasing.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :without_ceasing, WithoutCeasingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pQXseWqzJ+m+czEYTXPJiOx1D7Jzub/MbKm7Lx29JgwOahl+VK+ZpLKhO5oEc5MA",
  render_errors: [view: WithoutCeasingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: WithoutCeasing.PubSub,
  live_view: [signing_salt: "32Gv39WR"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :without_ceasing, WithoutCeasing.Mailer,
  adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
