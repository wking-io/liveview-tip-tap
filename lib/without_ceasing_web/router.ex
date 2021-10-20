defmodule WithoutCeasingWeb.Router do
  use WithoutCeasingWeb, :router

  import WithoutCeasingWeb.MemberAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WithoutCeasingWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_member
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## Authentication routes

  scope "/", WithoutCeasingWeb do
    pipe_through [:browser, :redirect_if_member_is_authenticated]

    get "/members/register", MemberRegistrationController, :new
    post "/members/register", MemberRegistrationController, :create
    get "/members/sign-in", MemberSessionController, :new
    post "/members/sign-in", MemberSessionController, :create
    get "/members/reset-password", MemberResetPasswordController, :new
    post "/members/reset-password", MemberResetPasswordController, :create
    get "/members/reset-password/:token", MemberResetPasswordController, :edit
    put "/members/reset-password/:token", MemberResetPasswordController, :update
  end

  scope "/", WithoutCeasingWeb do
    live_session :app, on_mount: WithoutCeasingWeb.MemberLiveAuth do
      pipe_through [:browser, :require_authenticated_member]

      get "/members/settings", MemberSettingsController, :edit
      put "/members/settings", MemberSettingsController, :update
      get "/members/settings/confirm-email/:token", MemberSettingsController, :confirm_email

      live "/dashboard", DashboardLive.Index, :index

      live "/bible", BibleLive.Index, :index
      live "/bible/:book/:chapter", BibleLive.Show, :show

      live "/entries", EntryLive.Index, :index
      live "/entries/:entry", EntryLive.Show, :show
      live "/entries/:entry/edit", EntryLive.Show, :edit

      live "/resources", ResourceLive.Index, :index
      live "/resources/:resource", ResourceLive.Show, :show
      live "/resources/:resource/edit", ResourceLive.Show, :edit
    end
  end

  scope "/", WithoutCeasingWeb do
    pipe_through [:browser]

    delete "/members/sign-out", MemberSessionController, :delete
    get "/members/confirm", MemberConfirmationController, :new
    post "/members/confirm", MemberConfirmationController, :create
    get "/members/confirm/:token", MemberConfirmationController, :edit
    post "/members/confirm/:token", MemberConfirmationController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", WithoutCeasingWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: WithoutCeasingWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
