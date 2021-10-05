defmodule WithoutCeasingWeb.MemberResetPasswordController do
  use WithoutCeasingWeb, :controller

  alias WithoutCeasing.Accounts

  plug :get_member_by_reset_password_token when action in [:edit, :update]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"member" => %{"email" => email}}) do
    if member = Accounts.get_member_by_email(email) do
      Accounts.deliver_member_reset_password_instructions(
        member,
        &Routes.member_reset_password_url(conn, :edit, &1)
      )
    end

    # In order to prevent user enumeration attacks, regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      "If your email is in our system, you will receive instructions to reset your password shortly."
    )
    |> redirect(to: "/")
  end

  def edit(conn, _params) do
    render(conn, "edit.html", changeset: Accounts.change_member_password(conn.assigns.member))
  end

  # Do not log in the member after reset password to avoid a
  # leaked token giving the member access to the account.
  def update(conn, %{"member" => member_params}) do
    case Accounts.reset_member_password(conn.assigns.member, member_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Password reset successfully.")
        |> redirect(to: Routes.member_session_path(conn, :new))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  defp get_member_by_reset_password_token(conn, _opts) do
    %{"token" => token} = conn.params

    if member = Accounts.get_member_by_reset_password_token(token) do
      conn |> assign(:member, member) |> assign(:token, token)
    else
      conn
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
