defmodule MessagingServiceWeb.WebhookController do
  use MessagingServiceWeb, :controller

  require Logger

  alias MessagingService.Service.WebhookService
  alias MessagingService.Service.UserService
  alias MessagingService.Persistence.Accounts.User

  action_fallback(MessagingServiceWeb.FallbackController)

  plug :put_view, json: MessagingServiceWeb.WebhookJson

  def create(conn, params) do
    with %User{id: id} <- user_id_identification(conn),
         {:ok, :authorized} <- authorization(conn),
         {:ok, webhook} <-
           WebhookService.create_webhook(%{
             event_type: params["event_type"],
             endpoint: params["endpoint"],
             user_id: id
           }) do
      conn
      |> put_status(:created)
      |> render(:webhook, loyalt: false, webhook: webhook, status: :created)
    end
  end

  def get_webhooks(conn, params) do
    with %User{id: id} <- user_id_identification(conn),
         {:ok, :authorized} <- authorization(conn),
         {:ok, webhook} <-
           WebhookService.get_webhook_from_user(id, params["page"], params["page_size"]) do
      conn
      |> put_status(:ok)
      |> render(:webhook_list, loyalt: false, webhook: webhook)
    end
  end

  def update_webhooks(conn, params) do
    with %User{id: id} <- user_id_identification(conn),
         {:ok, :authorized} <- authorization(conn),
         {:ok, webhook} <-
           WebhookService.update_webhook_endpoint(
             id,
             params["event_type"],
             params["endpoint"]
           ) do
      conn
      |> put_status(:ok)
      |> render(:webhook, loyalt: false, webhook: webhook, status: :updated)
    end
  end

  defp authorization(conn) do
    token = conn.private[:guardian_default_token]
    UserService.validate_token(token)
  end

  defp user_id_identification(conn) do
    conn.private[:guardian_default_resource]
  end
end
