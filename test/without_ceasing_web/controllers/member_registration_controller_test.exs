defmodule WithoutCeasingWeb.MemberRegistrationControllerTest do
  use WithoutCeasingWeb.ConnCase, async: true

  import WithoutCeasing.IdentityFixtures

  describe "GET /members/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.member_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "Log in</a>"
      assert response =~ "Register</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn =
        conn
        |> sign_in_member(member_fixture())
        |> get(Routes.member_registration_path(conn, :new))

      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /members/register" do
    @tag :capture_log
    test "creates account and logs the member in", %{conn: conn} do
      email = unique_member_email()

      conn =
        post(conn, Routes.member_registration_path(conn, :create), %{
          "member" => valid_member_attributes(email: email)
        })

      assert get_session(conn, :member_token)
      assert redirected_to(conn) == "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.member_registration_path(conn, :create), %{
          "member" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
