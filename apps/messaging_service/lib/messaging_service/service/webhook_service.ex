defmodule MessagingService.Service.WebhookService do
  require Logger
  alias Persistence.Webhooks.Webhook
  alias MessagingService.Persistence.Webhooks

  @doc """
  Receive a webhook to be inserted on database
  ## Examples

      iex> create_webhook(%{event_type: "send.message.converter",endpoint: "https://webhook.site/68d090b2-e5ad-40d3-a990-b3dc45dcf17c", user_id: "user_id"})
      {:ok, %Webhook{}}

      iex> create_webhook(%{event_type: "invalid,event",endpoint: "www.invalid.com/endpoint", user_id: "user_id"})
      {:error, Ecto.Changeset.t()}
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
        Logger.error(
          "Service: Could not create webhook with attributes #{inspect(params)}. Error: #{inspect(error)}"
        )

        error
    end
  end

  @doc """
  Return webhooks paginated from a given user_id
  ## Examples

      iex> get_webhook_from_user("user_id", "page", "page_size")})
       {:ok, map()}


      iex> get_webhook_from_user("invalid_user_id", "page", "page_size")})
       {:error, :not_found}
  """
  @spec get_webhook_from_user(Binary_id.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, :not_found}
  def get_webhook_from_user(user_id, page, page_size) do
    page = String.to_integer(page)
    page_size = String.to_integer(page_size)

    case Webhooks.get_webhook_by_user_id(user_id, page, page_size) do
      [] ->
        Logger.error("Webhooks from user: #{user_id} not found")
        {:error, :not_found}

      webhook ->
        Logger.info("Requested a list of all webhooks from user: #{user_id}")
        {:ok, webhook}
    end
  end

  @doc """
  Return a webhook from a given user_id and event_type
  ## Examples

      iex> get_webhook_from_user("user_id", "event_type")})
       {:ok, %Webhook{}}


      iex> get_webhook_from_user("invalid_user_id", "invalid_event_type")})
       {:error, :not_found}
  """
  @spec get_webhook_from_user_id_event_type(Binary_id.t(), String.t()) ::
          {:ok, map()} | {:error, :not_found}
  def get_webhook_from_user_id_event_type(user_id, event_type) do
    case Webhooks.get_webhook_by_user_id_event_type(user_id, event_type) do
      nil ->
        Logger.error("Endpoint from user: #{user_id} not found")
        {:error, :not_found}

      endpoint ->
        Logger.info("Requested endpoint from user: #{user_id}")
        {:ok, endpoint}
    end
  end

  @doc """
  Update a webhooks endpoint from a given user id and endpoint
  ## Examples

      iex> update_webhook_endpoint("user_id", "endpoint"))
       {:ok, %Webhook{}}


      iex> update_webhook_endpoint("invalid_user_id",  endpoint))
       {:error, Ecto.Changeset.t(
  """
  @spec update_webhook_endpoint(Binary_id.t(), String.t(), String.t()) ::
          {:ok, Webhook.t()} | {:error, Ecto.Changeset.t()}
  def update_webhook_endpoint(user_id, event_type, endpoint) do
    case Webhooks.update_endpoint(user_id, event_type, %{endpoint: endpoint}) do
      {:ok, webhook} ->
        Logger.info("Updated webhook #{webhook.id} to a new endpoint #{endpoint}")
        {:ok, webhook}

      error ->
        Logger.error(
          "Service: Could not create webhook with attributes #{endpoint}. Error: #{inspect(error)}"
        )

        error
    end
  end
end
