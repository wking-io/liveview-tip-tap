defmodule WithoutCeasingWeb.ResourceLive.Index do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

  alias WithoutCeasing.Content
  alias WithoutCeasing.Content.Resource

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :resources, list_resources())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Resource")
    |> assign(:resource, Content.get_resource!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Resource")
    |> assign(:resource, %Resource{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Resources")
    |> assign(:resource, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    resource = Content.get_resource!(id)
    {:ok, _} = Content.delete_resource(resource)

    {:noreply, assign(socket, :resources, list_resources())}
  end

  defp list_resources do
    Content.list_resources()
  end
end
