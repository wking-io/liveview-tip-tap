defmodule WithoutCeasingWeb.BibleLive.Show do
  use WithoutCeasingWeb, :live_view

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
      chapter: Bible.get_chapter(book, chapter)
    )
  end
end
