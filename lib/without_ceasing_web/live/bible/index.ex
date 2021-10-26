defmodule WithoutCeasingWeb.BibleLive.Index do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

  import WithoutCeasingWeb.Components.{Layout}

  alias WithoutCeasing.Bible

  @impl true
  def mount(_params, _session, socket) do
    books = Bible.get_book_summaries()
    [old, new] = Enum.chunk_by(books, & &1.testament)

    {:ok,
     socket
     |> assign(:books, books)
     |> assign(:old, old)
     |> assign(:new, new)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"book" => book}) do
    socket
    |> assign(
      page_title: "#{book}",
      current_book: find_book(socket.assigns.books, book)
    )
  end

  defp apply_action(socket, :index, _) do
    socket
    |> assign(
      page_title: "Table Of Contents",
      current_book: nil
    )
  end

  defp find_book(books, book), do: Enum.find(books, &(&1.slug == book))
end
