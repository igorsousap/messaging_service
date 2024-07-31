defmodule MessagingService.Persistence.WebhooksTest do
  use MessagingService.DataCase, async: true

  import MessagingService.Factory
  import MessagingService.AccountsFixtures

  alias Persistence.Webhooks.Webhook
  alias MessagingService.Persistence.Webhooks

  setup do
    user = user_fixture()
    webhook = insert(:webhook, user_id: user.id)

    {:ok, user: user, webhook: webhook}
  end

  describe "create/1" do
    test "should create a webhook in database", %{user: user} do
      attrs = %{
        endpoint: "https://localhost:400/test_insert",
        event_type: "event.type.insert.test",
        user_id: user.id
      }

      assert {:ok, %Webhook{}} = Webhooks.create(attrs)
    end

    test "should error when passed fields empty", %{user: user} do
      attrs = %{event_type: nil, endpoint: nil, user_id: user.id}

      assert {:error, changeset} =
               Webhooks.create(attrs)

      assert %{endpoint: ["can't be blank"], event_type: ["can't be blank"]} ==
               errors_on(changeset)
    end
  end

  describe "get_webhook_by_id/1" do
    test "should return a webhook from a given id", %{webhook: webhook} do
      assert %Webhook{} = Webhooks.get_webhook_by_id(webhook.id)
    end

    test "should return nil when not find a webhook" do
      assert nil == Webhooks.get_webhook_by_id(Ecto.UUID.autogenerate())
    end
  end

  describe "get_webhook_by_user_id/3" do
    test "should return a webhook from a given user id", %{user: user} do
      endpoints = Webhooks.get_webhook_by_user_id(user.id, 1, 5)

      assert Enum.map(endpoints, fn endpoint ->
               Map.has_key?(endpoint, :endpoint)
               Map.has_key?(endpoint, :event_type)
             end)
    end

    test "should return nil when not find a webhook" do
      assert [] == Webhooks.get_webhook_by_user_id(Ecto.UUID.autogenerate(), 1, 5)
    end
  end

  describe "get_webhook_by_user_id_event_type/2" do
    test "should return a webhook from a given user id", %{user: user, webhook: webhook} do
      endpoint = Webhooks.get_webhook_by_user_id_event_type(user.id, webhook.event_type)

      assert Map.has_key?(endpoint, :endpoint)
    end

    test "should return nil when not find a webhook" do
      assert nil ==
               Webhooks.get_webhook_by_user_id_event_type(
                 Ecto.UUID.autogenerate(),
                 "invalid_event_type"
               )
    end
  end

  describe "update_endpoint/2" do
    test "should return a webhook from a given user id", %{user: user, webhook: webhook} do
      assert {:ok, %Webhook{}} =
               Webhooks.update_endpoint(user.id, webhook.event_type, %{
                 endpoint: "https://locahost:4000/test_update"
               })
    end

    test "should return error when not find a webhook", %{user: user, webhook: webhook} do
      assert {:error, changeset} =
               Webhooks.update_endpoint(user.id, webhook.event_type, %{
                 event_type: "event_type_test"
               })

      assert %{endpoint: ["must be a endpoint key to be updated"]} ==
               errors_on(changeset)
    end
  end
end
