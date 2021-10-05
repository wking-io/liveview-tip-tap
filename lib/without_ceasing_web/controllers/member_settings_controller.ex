defmodule WithoutCeasingWeb.MemberSettingsController do
  use WithoutCeasingWeb, :controller

  alias WithoutCeasing.Identity
  alias WithoutCeasingWeb.MemberAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "member" => member_params} = params
    member = conn.assigns.current_member

    case Identity.apply_member_email(member, password, member_params) do
      {:ok, applied_member} ->
        Identity.deliver_update_email_instructions(
          applied_member,
          member.email,
          &Routes.member_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your email change has been sent to the new address."
        )
        |> redirect(to: Routes.member_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "member" => member_params} = params
    member = conn.assigns.current_member

    case Identity.update_member_password(member, password, member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:member_return_to, Routes.member_settings_path(conn, :edit))
        |> MemberAuth.log_in_member(member)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Identity.update_member_email(conn.assigns.current_member, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.member_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.member_settings_path(conn, :edit))
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    member = conn.assigns.current_member

    conn
    |> assign(:email_changeset, Identity.change_member_email(member))
    |> assign(:password_changeset, Identity.change_member_password(member))
  end
end
