defmodule WithoutCeasingWeb.MemberRegistrationController do
  use WithoutCeasingWeb, :controller

  alias WithoutCeasing.Identity
  alias WithoutCeasing.Identity.Member
  alias WithoutCeasingWeb.MemberPlug

  def new(conn, _params) do
    changeset = Identity.change_member_registration(%Member{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"member" => member_params}) do
    case Identity.register_member(member_params) do
      {:ok, member} ->
        {:ok, _} =
          Identity.deliver_member_confirmation_instructions(
            member,
            &Routes.member_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "Member created successfully.")
        |> MemberPlug.sign_in_member(member)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
