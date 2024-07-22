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
        {:ok, :created}

      error ->
        Logger.info("user not created errors: #{inspect(error)}")
        error
    end
  end
end
