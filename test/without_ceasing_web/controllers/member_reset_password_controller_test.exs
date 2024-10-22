defmodule WithoutCeasingWeb.MemberResetPasswordControllerTest do
  use WithoutCeasingWeb.ConnCase, async: true

  alias WithoutCeasing.Identity
  alias WithoutCeasing.Repo
  import WithoutCeasing.IdentityFixtures

  setup do
    %{member: member_fixture()}
  end

  describe "GET /members/reset_password" do
    test "renders the reset password page", %{conn: conn} do
      conn = get(conn, Routes.member_reset_password_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Forgot your password?</h1>"
    end
  end

  describe "POST /members/reset_password" do
    @tag :capture_log
    test "sends a new reset password token", %{conn: conn, member: member} do
      conn =
        post(conn, Routes.member_reset_password_path(conn, :create), %{
          "member" => %{"email" => member.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.get_by!(Identity.MemberToken, member_id: member.id).context == "reset_password"
    end

    test "does not send reset password token if email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.member_reset_password_path(conn, :create), %{
          "member" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.all(Identity.MemberToken) == []
    end
  end

  describe "GET /members/reset_password/:token" do
    setup %{member: member} do
      token =
        extract_member_token(fn url ->
          Identity.deliver_member_reset_password_instructions(member, url)
        end)

      %{token: token}
    end

    test "renders reset password", %{conn: conn, token: token} do
      conn = get(conn, Routes.member_reset_password_path(conn, :edit, token))
      assert html_response(conn, 200) =~ "<h1>Reset password</h1>"
    end

    test "does not render reset password with invalid token", %{conn: conn} do
      conn = get(conn, Routes.member_reset_password_path(conn, :edit, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Reset password link is invalid or it has expired"
    end
  end

  describe "PUT /members/reset_password/:token" do
    setup %{member: member} do
      token =
        extract_member_token(fn url ->
          Identity.deliver_member_reset_password_instructions(member, url)
        end)

      %{token: token}
    end

    test "resets password once", %{conn: conn, member: member, token: token} do
      conn =
        put(conn, Routes.member_reset_password_path(conn, :update, token), %{
          "member" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(conn) == Routes.member_session_path(conn, :new)
      refute get_session(conn, :member_token)
      assert get_flash(conn, :info) =~ "Password reset successfully"
      assert Identity.get_member_by_email_and_password(member.email, "new valid password")
    end

    test "does not reset password on invalid data", %{conn: conn, token: token} do
      conn =
        put(conn, Routes.member_reset_password_path(conn, :update, token), %{
          "member" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Reset password</h1>"
      assert response =~ "should be at least 12 character(s)"
      assert response =~ "does not match password"
    end

    test "does not reset password with invalid token", %{conn: conn} do
      conn = put(conn, Routes.member_reset_password_path(conn, :update, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Reset password link is invalid or it has expired"
    end
  end
end
