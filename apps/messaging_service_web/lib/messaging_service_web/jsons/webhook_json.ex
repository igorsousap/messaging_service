defmodule MessagingServiceWeb.WebhookJson do
  def webhook(%{webhook: webhook, status: status}) do
    %{webhook_event: webhook.event_type, webhook_endpoint: webhook.endpoint, status: status}
  end

  def webhook_list(%{webhook: webhooks}) do
    Enum.map(webhooks, fn webhook ->
      %{
        id: webhook.id,
        webhook_event: webhook.event_type,
        webhook_endpoint: webhook.endpoint
      }
    end)
  end
end
