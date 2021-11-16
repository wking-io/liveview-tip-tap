defmodule WithoutCeasingWeb.BibleLive.Chapter do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

  require Logger

  import WithoutCeasingWeb.Components.Bible
  import WithoutCeasingWeb.Components.Editor
  import WithoutCeasingWeb.Components.Note

  alias WithoutCeasing.Bible
  alias WithoutCeasing.Content
  alias WithoutCeasing.Content.Note
  alias WithoutCeasingWeb.Components.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"book" => book, "chapter" => chapter} = params, _url, socket) do
    {:noreply,
     socket
     |> assign(
       page_title: "#{book} #{chapter}",
       book: book,
       chapter: Bible.get_chapter(book, chapter)
     )
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(
         socket,
         :index,
         %{"verses" => verses}
       ) do
    notes =
      verses
      |> Enum.map(&String.to_integer/1)
      |> Content.get_notes(socket.assigns.current_member)

    socket
    |> assign(
      current_verses: verses,
      note: %Note{},
      notes: notes
    )
  end

  defp apply_action(socket, :index, %{"book" => book, "chapter" => chapter}) do
    notes = Content.get_chapter_notes(book, chapter, socket.assigns.current_member)

    assign(socket,
      current_verses: [],
      notes: notes
    )
  end

  defp apply_action(socket, :create, %{"verses" => verses}) do
    assign(socket,
      current_verses: verses,
      changeset: Content.change_note(),
      note: %Note{}
    )
  end

  defp apply_action(socket, :create, _) do
    assign(socket,
      current_verses: [],
      changeset: Content.change_note(),
      note: %Note{}
    )
  end

  defp apply_action(socket, :show, %{"note" => note_id, "verses" => verses}) do
    note = Content.get_note!(note_id)

    assign(socket,
      current_verses: verses,
      note: note
    )
  end

  defp apply_action(socket, :edit, %{"note" => note_id, "verses" => verses}) do
    note = Content.get_note!(note_id)

    assign(socket,
      current_verses: verses,
      note: note,
      changeset: Content.change_note(note)
    )
  end

  @impl true
  def handle_event("select_disabled", _, socket) do
    {:noreply, put_flash(socket, :info, "Cannot change verse selection")}
  end

  def handle_event("unselect_all", %{"action" => action}, socket) do
    update_chapter(socket, String.to_existing_atom(action), [])
  end

  def handle_event("unselect_verse", %{"verse" => verse, "action" => action}, socket) do
    verses = Enum.filter(socket.assigns.current_verses, &(&1 != verse))
    update_chapter(socket, String.to_existing_atom(action), verses)
  end

  def handle_event("select_verse", %{"verse" => verse, "action" => action}, socket) do
    verses = [verse | socket.assigns.current_verses]
    update_chapter(socket, String.to_existing_atom(action), verses)
  end

  def handle_event("save", %{"note" => note_params}, socket) do
    save_note(socket, socket.assigns.action, note_params)
  end

  defp save_note(socket, :edit, note_params) do
    verses = get_current_verses(socket.assigns)
    member = socket.assigns.current_member
    note = socket.assigns.note

    note_params
    |> Content.update_note(note, verses, member)
    |> handle_save_result(socket)
  end

  defp save_note(socket, :create, note_params) do
    verses = get_current_verses(socket.assigns)
    member = socket.assigns.current_member

    note_params
    |> Content.create_note(verses, member)
    |> handle_save_result(socket)
  end

  defp handle_save_result({:ok, _note}, socket) do
    update_chapter(socket, :index, socket.assigns.current_verses)
  end

  defp handle_save_result({:error, %Ecto.Changeset{} = changeset}, socket) do
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def verses_to_param(%Note{verses: verses}), do: Enum.map(verses, & &1.id)

  defp get_current_verses(%{current_verses: [], chapter: chapter}), do: chapter.verses
  defp get_current_verses(%{current_verses: verses}), do: verses

  defp update_chapter(socket, action, verses) when action in [:show, :edit] do
    {:noreply,
     push_patch(socket,
       to:
         Routes.bible_chapter_path(
           socket,
           action,
           socket.assigns.book,
           socket.assigns.chapter.chapter,
           socket.assigns.note.id,
           verses: verses
         )
     )}
  end

  defp update_chapter(socket, action, verses) when action in [:index, :create] do
    {:noreply,
     push_patch(socket,
       to:
         Routes.bible_chapter_path(
           socket,
           action,
           socket.assigns.book,
           socket.assigns.chapter.chapter,
           verses: verses
         )
     )}
  end

  defp parse_verses(verses) do
    verses
    |> Enum.map(& &1.id)
    |> Bible.prettify_verses()
  end
end
