defmodule MessagingServiceWeb.UserController do
  use MessagingServiceWeb, :controller

  require Logger

  alias MessagingServiceWeb.Guardian
  alias MessagingService.Service.UserService

  action_fallback(MessagingServiceWeb.FallbackController)

  plug :put_view, json: MessagingServiceWeb.UserJson

  def create(conn, params) do
    with {:ok, user} <-
           UserService.create_user(%{email: params["email"], password: params["password"]}),
         {:ok, token, _full_claims} <- Guardian.encode_and_sign(%{id: user.id}) do
      UserService.generate_token_user(user, token)

      conn
      |> put_status(:created)
      |> render(:user, loyalt: false, user: user, token: token, status: :created)
    else
      error ->
        Logger.error(
          "Could not create user with attributes #{inspect(params)}. Error: #{inspect(error)}"
        )

        error
    end
  end

  def log_in(conn, params) do
    with {:ok, user} <- UserService.get_user_email_password(params["email"], params["password"]),
         :ok <- UserService.delete_previews_token(user.id),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user),
         :ok <- UserService.generate_token_user(user, token) do
      conn
      |> put_status(:ok)
      |> render(:user, loyalt: false, user: user, token: token, status: :log_in)
    else
      error ->
        Logger.error(
          "Could not find user with attributes #{inspect(params)}. Error: #{inspect(error)}"
        )

        error
    end
  end
end
