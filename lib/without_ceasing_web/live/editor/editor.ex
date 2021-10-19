defmodule WithoutCeasingWeb.EditorLive.Show do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

  alias WithoutCeasing.Bible
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :verses, list_verses())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{
         "translation" => translation,
         "book" => book,
         "chapter" => chapter
       }) do
    {verses, editor} = Bible.get_editor(translation, book, String.to_integer(chapter))

    socket
    |> assign(:page_title, "#{book} #{chapter}")
    |> assign(:verses, verses)
    |> assign(:changeset, editor)
  end

  def handle_event("save", %{"editor" => %{"verses" => verses}}, socket) do
    submit_verses(socket, socket.assigns.action, verses)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    verse = Bible.get_verse!(id)
    {:ok, _} = Bible.delete_verse(verse)

    {:noreply, assign(socket, :verses, list_verses())}
  end

  defp submit_verses(socket, :edit, verses) do
    case Bible.submit_verses(socket.assigns.verses, verses) do
      {:ok, _verse} ->
        {:noreply,
         socket
         |> put_flash(:info, "Verse updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp list_verses do
    Bible.list_verses()
  end
end
