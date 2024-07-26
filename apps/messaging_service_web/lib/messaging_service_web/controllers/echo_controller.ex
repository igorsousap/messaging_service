defmodule MessagingServiceWeb.EchoController do
  use MessagingServiceWeb, :controller

  def handle(conn, params) do
    conn
    |> put_status(:ok)
    |> json(%{message: params})
  end
end
