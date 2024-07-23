defmodule MessagingService.Service.WebhookService do
  require Logger
  alias MessagingService.Persistence.Webhooks

  @doc """
  Receive a webhook to be inserted on database
  ## Examples

      iex> MessagingService.Service.WebhookService.create_webhook(%{
          event_type: "send.message.converter",
          endpoint: "https://webhook.site/68d090b2-e5ad-40d3-a990-b3dc45dcf17c"
          user_id: "user_id"
        })

  """
  @spec create_webhook(map()) :: {:ok, Webhook.t()} | {:error, Ecto.Changeset.t()}
  def create_webhook(params) do
    case Webhooks.create(params) do
      {:ok, webhook} ->
        Logger.info(
          "webhook with id: #{webhook.id} and event: #{webhook.event_type} was created for user: #{webhook.user_id}"
        )

        {:ok, webhook}

      error ->
        error
    end
  end

  @doc """
  Receive a webhook to be inserted on database
  ## Examples

      iex> MessagingService.Service.WebhookService.get_webhook_from_user("user_id", "page", "page_size")
        })

  """
  def get_webhook_from_user(user_id, page, page_size) do
    page = String.to_integer(page)
    page_size = String.to_integer(page_size)

    case Webhooks.get_webhook_by_user_id(user_id, page, page_size) do
      [] ->
        Logger.info("Webhooks from user: #{user_id} not found")
        {:error, :not_found}

      webhook ->
        {:ok, webhook}
    end
  end

  def update_webhook(id, endpoint) do
    case Webhooks.update(id, %{endpoint: endpoint}) do
      {:ok, webhook} ->
        {:ok, webhook}

      error ->
        error
    end
  end
end
