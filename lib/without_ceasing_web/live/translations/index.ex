defmodule WithoutCeasingWeb.TranslationLive.Index do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

  alias WithoutCeasing.Bible
  alias WithoutCeasing.Bible.Translation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :translations, list_translations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"translation" => translation}) do
    socket
    |> assign(:page_title, "Edit Translation")
    |> assign(:translation, Bible.get_translation_by_slug!(translation))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Translation")
    |> assign(:translation, %Translation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Translations")
    |> assign(:translation, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    translation = Bible.get_translation!(id)
    {:ok, _} = Bible.delete_translation(translation)

    {:noreply, assign(socket, :translations, list_translations())}
  end

  defp list_translations do
    Bible.list_translations()
  end
end
