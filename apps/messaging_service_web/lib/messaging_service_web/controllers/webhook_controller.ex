defmodule MessagingServiceWeb.WebhookController do
  use MessagingServiceWeb, :controller

  require Logger

  alias MessagingService.Service.WebhookService
  alias MessagingService.Service.UserService
  alias MessagingService.Persistence.Accounts.User

  action_fallback(MessagingServiceWeb.FallbackController)

  plug :put_view, json: MessagingServiceWeb.WebhookJson

  def create(conn, params) do
    %User{id: id} = conn.private[:guardian_default_resource]
    token = conn.private[:guardian_default_token]

    with {:ok, :authorized} <- UserService.validate_token(token),
         {:ok, webhook} <-
           WebhookService.create_webhook(%{
             event_type: params["event_type"],
             endpoint: params["endpoint"],
             user_id: id
           }) do
      conn
      |> put_status(:created)
      |> render(:webhook, loyalt: false, webhook: webhook, status: :created)
    else
      error ->
        Logger.error(
          "Could not create webhook with attributes #{inspect(params)}. Error: #{inspect(error)}"
        )

        error
    end
  end

  def get_webhooks(conn, params) do
    %User{id: id} = conn.private[:guardian_default_resource]
    token = conn.private[:guardian_default_token]

    with {:ok, :authorized} <- UserService.validate_token(token),
         {:ok, webhook} <-
           WebhookService.get_webhook_from_user(id, params["page"], params["page_size"]) do
      conn
      |> put_status(:ok)
      |> render(:webhook_list, loyalt: false, webhook: webhook)
    else
      error ->
        Logger.error(
          "Could not get webhook with attributes #{inspect(params)}. Error: #{inspect(error)}"
        )

        error
    end
  end

  def update_webhooks(conn, params) do
    token = conn.private[:guardian_default_token]

    with {:ok, :authorized} <- UserService.validate_token(token),
         {:ok, webhook} <-
           WebhookService.update_webhook_endpoint(params["id"], params["endpoint"]) do
      conn
      |> put_status(:ok)
      |> render(:webhook, loyalt: false, webhook: webhook, status: :updated)
    else
      error ->
        Logger.error(
          "Could not update webhook with attributes #{inspect(params)}. Error: #{inspect(error)}"
        )

        error
    end
  end
end
