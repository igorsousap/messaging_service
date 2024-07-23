defmodule MessagingService.Persistence.Webhooks do
  import Ecto.Query
  alias MessagingService.Repo
  alias Persistence.Webhooks.Webhook

  @moduledoc """
  CRUD for register webhook on database
  """

  @doc """
  Receive a webhook to be inserted on database
  ## Examples

      iex> MessagingService.Webhooks.create(%{
          event_type: "send.message.converter",
          endpoint: "https://webhook.site/68d090b2-e5ad-40d3-a990-b3dc45dcf17c"
          user_id: "user_id"
        })

  """

  @spec create(map()) :: {:ok, Webhook.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    params
    |> Webhook.changeset()
    |> IO.inspect(label: :changeset)
    |> Repo.insert()
  end

  @doc """
  Receive a webhook id and returns a webhook
  ## Examples

      iex> MessagingService.Webhooks.get_webhook_by_id("UUID")

  """
  @spec get_webhook_by_id(Ecto.UUID.t()) :: Webhook.t() | nil
  def get_webhook_by_id(webhook_id), do: Repo.get(Webhook, webhook_id)

  @doc """
  Receive a user_id and returns a webhook
  ## Examples

      iex> MessagingService.Webhooks.get_webhook_by_user_id("UUID")

  """
  @spec get_webhook_by_user_id(Ecto.UUID.t(), Integer.t(), Integer.t()) :: Webhook.t() | []
  def get_webhook_by_user_id(user_id, page, page_size) do
    Webhook
    |> from()
    |> order_by([w], desc: w.inserted_at)
    |> limit(^page_size)
    |> offset((^page - 1) * ^page_size)
    |> where([w], w.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Receive a user_id and returns a webhook
  ## Examples

      iex> MessagingService.Webhooks.get_webhook_by_user_id(%Persistence.Webhooks.Webhook{
          event_type: "send.message.converter",
          endpoint: "https://webhook.site/68d090b2-e5ad-40d3-a990-b3dc45dcf17c"
          user_id: "user_id"
        }, %{event_type: "new.send.message.converter"})

  """
  @spec update(Webhook.t(), map()) :: {:ok, Webhook.t()} | {:error, Ecto.Changeset.t()}
  def update(id, attrs) do
    Webhook
    |> Repo.get(id)
    |> Webhook.changeset(attrs)
    |> Repo.update()
  end
end
