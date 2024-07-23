defmodule MessagingService.Service.UserService do
  require Logger
  alias MessagingService.Persistence.Accounts

  @doc """
  Receive a user to be inserted on database
  ## Examples

      iex> MessagingService.Service.UserService.create_user(%{
         email: "email.test@gmail.com",
          password: "Password@test123"
        })

  """
  def create_user(attrs) do
    case Accounts.register_user(attrs) do
      {:ok, user} ->
        Logger.info("User created with email #{user.email}")
        {:ok, user}

      error ->
        error
    end
  end

  def get_user_by_id(user_id) do
    case Accounts.get_user!(user_id) do
      nil ->
        {:error, :not_found}

      user ->
        user
    end
  end

  def get_user_email_password(email, password) do
    IO.inspect(email, label: :email)

    IO.inspect(password, label: :password)

    case Accounts.get_user_by_email_and_password(email, password) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def generate_token_user(user, token), do: Accounts.insert_user_session_token(user, token)

  def delete_previews_token(user_id), do: Accounts.delete_user_session_token(user_id)

  def authenticate_user(email, password) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil -> {:error, :invalid_credentials}
      user -> {:ok, user}
    end
  end

  def validate_token(token) do
    case Accounts.validate_token_user(token) do
      {:ok, _user_token} -> {:ok, :authorized}
      nil -> {:error, :unathourazed}
    end
  end
end
