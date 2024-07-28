defmodule MessagingServiceWeb.EchoController do
  use MessagingServiceWeb, :controller

  def echo(conn, params) do
    conn
    |> put_status(:ok)
    |> json(%{message: params})
  end

  def echo_error(conn, params) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{message: params})
  end
end
