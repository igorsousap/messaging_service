defmodule MessagingService.Producer.ProducerMessages do
  require Logger

  @doc """
  Send a message with the data to kafka

  ## Examples

      iex> producer_message_kafka("event_type", "user_id", "message_topic", qtd_messages: integer)
      MessagingService.Producer.ProducerMessages.producer_message_kafka("test_event_echo", "f1dd7282-5235-4997-b0cd-c7a26efe4b16", "messaging_topic", 1000)
  """
  @spec producer_message_kafka(String.t(), Binary_id.t(), String.t(), Integer.t()) ::
          {:ok, :messages_send}
  def producer_message_kafka(event_type, user_id, topic, qtd_messages) do
    Enum.map(1..qtd_messages, fn x ->
      message = build_kafka_message(event_type, user_id)

      case Kaffe.Producer.produce_sync(topic, [message]) do
        :ok ->
          Logger.info(
            "Message #{x} send to topic #{topic}, and event #{event_type} to user #{user_id}"
          )

        error ->
          Logger.error("Could not send message #{x} to topic #{topic}. Error: #{inspect(error)}")
      end

      :timer.sleep(1000)
    end)

    {:ok, :messages_send}
  end

  defp build_kafka_message(event_type, user_id) do
    %{
      key: "producer_message",
      headers: [
        {"timestamp", DateTime.utc_now() |> DateTime.to_string()}
      ],
      value:
        %{
          "message_id" => Ecto.UUID.autogenerate(),
          "event_type" => event_type,
          "user_id" => user_id
        }
        |> Jason.encode!()
    }
  end
end
