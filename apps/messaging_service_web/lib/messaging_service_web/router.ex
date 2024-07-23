defmodule MessagingServiceWeb.Router do
  use MessagingServiceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MessagingServiceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug MessagingServiceWeb.AuthPipeline
  end

  scope "/api/users", MessagingServiceWeb do
    pipe_through [:api]

    post "/register", UserController, :create
    post "/log_in", UserController, :log_in
  end

  scope "/api/webhook", MessagingServiceWeb do
    pipe_through [:api, :auth]

    post "/register", WebhookController, :create
    get "/", WebhookController, :get_webhooks
    put "/", WebhookController, :update_webhooks
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:messaging_service_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MessagingServiceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
