defmodule MessagingService.Consumer.Worker.EndpointMessage do
  use Tesla

  plug(Tesla.Middleware.JSON)

  @spec send_webhook(map(), String.t()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def send_webhook(data, endpoint) do
    post(endpoint <> "/", data)
  end
end
