defmodule WatchMe do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(WatchMe.Repo, []),
      # Start the endpoint when the application starts
      supervisor(WatchMe.Endpoint, []),
      worker(WatchMe.Logger, []),
      worker(WatchMe.LogEater, [])
    ]

    System.at_exit fn (status) ->
      Process.send_after(:watch_me_logger, :stop_logger)
    end

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WatchMe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WatchMe.Endpoint.config_change(changed, removed)
    :ok
  end
end