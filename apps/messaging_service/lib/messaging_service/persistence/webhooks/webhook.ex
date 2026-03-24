defmodule Persistence.Webhooks.Webhook do
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

  @moduledoc """
   A webhook changeset for registration.
   Takes a unique url and event to a user
  """

  @doc """
  Create changeset
  ## Examples
      iex> Persistence.Persistence.Webhooks.Webhook.changeset(
        %{
          event_type: "send.message.converter",
          endpoint: "localhost:4000/new"
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

  @doc """
  A webhook changeset for changing the endpoint.

  It requires the endpoint to change otherwise an error is added.
  ## Examples
      iex> Persistence.Persistence.Webhooks.Webhook.changeset(
        %{
          event_type: "send.message.converter",
          endpoint: "localhost:4000/updated"
          user_id: "user_id"
        })

  """

  @spec changeset_endpoint(:__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset_endpoint(endpoint \\ %__MODULE__{}, params) do
    endpoint
    |> cast(params, [:endpoint])
    |> validate_required([:endpoint])
    |> unique_constraint(:endpoint, name: :webhooks_endpoint_index)
    |> case do
      %{changes: %{endpoint: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :endpoint, "must be a endpoint key to be updated")
    end
  end
end
