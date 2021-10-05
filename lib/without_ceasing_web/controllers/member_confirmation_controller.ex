defmodule WithoutCeasingWeb.MemberConfirmationController do
  use WithoutCeasingWeb, :controller

  alias WithoutCeasing.Identity

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"member" => %{"email" => email}}) do
    if member = Identity.get_member_by_email(email) do
      Identity.deliver_member_confirmation_instructions(
        member,
        &Routes.member_confirmation_url(conn, :edit, &1)
      )
    end

    # In order to prevent user enumeration attacks, regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      "If your email is in our system and it has not been confirmed yet, " <>
        "you will receive an email with instructions shortly."
    )
    |> redirect(to: "/")
  end

  def edit(conn, %{"token" => token}) do
    render(conn, "edit.html", token: token)
  end

  # Do not log in the member after confirmation to avoid a
  # leaked token giving the member access to the account.
  def update(conn, %{"token" => token}) do
    case Identity.confirm_member(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Member confirmed successfully.")
        |> redirect(to: "/")

      :error ->
        # If there is a current member and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the member themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_member: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: "/")

          %{} ->
            conn
            |> put_flash(:error, "Member confirmation link is invalid or it has expired.")
            |> redirect(to: "/")
        end
    end
  end
end
