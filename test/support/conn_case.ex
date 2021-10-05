defmodule WithoutCeasingWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use WithoutCeasingWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import WithoutCeasingWeb.ConnCase

      alias WithoutCeasingWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint WithoutCeasingWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(WithoutCeasing.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(WithoutCeasing.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in members.

      setup :register_and_log_in_member

  It stores an updated connection and a registered member in the
  test context.
  """
  def register_and_log_in_member(%{conn: conn}) do
    member = WithoutCeasing.IdentityFixtures.member_fixture()
    %{conn: log_in_member(conn, member), member: member}
  end

  @doc """
  Logs the given `member` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_member(conn, member) do
    token = WithoutCeasing.Identity.generate_member_session_token(member)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:member_token, token)
  end
end
