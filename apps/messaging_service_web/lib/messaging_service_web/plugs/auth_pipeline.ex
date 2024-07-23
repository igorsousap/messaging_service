defmodule MessagingServiceWeb.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :messaging_service_web,
    module: MessagingServiceWeb.Guardian,
    error_handler: MessagingServiceWeb.ErrorHandler

  plug Guardian.Plug.VerifyHeader, schema: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
