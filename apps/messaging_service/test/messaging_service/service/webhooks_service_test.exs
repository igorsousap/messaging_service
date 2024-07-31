defmodule MessagingService.Service.WebhooksServiceTest do
  use MessagingService.DataCase, async: true

  import MessagingService.AccountsFixtures
  import MessagingService.Factory

  alias Persistence.Webhooks.Webhook

  alias MessagingService.Service.WebhookService

  @moduletag :capture_log

  setup do
    user = user_fixture()
    webhook_params = params_for(:webhook)
    webhook = insert(:webhook, user_id: user.id)

    {:ok, user: user, webhook_params: webhook_params, webhook: webhook}
  end

  describe "create_webhook/1" do
    test "Should create a webhook as given params", %{user: user} do
      webhook_params = %{
        event_type: "event.inser.test",
        endpoint: "https://locahost:4000/insert",
        user_id: user.id
      }

      assert {:ok, %Webhook{}} = WebhookService.create_webhook(webhook_params)
    end

    test "Should return error when passed empty fields", %{user: user} do
      webhook_params = %{
        event_type: nil,
        endpoint: nil,
        user_id: user.id
      }

      assert {:error, changeset} =
               WebhookService.create_webhook(webhook_params)

      assert %{endpoint: ["can't be blank"], event_type: ["can't be blank"]} ==
               errors_on(changeset)
    end
  end

  describe "get_webhook_from_user/3" do
    test "Should return all webhooks froma a user id", %{user: user} do
      {:ok, webhook_list} = WebhookService.get_webhook_from_user(user.id, "1", "5")

      assert Enum.map(webhook_list, fn webhook ->
               Map.has_key?(webhook, :endpooint)
               Map.has_key?(webhook, :event_type)
             end)
    end

    test "Should return error when not found webhook with user id" do
      assert {:error, :not_found} =
               WebhookService.get_webhook_from_user(Ecto.UUID.autogenerate(), "1", "5")
    end
  end

  describe "get_webhook_from_user_id_event_type/2" do
    test "Should return all webhooks froma a user id and event_type", %{
      user: user,
      webhook: webhook
    } do
      {:ok, endpoint} =
        WebhookService.get_webhook_from_user_id_event_type(user.id, webhook.event_type)

      assert Map.has_key?(endpoint, :endpoint)
    end

    test "Should return error when not found webhook with user id and event_type" do
      assert {:error, :not_found} =
               WebhookService.get_webhook_from_user_id_event_type(
                 Ecto.UUID.autogenerate(),
                 "invalid_event_type"
               )
    end
  end

  describe "update_webhook_endpoint/2" do
    test "Should update a webhook as given user_id and params", %{user: user, webhook: webhook} do
      endpoint = "https://localhost:4000/new_endpoint"

      assert {:ok, %Webhook{}} =
               WebhookService.update_webhook_endpoint(user.id, webhook.event_type, endpoint)
    end

    test "Should return error when passed empty fields in params", %{user: user, webhook: webhook} do
      endpoint = nil

      assert {:error, changeset} =
               WebhookService.update_webhook_endpoint(user.id, webhook.event_type, endpoint)

      assert %{endpoint: ["must be a endpoint key to be updated", "can't be blank"]} ==
               errors_on(changeset)
    end
  end
end
