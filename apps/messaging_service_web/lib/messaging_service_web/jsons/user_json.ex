defmodule MessagingServiceWeb.UserJson do
  def user(%{user: user, token: token, status: status}) do
    %{status: status, user: user.email, token: token}
  end
end
