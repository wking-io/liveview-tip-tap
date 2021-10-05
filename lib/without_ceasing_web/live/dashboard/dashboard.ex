defmodule WithoutCeasingWeb.DashboardLive.Index do
  use WithoutCeasingWeb, :live_view

  alias WithoutCeasing.Bible

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:books, Bible.get_book_summaries())
     |> assign(:locked, false)
     |> assign(:translation, "esv")}
  end
end
