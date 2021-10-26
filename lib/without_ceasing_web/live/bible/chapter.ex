defmodule WithoutCeasingWeb.BibleLive.Chapter do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

  require Logger

  import WithoutCeasingWeb.Components.Bible

  alias Ecto.Changeset
  alias WithoutCeasing.Bible
  alias WithoutCeasing.Content
  alias WithoutCeasing.Content.Entry
  alias WithoutCeasingWeb.Components.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"book" => book, "chapter" => chapter}) do
    socket
    |> assign(
      page_title: "#{book} #{chapter}",
      book: book,
      chapter: Bible.get_chapter(book, chapter),
      current_verses: [],
      content: "",
      changeset: nil,
      entry: %Entry{}
    )
    |> update(:current_panel, &if(&1 == "menu", do: &1, else: nil))
  end

  defp apply_action(
         socket,
         :show,
         %{"book" => book, "chapter" => chapter, "verses" => verses}
       ) do
    socket
    |> assign(
      page_title: "#{book} #{chapter}",
      book: book,
      chapter: Bible.get_chapter(book, chapter),
      current_verses: verses,
      content: "",
      changeset: nil,
      entry: %Entry{},
      current_panel: "details"
    )
  end

  defp apply_action(
         socket,
         :create,
         %{"book" => book, "chapter" => chapter, "verses" => verses}
       ) do
    entry = %Entry{}

    socket
    |> assign(
      page_title: "#{book} #{chapter}",
      book: book,
      chapter: Bible.get_chapter(book, chapter),
      current_verses: verses,
      content: "",
      changeset: Content.change_entry(entry),
      entry: entry,
      current_panel: "details"
    )
  end

  defp apply_action(
         socket,
         :edit,
         %{"book" => book, "chapter" => chapter, "entry" => entry_id, "verses" => verses}
       ) do
    entry = Content.get_entry!(entry_id)

    socket
    |> assign(
      page_title: "#{book} #{chapter}",
      book: book,
      chapter: Bible.get_chapter(book, chapter),
      current_verses: verses,
      content: entry.content,
      entry: entry,
      changeset: Content.change_entry(entry),
      current_panel: "details"
    )
  end

  def handle_event("close_panel", _, socket), do: {:noreply, update_page(socket)}

  def handle_event("unselect_verse", %{"verse" => verse}, socket) do
    verses = Enum.filter(socket.assigns.current_verses, &(&1 != verse))
    {:noreply, update_page(socket, verses)}
  end

  # TODO: Check for shift key press and select all verses in between too
  def handle_event("select_verse", %{"verse" => verse}, socket) do
    verses = [verse | socket.assigns.current_verses]
    {:noreply, update_page(socket, verses)}
  end

  def handle_event("save", %{"entry" => entry_params}, socket) do
    case Content.create_entry(
           entry_params,
           socket.assigns.current_verses,
           socket.assigns.current_member
         ) do
      {:ok, entry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Entry created successfully")
         |> assign(socket, changeset: Content.change_entry(entry))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp update_page(socket) do
    push_patch(socket,
      to:
        Routes.bible_chapter_path(
          socket,
          :index,
          socket.assigns.book,
          socket.assigns.chapter.chapter
        )
    )
  end

  defp update_page(socket, verses) do
    push_patch(socket,
      to:
        Routes.bible_chapter_path(
          socket,
          :show,
          socket.assigns.book,
          socket.assigns.chapter.chapter,
          verses: verses
        )
    )
  end
end
