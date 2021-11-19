defmodule WithoutCeasingWeb.Components.TableOfContents do
  use WithoutCeasingWeb, :live_component

  require Logger

  alias WithoutCeasing.Bible

  def update(_assigns, socket) do
    books = Bible.get_book_summaries()
    [old, new] = Enum.chunk_by(books, & &1.testament)

    {:ok,
     socket
     |> assign(:books, books)
     |> assign(:old, old)
     |> assign(:new, new)
     |> assign(:current_book, nil)}
  end

  def handle_event("select_book", %{"book" => book} = values, socket) do
    {:noreply,
     socket
     |> assign(:current_book, find_book(socket.assigns.books, book))}
  end

  def handle_event("unselect_book", _, socket) do
    {:noreply,
     socket
     |> assign(:current_book, nil)}
  end

  defp find_book(books, book), do: Enum.find(books, &(&1.slug == book))

  def render(assigns) do
    ~H"""
    <div>
      <%= unless @current_book do %>
        <h2 class="font-lg font-bold">Old Testament</h2>
        <ul role="list" class="grid grid-cols-books gap-x-4 gap-y-2 mt-4">
          <%= for book <- @old do %>
            <li class="col-span-1">
                <button class={"text-sm p-1 hover:bg-gray-300 #{focus_classes()}"} phx-click="select_book" phx-value-book={book.slug} phx-target={@myself}><%= book.name %></button>
            </li>
          <% end %>
        </ul>
        <h2 class="font-lg font-bold mt-8">New Testament</h2>
        <ul role="list" class="grid grid-cols-books gap-x-4 gap-y-2 mt-4">
          <%= for book <- @new do %>
            <li class="col-span-1">
                <button class={"text-sm p-1 hover:bg-gray-300 #{focus_classes()}"} phx-click="select_book" phx-value-book={book.slug} phx-target={@myself}><%= book.name %></button>
            </li>
          <% end %>
        </ul>
      <% else %>
        <button class={"text-sm inline-flex items-center text-gray-700 hover:bg-gray-300 #{focus_classes()}"} phx-click="unselect_book" phx-target={@myself}>
          <svg xmlns="http://www.w3.org/2000/svg" class="h-auto w-5 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16l-4-4m0 0l4-4m-4 4h18" />
          </svg>
          <span>back to book selection</span>
        </button>
        <h2 class="font-lg font-bold mt-4"><%= @current_book.name %></h2>
        <ul class="grid grid-cols-chapters gap-x-4 gap-y-2 mt-4 -mx-1">
          <%= for chapter <- @current_book.chapters do %>
            <li class="w-8 h-8 flex items-center justify-start">
              <%= live_redirect to: Routes.bible_path(@socket, :index, @current_book.slug, chapter), class: "text-sm leading-none p-2 hover:bg-gray-300 #{focus_classes()}" do %>
                <span class="sr-only">Chapter</span> <%= chapter %>
              <% end %>
            </li>
          <% end %>
        </ul>
      <% end %>
    </div>
    """
  end
end
