defmodule Persistence.Webhooks.Webhook do
  @moduledoc """
  Ecto changeset for validation the struct to be sabed and query for get and update
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          endpoint: String.t(),
          event_type: String.t(),
          user_id: Ecto.UUID.t()
        }

  @fields ~w(endpoint event_type user_id)a

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "webhooks" do
    field :endpoint, :string
    field :event_type, :string

    belongs_to :user, MessagingService.Persistence.Accounts.User, type: :binary_id

    timestamps()
  end

  @doc """
  Create chagenset
  ## Examples
      iex> Persistence.Persistence.Webhooks.Webhook.cahngeset(
        %{
          event_type: "send.message.converter",
          endpoint: "https://webhook.site/68d090b2-e5ad-40d3-a990-b3dc45dcf17c/updated"
          user_id: "user_id"
        })

  """

  @spec changeset(:__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(endpoint \\ %__MODULE__{}, params) do
    endpoint
    |> cast(params, @fields)
    |> unique_constraint([:endpoint], name: :webhooks_endpoint_index)
    |> unique_constraint([:event_type, :user_id], name: :webhooks_user_id_event_type_index)
    |> validate_required(@fields)
  end
end
