defmodule WithoutCeasing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      WithoutCeasing.Repo,
      # Start the Telemetry supervisor
      WithoutCeasingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: WithoutCeasing.PubSub},
      # Start the Endpoint (http/https)
      WithoutCeasingWeb.Endpoint,
      # Finch
      Supervisor.child_spec(WithoutCeasing.ConvertKitClient.child_spec(), id: :convert_kit),
      Supervisor.child_spec(WithoutCeasing.EsvClient.child_spec(), id: :esv)
      # Start a worker by calling: WithoutCeasing.Worker.start_link(arg)
      # {WithoutCeasing.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WithoutCeasing.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WithoutCeasingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
