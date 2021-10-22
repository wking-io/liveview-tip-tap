defmodule WithoutCeasingWeb.BibleLive.Show do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

  import BibleComponents
  alias WithoutCeasing.Bible

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"book" => book, "chapter" => chapter}) do
    socket
    |> assign(
      page_title: "#{book} #{chapter}",
      book: book,
      chapter: Bible.get_chapter(book, chapter),
      current_verses: []
    )
  end

  def handle_event("unselect_verse", %{"verse" => verse}, socket) do
    socket =
      socket
      |> update(:current_verses, &Enum.filter(&1, fn id -> id != verse end))

    {:noreply,
     socket
     |> assign(:current_panel, maybe_close(socket.assigns.current_verses))}
  end

  # TODO: Check for shift key press and select all verses in between too
  def handle_event("select_verse", %{"verse" => verse}, socket) do
    {:noreply,
     socket
     |> assign(:current_panel, "details")
     |> update(:current_verses, &(&1 ++ [verse]))}
  end

  defp maybe_close([]), do: nil
  defp maybe_close(_), do: "details"
end
