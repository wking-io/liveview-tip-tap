defmodule WithoutCeasingWeb.BibleLive.Chapter do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

  require Logger

  import WithoutCeasingWeb.Components.Bible
  import WithoutCeasingWeb.Components.Editor
  import WithoutCeasingWeb.Components.Entry

  alias WithoutCeasing.Bible
  alias WithoutCeasing.Content
  alias WithoutCeasing.Content.Entry
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
    entries =
      verses
      |> Enum.map(&String.to_integer/1)
      |> Content.get_entries(socket.assigns.current_member)

    socket
    |> assign(
      current_verses: verses,
      entry: %Entry{},
      entries: entries
    )
  end

  defp apply_action(socket, :index, %{"book" => book, "chapter" => chapter}) do
    entries = Content.get_chapter_entries(book, chapter, socket.assigns.current_member)

    assign(socket,
      current_verses: [],
      entries: entries
    )
  end

  defp apply_action(socket, :create, %{"verses" => verses}) do
    assign(socket,
      current_verses: verses,
      changeset: Content.change_entry(),
      entry: %Entry{}
    )
  end

  defp apply_action(socket, :create, _) do
    assign(socket,
      current_verses: [],
      changeset: Content.change_entry(),
      entry: %Entry{}
    )
  end

  defp apply_action(socket, :show, %{"entry" => entry_id, "verses" => verses}) do
    entry = Content.get_entry!(entry_id)

    assign(socket,
      current_verses: verses,
      entry: entry
    )
  end

  defp apply_action(socket, :edit, %{"entry" => entry_id, "verses" => verses}) do
    entry = Content.get_entry!(entry_id)

    assign(socket,
      current_verses: verses,
      entry: entry,
      changeset: Content.change_entry(entry)
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

  def handle_event("save", %{"entry" => entry_params}, socket) do
    save_entry(socket, socket.assigns.action, entry_params)
  end

  defp save_entry(socket, :edit, entry_params) do
    verses = get_current_verses(socket.assigns)
    member = socket.assigns.current_member
    entry = socket.assigns.entry

    entry_params
    |> Content.update_entry(entry, verses, member)
    |> handle_save_result(socket)
  end

  defp save_entry(socket, :create, entry_params) do
    verses = get_current_verses(socket.assigns)
    member = socket.assigns.current_member

    entry_params
    |> Content.create_entry(verses, member)
    |> handle_save_result(socket)
  end

  defp handle_save_result({:ok, _entry}, socket) do
    update_chapter(socket, :index, socket.assigns.current_verses)
  end

  defp handle_save_result({:error, %Ecto.Changeset{} = changeset}, socket) do
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def verses_to_param(%Entry{verses: verses}), do: Enum.map(verses, & &1.id)

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
           socket.assigns.entry.id,
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
