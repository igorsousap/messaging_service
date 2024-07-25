defmodule MessagingService.Consumer.Broadway.BroadwayMessage do
  use Broadway

  alias Broadway.Message
  alias MessagingService.Service.WebhookService
  alias MessagingService.Consumer.Broadway.ProcessMessage

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
             hosts: [localhost: 9092],
             group_id: "group_1",
             topics: ["messaging_topic", "messege_topic"],
             offset_reset_policy: :earliest,
             reconnect_timeout: 10_000,
             fetch_max_bytes: 1_048_576,
             fetch_min_bytes: 1,
             fetch_wait_max_ms: 100
           ]},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 10
        ]
      ],
      batchers: [
        default: [
          batch_size: 10,
          batch_timeout: 200,
          concurrency: 10
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, %Message{} = message, _) do
    with message <- Message.update_data(message, fn data -> Jason.decode!(data) end),
         {:ok, endpoint} <-
           WebhookService.get_webhook_from_user_id_event_type(
             message.data["user_id"],
             message.data["event_type"]
           ),
         {:ok, message_update} <-
           update_message_endpoint(message, endpoint) do
      message_update
    end
  end

  @impl true
  def handle_batch(:default, messages, _batch_info, _context) do
    ProcessMessage.message(messages)
    messages
  end

  defp update_message_endpoint(message, endpoint) do
    endpoint = Map.fetch!(endpoint, :endpoint)

    message_update =
      message
      |> Message.update_data(fn data -> Map.put(data, "endpoint", endpoint) end)

    {:ok, message_update}
  end
end
