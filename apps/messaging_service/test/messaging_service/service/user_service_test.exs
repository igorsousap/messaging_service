defmodule MessagingService.Service.UserServiceTest do
  use MessagingService.DataCase, async: true

  import MessagingService.AccountsFixtures
  alias MessagingServiceWeb.Guardian

  alias MessagingService.Persistence.Accounts.User
  alias MessagingService.Service.UserService

  @moduletag :capture_log

  setup do
    user = user_fixture()
    {:ok, token_guardian, _claims} = Guardian.encode_and_sign(user)
    {:ok, user: user, token: token_guardian}
  end

  describe "create_user/1" do
    test "should create a user" do
      user_params = %{
        email: "email.test@test_insert.com",
        password: "Passwordinsert@test123"
      }

      assert {:ok, %User{}} = UserService.create_user(user_params)
    end

    test "should return error when field are empty" do
      user_params = %{email: nil, password: nil}

      assert {:error, changeset} =
               UserService.create_user(user_params)

      assert %{email: ["can't be blank"], password: ["can't be blank"]} ==
               errors_on(changeset)
    end
  end

  describe "get_user_by_id/1" do
    test "Return a user as given user_id", %{user: user} do
      assert %User{} = UserService.get_user_by_id(user.id)
    end

    test "should return error not_found when passed a non existing id" do
      assert {:error, :not_found} = UserService.get_user_by_id(Ecto.UUID.autogenerate())
    end
  end

  describe "get_user_email_password/2" do
    test "Return a user as given email and password", %{user: user} do
      assert {:ok, %User{}} = UserService.get_user_email_password(user.email, "Validpassword@123")
    end

    test "should return error not_found when passed a non existing email or password" do
      assert {:error, :not_found} =
               UserService.get_user_email_password("invalid@email.com", "invalid_passwor@123")
    end
  end

  describe " insert_token_user/2" do
    test "Should insert a token for a given user_id", %{user: user, token: token} do
      assert :ok = UserService.insert_token_user(user.id, token)
    end
  end

  describe "delete_previews_token/1" do
    test "Should delete all tokens for a given user_id", %{user: user} do
      assert :ok = UserService.delete_previews_token(user.id)
    end
  end

  describe "authenticate_user/2" do
    test "Should authenticate user with email and password", %{user: user} do
      assert {:ok, %User{}} = UserService.authenticate_user(user.email, "Validpassword@123")
    end

    test "Should unathourize a user with email or password wrongs", %{user: user} do
      assert {:error, :invalid_credentials} =
               UserService.authenticate_user(user.email, "invalid_passwor@123")
    end
  end

  describe "validate_token/2" do
    test "Should validate token and authenticate", %{user: user, token: token} do
      UserService.insert_token_user(user.id, token)
      assert {:ok, :authorized} = UserService.validate_token(token)
    end

    test "Should unathourize a user with wrong or invalid token" do
      assert {:error, :unathourazed} =
               UserService.validate_token("invalid_token")
    end
  end
end
