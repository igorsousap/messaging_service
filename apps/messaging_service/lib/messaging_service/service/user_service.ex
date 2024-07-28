defmodule MessagingService.Service.UserService do
  require Logger
  alias MessagingService.Persistence.Accounts

  @doc """
  Receive a user to be inserted on database
  ## Examples

      iex> create_user(%{email: "email.test@test.com",password: "Password@test123"})
      {:ok, %User{}}

       iex> create_user(%{email: "invalid_email@test.com",password: "password@testinvalid"})
      {:error, Ecto.Changeset.t()}

  """
  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(params) do
    case Accounts.register_user(params) do
      {:ok, user} ->
        Logger.info("User created with email #{user.email}")
        {:ok, user}

      error ->
        Logger.error(
          "Could not create user with attributes #{inspect(params)}. Error: #{inspect(error)}"
        )

        error
    end
  end

  @doc """
  Get a user from a given id
  ## Examples

      iex> get_user_by_id("UUID")
      {:ok, %User{}}

       iex> get_user_by_id("Invalid_UUID")
      {:error, :not_found}

  """
  @spec get_user_by_id(Binary_id.t()) :: User.t() | {:error, :not_found}
  def get_user_by_id(user_id) do
    case Accounts.get_user!(user_id) do
      nil ->
        Logger.info("User with id: #{user_id} not found")
        {:error, :not_found}

      user ->
        Logger.info("User with id #{user_id} was requested")
        user
    end
  end

  @doc """
  Get a user from a given email and password
  ## Examples

      iex> get_user_email_password("email.test@test.com", "Password@test123")
      {:ok, %User{}}

       iex> get_user_email_password("invalid_email@test.com",  "password@testinvalid")
      {:error, :not_found}

  """
  @spec get_user_email_password(String.t(), String.t()) :: {:ok, User.t()} | {:error, :not_found}
  def get_user_email_password(email, password) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        Logger.error("User with email: #{email} not found")
        {:error, :not_found}

      user ->
        Logger.info("User with email: #{email} requested")
        {:ok, user}
    end
  end

  @doc """
  Insert a new guardian token for a user
  ## Examples

      iex> insert_token_user("user_id", "token")
      :ok

  """
  @spec insert_token_user(Binary_id.t(), String.t()) :: :ok
  def insert_token_user(user_id, token), do: Accounts.insert_user_session_token(user_id, token)

  @doc """
  Delete all previews token from a given user id
  ## Examples

      iex> delete_previews_token("user_id")
      :ok
  """
  @spec delete_previews_token(Binary_id.t()) :: :ok
  def delete_previews_token(user_id) do
    Logger.info("All previews tokens from user #{user_id} was deleted")
    Accounts.delete_user_session_token(user_id)
  end

  @doc """
  Authenticate user from given email and password
  ## Examples

      iex> authenticate_user("email.test@test.com", "Password@test123")
       {:ok, %User{}}

       iex> authenticate_user("invalid_email@test.com",  "password@testinvalid")
       {:error, :invalid_credentials}
  """
  @spec authenticate_user(String.t(), String.t()) ::
          {:ok, User.t()} | {:error, :invalid_credentials}
  def authenticate_user(email, password) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil -> {:error, :invalid_credentials}
      user -> {:ok, user}
    end
  end

  @doc """
  Authenticate user from a given token and verify is valid
  ## Examples

      iex> validate_token("email.test@test.com", "Password@test123")
       {:ok, %User{}}

       iex> validate_token("invalid_email@test.com",  "password@testinvalid")
       {:error, :invalid_credentials}
  """
  @spec validate_token(String.t()) ::
          {:ok, :authorized} | {:error, :unathourazed}
  def validate_token(token) do
    case Accounts.validate_token_user(token) do
      nil -> {:error, :unathourazed}
      _user_token -> {:ok, :authorized}
    end
  end
end
