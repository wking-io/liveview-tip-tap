defmodule WithoutCeasingWeb.TranslationLive.Show do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

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
     |> assign(:translation, Bible.get_translation!(id))}
  end

  defp page_title(:show), do: "Show Translation"
  defp page_title(:edit), do: "Edit Translation"
end
