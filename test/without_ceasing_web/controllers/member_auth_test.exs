defmodule WithoutCeasingWeb.MemberAuthTest do
  use WithoutCeasingWeb.ConnCase, async: true

  alias WithoutCeasing.Accounts
  alias WithoutCeasingWeb.MemberAuth
  import WithoutCeasing.AccountsFixtures

  @remember_me_cookie "_without_ceasing_web_member_remember_me"

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, WithoutCeasingWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{member: member_fixture(), conn: conn}
  end

  describe "log_in_member/3" do
    test "stores the member token in the session", %{conn: conn, member: member} do
      conn = MemberAuth.log_in_member(conn, member)
      assert token = get_session(conn, :member_token)
      assert get_session(conn, :live_socket_id) == "members_sessions:#{Base.url_encode64(token)}"
      assert redirected_to(conn) == "/"
      assert Accounts.get_member_by_session_token(token)
    end

    test "clears everything previously stored in the session", %{conn: conn, member: member} do
      conn = conn |> put_session(:to_be_removed, "value") |> MemberAuth.log_in_member(member)
      refute get_session(conn, :to_be_removed)
    end

    test "redirects to the configured path", %{conn: conn, member: member} do
      conn = conn |> put_session(:member_return_to, "/hello") |> MemberAuth.log_in_member(member)
      assert redirected_to(conn) == "/hello"
    end

    test "writes a cookie if remember_me is configured", %{conn: conn, member: member} do
      conn = conn |> fetch_cookies() |> MemberAuth.log_in_member(member, %{"remember_me" => "true"})
      assert get_session(conn, :member_token) == conn.cookies[@remember_me_cookie]

      assert %{value: signed_token, max_age: max_age} = conn.resp_cookies[@remember_me_cookie]
      assert signed_token != get_session(conn, :member_token)
      assert max_age == 5_184_000
    end
  end

  describe "logout_member/1" do
    test "erases session and cookies", %{conn: conn, member: member} do
      member_token = Accounts.generate_member_session_token(member)

      conn =
        conn
        |> put_session(:member_token, member_token)
        |> put_req_cookie(@remember_me_cookie, member_token)
        |> fetch_cookies()
        |> MemberAuth.log_out_member()

      refute get_session(conn, :member_token)
      refute conn.cookies[@remember_me_cookie]
      assert %{max_age: 0} = conn.resp_cookies[@remember_me_cookie]
      assert redirected_to(conn) == "/"
      refute Accounts.get_member_by_session_token(member_token)
    end

    test "broadcasts to the given live_socket_id", %{conn: conn} do
      live_socket_id = "members_sessions:abcdef-token"
      WithoutCeasingWeb.Endpoint.subscribe(live_socket_id)

      conn
      |> put_session(:live_socket_id, live_socket_id)
      |> MemberAuth.log_out_member()

      assert_receive %Phoenix.Socket.Broadcast{event: "disconnect", topic: ^live_socket_id}
    end

    test "works even if member is already logged out", %{conn: conn} do
      conn = conn |> fetch_cookies() |> MemberAuth.log_out_member()
      refute get_session(conn, :member_token)
      assert %{max_age: 0} = conn.resp_cookies[@remember_me_cookie]
      assert redirected_to(conn) == "/"
    end
  end

  describe "fetch_current_member/2" do
    test "authenticates member from session", %{conn: conn, member: member} do
      member_token = Accounts.generate_member_session_token(member)
      conn = conn |> put_session(:member_token, member_token) |> MemberAuth.fetch_current_member([])
      assert conn.assigns.current_member.id == member.id
    end

    test "authenticates member from cookies", %{conn: conn, member: member} do
      logged_in_conn =
        conn |> fetch_cookies() |> MemberAuth.log_in_member(member, %{"remember_me" => "true"})

      member_token = logged_in_conn.cookies[@remember_me_cookie]
      %{value: signed_token} = logged_in_conn.resp_cookies[@remember_me_cookie]

      conn =
        conn
        |> put_req_cookie(@remember_me_cookie, signed_token)
        |> MemberAuth.fetch_current_member([])

      assert get_session(conn, :member_token) == member_token
      assert conn.assigns.current_member.id == member.id
    end

    test "does not authenticate if data is missing", %{conn: conn, member: member} do
      _ = Accounts.generate_member_session_token(member)
      conn = MemberAuth.fetch_current_member(conn, [])
      refute get_session(conn, :member_token)
      refute conn.assigns.current_member
    end
  end

  describe "redirect_if_member_is_authenticated/2" do
    test "redirects if member is authenticated", %{conn: conn, member: member} do
      conn = conn |> assign(:current_member, member) |> MemberAuth.redirect_if_member_is_authenticated([])
      assert conn.halted
      assert redirected_to(conn) == "/"
    end

    test "does not redirect if member is not authenticated", %{conn: conn} do
      conn = MemberAuth.redirect_if_member_is_authenticated(conn, [])
      refute conn.halted
      refute conn.status
    end
  end

  describe "require_authenticated_member/2" do
    test "redirects if member is not authenticated", %{conn: conn} do
      conn = conn |> fetch_flash() |> MemberAuth.require_authenticated_member([])
      assert conn.halted
      assert redirected_to(conn) == Routes.member_session_path(conn, :new)
      assert get_flash(conn, :error) == "You must log in to access this page."
    end

    test "stores the path to redirect to on GET", %{conn: conn} do
      halted_conn =
        %{conn | path_info: ["foo"], query_string: ""}
        |> fetch_flash()
        |> MemberAuth.require_authenticated_member([])

      assert halted_conn.halted
      assert get_session(halted_conn, :member_return_to) == "/foo"

      halted_conn =
        %{conn | path_info: ["foo"], query_string: "bar=baz"}
        |> fetch_flash()
        |> MemberAuth.require_authenticated_member([])

      assert halted_conn.halted
      assert get_session(halted_conn, :member_return_to) == "/foo?bar=baz"

      halted_conn =
        %{conn | path_info: ["foo"], query_string: "bar", method: "POST"}
        |> fetch_flash()
        |> MemberAuth.require_authenticated_member([])

      assert halted_conn.halted
      refute get_session(halted_conn, :member_return_to)
    end

    test "does not redirect if member is authenticated", %{conn: conn, member: member} do
      conn = conn |> assign(:current_member, member) |> MemberAuth.require_authenticated_member([])
      refute conn.halted
      refute conn.status
    end
  end
end
