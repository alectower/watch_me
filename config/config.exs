# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :watch_me,
  ecto_repos: [WatchMe.Repo]

# Configures the endpoint
config :watch_me, WatchMe.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+Pg01k/8r18aWRkE9jr3WO6SFf3ACAJq0gDCjbyqkeP8DXCrvMizI73xy3FlRUJX",
  render_errors: [view: WatchMe.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WatchMe.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :watch_me, :listener, port: 4001

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
