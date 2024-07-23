defmodule MessagingServiceWeb.Guardian do
  use Guardian, otp_app: :messaging_service_web

  alias MessagingService.Service.UserService

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    case UserService.get_user_by_id(id) do
      nil -> {:error, :reason_for_error}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
