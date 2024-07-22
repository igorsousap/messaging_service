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
  @spec create_webhook(map()) :: {:ok, :created} | {:error, Ecto.Changeset.t()}
  def create_webhook(params) do
    case Webhooks.create(params) do
      {:ok, webhook} ->
        Logger.info(
          "webhook with id: #{webhook.id} and event: #{webhook} was created for user: #{webhook.user_id}"
        )

        {:ok, :created}

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
    case Webhooks.get_webhook_by_user_id(user_id, page, page_size) do
      [] ->
        Logger.info("Webhooks from user: #{user_id} not found")
        {:error, :not_found}

      webhook ->
        Logger.info(
          "webhook with id: #{webhook.id} and event: #{webhook} was created for user: #{webhook.user_id}"
        )

        {:ok, :created}
    end
  end
end
