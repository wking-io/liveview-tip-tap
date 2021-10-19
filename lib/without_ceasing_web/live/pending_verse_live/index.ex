defmodule WithoutCeasingWeb.VerseRevisionLive.Index do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

  alias WithoutCeasing.Bible
  alias WithoutCeasing.Bible.VerseRevision

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :pending_verses, list_pending_verses())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pending verse")
    |> assign(:pending_verse, Bible.get_pending_verse!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Pending verse")
    |> assign(:pending_verse, %VerseRevision{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pending verses")
    |> assign(:pending_verse, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pending_verse = Bible.get_pending_verse!(id)
    {:ok, _} = Bible.delete_pending_verse(pending_verse)

    {:noreply, assign(socket, :pending_verses, list_pending_verses())}
  end

  defp list_pending_verses do
    Bible.list_pending_verses()
  end
end
