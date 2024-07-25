defmodule MessagingService.Repo.Migrations.CreateWebhooksTable do
  use Ecto.Migration

  def change do
    create table(:webhooks, primary_key: false) do
      add :id, :uuid, primarykey: true
      add :endpoint, :string, null: false
      add :event_type, :string, null: false

      add :user_id, references(:users, on_delete: :delete_all, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:webhooks, [:endpoint], name: :webhooks_endpoint_index)

    create unique_index(:webhooks, [:user_id, :event_type],
             name: :webhooks_user_id_event_type_index
           )
  end
end
