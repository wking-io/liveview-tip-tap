defmodule WithoutCeasingWeb.BibleLive do
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
       page_title: "#{String.capitalize(book)} #{chapter}",
       book: book,
       chapter: Bible.get_chapter(book, chapter, socket.assigns.current_member),
       action: socket.assigns.live_action
     )
     |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    book = "john"
    chapter = "12"

    {:noreply,
     socket
     |> assign(
       page_title: "#{String.capitalize(book)} #{chapter}",
       book: book,
       chapter: Bible.get_chapter(book, chapter, socket.assigns.current_member),
       action: socket.assigns.live_action
     )
     |> apply_action(
       socket.assigns.live_action,
       Map.merge(params, %{"book" => book, "chapter" => chapter})
     )}
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

  def handle_event("unselect_all", _, socket) do
    update_chapter(socket, socket.assigns.action, [])
  end

  def handle_event("unselect_verse", %{"verse" => verse}, socket) do
    verses = Enum.filter(socket.assigns.current_verses, &(&1 != verse))
    update_chapter(socket, socket.assigns.action, verses)
  end

  def handle_event("select_verse", %{"verse" => verse}, socket) do
    verses = [verse | socket.assigns.current_verses]
    update_chapter(socket, socket.assigns.action, verses)
  end

  def handle_event("highlight_verses", _params, socket) do
    verses = socket.assigns.current_verses -- socket.assigns.chapter.highlights

    case Bible.highlight_verses(verses, socket.assigns.current_member) do
      {:ok, member} ->
        {:noreply,
         socket
         |> assign(:current_member, member)
         |> update(
           :chapter,
           &Map.update!(&1, :highlights, fn highlights -> verses ++ highlights end)
         )}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to highlight verses.")}
    end
  end

  def handle_event("save", %{"note" => note_params}, socket) do
    save_note(socket, socket.assigns.action, note_params)
  end

  @impl true
  def render(assigns) do
    ~H"""
      <Layout.with_bible flash={@flash} show_actions={not Enum.empty?(@current_verses)}>
        <:bible>
          <h1 class="font-bold text-4xl font-serif"><%= "#{@chapter.book} #{@chapter.chapter}" %></h1>
          <.chapter chapter={@chapter} current_verses={@current_verses} action={@live_action} />
        </:bible>
        <div
          class={"w-full h-full"}
        >
          <%= case @live_action do %>
            <% action when action in [:edit, :create] -> %>
              <.editor content={@note.content} changeset={@changeset}>
                <:cancel_button>
                    <%= live_redirect "Cancel", to: Routes.bible_path(@socket, :index, @book, @chapter.chapter, verses: @current_verses), class: "flex items-center justify-center py-2 px-6 font-medium hover:bg-white focus:bg-white #{focus_classes()}" %>
                </:cancel_button>
              </.editor>
            <% :show -> %>
              <.note note={@note} />
            <% _ -> %>
              <div class="relative h-full flex flex-col" id="tabs" phx-hook="Tabs">
                <div class="flex items-end sm:text-sm border-b border-gray-900" role="tablist">
                    <button class={"relative flex flex-col sm:flex-row items-center justify-center text-center font-display font-bold py-3 px-6 relative z-10 hover:bg-gray-100 focus:bg-gray-100 focus:z-20 #{focus_classes()}"} role="tab" aria-controls="notes-panel" id="notes-tab-label" tabindex="0" aria-selected="true" phx-click={select_tab("notes", ["resources"])} phx-keyup={navigate()}>Notes</button>
                    <button class={"relative flex flex-col sm:flex-row items-center justify-center text-center font-display font-bold py-3 px-6 relative z-10 hover:bg-gray-100 focus:bg-white focus:z-20 #{focus_classes()}"} role="tab" aria-controls="resources-panel" id="resources-tab-label" tabindex="-1" aria-selected="false" phx-click={select_tab("resources", ["notes"])} phx-keyup={navigate()}>Resources</button>
                </div>
                <div tabindex="0" role="tabpanel" id="notes-panel" aria-labelledby="notes-label" class="flex-1 min-h-0 flex flex-col">
                  <%= unless @notes == [] do %>
                    <div class="overflow-y-auto flex-1 min-h-0">
                      <%= for note <- @notes do %>
                        <div x-data={"render(#{Jason.encode!(note.content)})"} class="border-b border-gray-900 space-y-4 p-6" id={"note-card-#{note.id}"}>
                          <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-4">
                              <p class="text-xs text-gray-900 space-x-2 flex items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                                </svg>
                                <span><%= parse_verses(note.verses) %></span>
                              </p>
                              <p class="text-xs text-gray-900 space-x-2 flex items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                                <span><%= Timex.format!(note.updated_at, "{Mshort} {D}, {YYYY}") %></span>
                              </p>
                            </div>
                            <.menu_button id="extras" class="h-full">
                              <:label>Actions</:label>
                              <div class="py-1" role="none">
                                <%= live_redirect "View", to: Routes.bible_path(@socket, :show, @book, @chapter.chapter, note.id, verses: verses_to_param(note)), class: "text-gray-700 font-medium block px-2 py-1 text-sm hover:text-brand-300 focus:outline-none focus:ring-2 focus:ring-brand-100", role: "menuitem", id: "menu-item-0" %>
                                <%= live_redirect "Edit", to: Routes.bible_path(@socket, :edit, @book, @chapter.chapter, note.id, verses: verses_to_param(note)), class: "text-gray-700 font-medium block px-2 py-1 text-sm hover:text-brand-300 focus:outline-none focus:ring-2 focus:ring-brand-100", role: "menuitem", id: "menu-item-0" %>
                                <%= link "Delete", to: "#", phx_click: "delete_note", phx_value_id: note.id, data: [confirm: "Are you sure?"], class: "text-error-500 font-medium block px-2 py-1 text-sm hover:text-error-700 focus:outline-none focus:ring-2 focus:ring-error-200", role: "menuitem", id: "menu-item-2" %>
                              </div>
                            </.menu_button>
                          </div>
                          <div phx-update="ignore" x-ref="content" class="prose">Loading...</div>
                        </div>
                      <% end %>
                    </div>
                    <div class="">
                      <%= live_redirect to: Routes.bible_path(@socket, :create, @book, @chapter.chapter, verses: @current_verses), class: "flex items-center text-white justify-center text-sm py-2 pl-2 pr-3 border border-transparent font-medium bg-gray-900 hover:bg-gray-800 #{focus_classes()}" do %>
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                        <span>Add Note</span>
                      <% end %>
                    </div>
                  <% else %>
                    <div class="flex flex-col items-center justify-center h-full space-y-4">
                      <img src={Routes.static_path(@socket, "/images/empty.png")} class="max-w-sm -mb-12 -mt-32" />
                      <p class="font-medium text-center">No notes yet. Add your first note for this passage.</p>
                      <%= live_redirect to: Routes.bible_path(@socket, :create, @book, @chapter.chapter, verses: @current_verses), class: "flex items-center justify-center py-3 pl-5 pr-6 bg-brand-200 text-white shadow font-medium hover:bg-brand-300 hover:shadow-md focus:outline-none focus:ring-2 focus:ring-brand-100 focus:bg-brand-300" do %>
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                        <span>Add An Note</span>
                      <% end %>
                    </div>

                  <% end %>
                </div>
                <div tabindex="-1" class="hidden flex-1 min-h-0 flex-col" role="tabpanel" id="resources-panel" aria-labelledby="resources-label">
                  <div class="flex flex-col items-center justify-center h-full space-y-4">
                    <img src={Routes.static_path(@socket, "/images/coming-soon.png")} class="max-w-sm -mt-12" />
                    <p class="font-medium text-center">In progress! More resources coming soon!</p>
                  </div>
                </div>
              </div>
          <% end %>
        </div>
      </Layout.with_bible>
    """
  end

  defp save_note(socket, :edit, note_params) do
    verses = get_current_verses(socket.assigns)
    member = socket.assigns.current_member
    note = socket.assigns.note

    note_params
    |> Map.put("verses", verses)
    |> Map.put("member", member)
    |> then(&Content.update_note(note, &1))
    |> handle_save_result(socket)
  end

  defp save_note(socket, :create, note_params) do
    verses = get_current_verses(socket.assigns)
    member = socket.assigns.current_member

    note_params
    |> Map.put("verses", verses)
    |> Map.put("member", member)
    |> Content.create_note()
    |> handle_save_result(socket)
  end

  defp handle_save_result({:ok, _note}, socket) do
    update_chapter(socket, socket.assigns.action, socket.assigns.current_verses)
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
         Routes.bible_path(
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
         Routes.bible_path(
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
