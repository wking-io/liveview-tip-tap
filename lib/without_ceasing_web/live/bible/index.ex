defmodule WithoutCeasingWeb.BibleLive.Index do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _) do
    socket
    |> assign(page_title: "Table Of Contents")
  end
end
