defmodule WithoutCeasingWeb.MemberLiveAuth do
  import Phoenix.LiveView

  alias WithoutCeasing.Identity

  def mount(_params, %{"member_token" => member_token} = _session, socket) do
    socket =
      assign_new(socket, :current_member, fn ->
        fetch_current_member(member_token)
      end)

    if socket.assigns.current_member.confirmed_at do
      {:cont,
       socket
       |> assign(current_panel: "menu")
       |> assign(current_verse: nil)}
    else
      {:halt, redirect(socket, to: "/members/sign-in")}
    end
  end

  def mount(_params, _session, socket) do
    {:halt, redirect(socket, to: "/members/sign-in")}
  end

  defp fetch_current_member(member_token) do
    member_token && Identity.get_member_by_session_token(member_token)
  end
end
