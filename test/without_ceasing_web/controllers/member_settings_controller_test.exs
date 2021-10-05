defmodule WithoutCeasingWeb.MemberSettingsControllerTest do
  use WithoutCeasingWeb.ConnCase, async: true

  alias WithoutCeasing.Accounts
  import WithoutCeasing.AccountsFixtures

  setup :register_and_log_in_member

  describe "GET /members/settings" do
    test "renders settings page", %{conn: conn} do
      conn = get(conn, Routes.member_settings_path(conn, :edit))
      response = html_response(conn, 200)
      assert response =~ "<h1>Settings</h1>"
    end

    test "redirects if member is not logged in" do
      conn = build_conn()
      conn = get(conn, Routes.member_settings_path(conn, :edit))
      assert redirected_to(conn) == Routes.member_session_path(conn, :new)
    end
  end

  describe "PUT /members/settings (change password form)" do
    test "updates the member password and resets tokens", %{conn: conn, member: member} do
      new_password_conn =
        put(conn, Routes.member_settings_path(conn, :update), %{
          "action" => "update_password",
          "current_password" => valid_member_password(),
          "member" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(new_password_conn) == Routes.member_settings_path(conn, :edit)
      assert get_session(new_password_conn, :member_token) != get_session(conn, :member_token)
      assert get_flash(new_password_conn, :info) =~ "Password updated successfully"
      assert Accounts.get_member_by_email_and_password(member.email, "new valid password")
    end

    test "does not update password on invalid data", %{conn: conn} do
      old_password_conn =
        put(conn, Routes.member_settings_path(conn, :update), %{
          "action" => "update_password",
          "current_password" => "invalid",
          "member" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(old_password_conn, 200)
      assert response =~ "<h1>Settings</h1>"
      assert response =~ "should be at least 12 character(s)"
      assert response =~ "does not match password"
      assert response =~ "is not valid"

      assert get_session(old_password_conn, :member_token) == get_session(conn, :member_token)
    end
  end

  describe "PUT /members/settings (change email form)" do
    @tag :capture_log
    test "updates the member email", %{conn: conn, member: member} do
      conn =
        put(conn, Routes.member_settings_path(conn, :update), %{
          "action" => "update_email",
          "current_password" => valid_member_password(),
          "member" => %{"email" => unique_member_email()}
        })

      assert redirected_to(conn) == Routes.member_settings_path(conn, :edit)
      assert get_flash(conn, :info) =~ "A link to confirm your email"
      assert Accounts.get_member_by_email(member.email)
    end

    test "does not update email on invalid data", %{conn: conn} do
      conn =
        put(conn, Routes.member_settings_path(conn, :update), %{
          "action" => "update_email",
          "current_password" => "invalid",
          "member" => %{"email" => "with spaces"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Settings</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "is not valid"
    end
  end

  describe "GET /members/settings/confirm_email/:token" do
    setup %{member: member} do
      email = unique_member_email()

      token =
        extract_member_token(fn url ->
          Accounts.deliver_update_email_instructions(%{member | email: email}, member.email, url)
        end)

      %{token: token, email: email}
    end

    test "updates the member email once", %{conn: conn, member: member, token: token, email: email} do
      conn = get(conn, Routes.member_settings_path(conn, :confirm_email, token))
      assert redirected_to(conn) == Routes.member_settings_path(conn, :edit)
      assert get_flash(conn, :info) =~ "Email changed successfully"
      refute Accounts.get_member_by_email(member.email)
      assert Accounts.get_member_by_email(email)

      conn = get(conn, Routes.member_settings_path(conn, :confirm_email, token))
      assert redirected_to(conn) == Routes.member_settings_path(conn, :edit)
      assert get_flash(conn, :error) =~ "Email change link is invalid or it has expired"
    end

    test "does not update email with invalid token", %{conn: conn, member: member} do
      conn = get(conn, Routes.member_settings_path(conn, :confirm_email, "oops"))
      assert redirected_to(conn) == Routes.member_settings_path(conn, :edit)
      assert get_flash(conn, :error) =~ "Email change link is invalid or it has expired"
      assert Accounts.get_member_by_email(member.email)
    end

    test "redirects if member is not logged in", %{token: token} do
      conn = build_conn()
      conn = get(conn, Routes.member_settings_path(conn, :confirm_email, token))
      assert redirected_to(conn) == Routes.member_session_path(conn, :new)
    end
  end
end
