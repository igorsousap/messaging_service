defmodule MessagingService.Factory do
  use ExMachina.Ecto, repo: MessagingService.Repo

  alias Persistence.Webhooks.Webhook

  def webhook_factory do
    %Webhook{
      endpoint: "http://localhost:4000/echo",
      event_type: "event.type.test"
    }
  end
end
