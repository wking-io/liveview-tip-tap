defmodule WithoutCeasingWeb.MemberSessionController do
  use WithoutCeasingWeb, :controller

  alias WithoutCeasing.Accounts
  alias WithoutCeasingWeb.MemberAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"member" => member_params}) do
    %{"email" => email, "password" => password} = member_params

    if member = Accounts.get_member_by_email_and_password(email, password) do
      MemberAuth.log_in_member(conn, member, member_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> MemberAuth.log_out_member()
  end
end
