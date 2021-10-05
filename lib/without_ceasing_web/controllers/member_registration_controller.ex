defmodule WithoutCeasingWeb.MemberRegistrationController do
  use WithoutCeasingWeb, :controller

  alias WithoutCeasing.Accounts
  alias WithoutCeasing.Accounts.Member
  alias WithoutCeasingWeb.MemberAuth

  def new(conn, _params) do
    changeset = Accounts.change_member_registration(%Member{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"member" => member_params}) do
    case Accounts.register_member(member_params) do
      {:ok, member} ->
        {:ok, _} =
          Accounts.deliver_member_confirmation_instructions(
            member,
            &Routes.member_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "Member created successfully.")
        |> MemberAuth.log_in_member(member)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
