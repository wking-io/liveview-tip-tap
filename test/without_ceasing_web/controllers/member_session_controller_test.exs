defmodule WithoutCeasingWeb.MemberSessionControllerTest do
  use WithoutCeasingWeb.ConnCase, async: true

  import WithoutCeasing.AccountsFixtures

  setup do
    %{member: member_fixture()}
  end

  describe "GET /members/log_in" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, Routes.member_session_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Register</a>"
      assert response =~ "Forgot your password?</a>"
    end

    test "redirects if already logged in", %{conn: conn, member: member} do
      conn = conn |> log_in_member(member) |> get(Routes.member_session_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /members/log_in" do
    test "logs the member in", %{conn: conn, member: member} do
      conn =
        post(conn, Routes.member_session_path(conn, :create), %{
          "member" => %{"email" => member.email, "password" => valid_member_password()}
        })

      assert get_session(conn, :member_token)
      assert redirected_to(conn) == "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ member.email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "logs the member in with remember me", %{conn: conn, member: member} do
      conn =
        post(conn, Routes.member_session_path(conn, :create), %{
          "member" => %{
            "email" => member.email,
            "password" => valid_member_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_without_ceasing_web_member_remember_me"]
      assert redirected_to(conn) == "/"
    end

    test "logs the member in with return to", %{conn: conn, member: member} do
      conn =
        conn
        |> init_test_session(member_return_to: "/foo/bar")
        |> post(Routes.member_session_path(conn, :create), %{
          "member" => %{
            "email" => member.email,
            "password" => valid_member_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
    end

    test "emits error message with invalid credentials", %{conn: conn, member: member} do
      conn =
        post(conn, Routes.member_session_path(conn, :create), %{
          "member" => %{"email" => member.email, "password" => "invalid_password"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Invalid email or password"
    end
  end

  describe "DELETE /members/log_out" do
    test "logs the member out", %{conn: conn, member: member} do
      conn = conn |> log_in_member(member) |> delete(Routes.member_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :member_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the member is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.member_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :member_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end
  end
end
