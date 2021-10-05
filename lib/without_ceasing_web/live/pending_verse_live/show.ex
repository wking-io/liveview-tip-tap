defmodule WithoutCeasingWeb.VerseRevisionLive.Show do
  use WithoutCeasingWeb, :live_view

  alias WithoutCeasing.Bible

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pending_verse, Bible.get_pending_verse!(id))}
  end

  defp page_title(:show), do: "Show Pending verse"
  defp page_title(:edit), do: "Edit Pending verse"
end
