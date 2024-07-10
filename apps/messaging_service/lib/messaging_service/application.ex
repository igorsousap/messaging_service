defmodule MessagingService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MessagingService.Repo,
      {DNSCluster, query: Application.get_env(:messaging_service, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MessagingService.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MessagingService.Finch}
      # Start a worker by calling: MessagingService.Worker.start_link(arg)
      # {MessagingService.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MessagingService.Supervisor)
  end
end
