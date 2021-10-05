defmodule WithoutCeasingWeb.ResourceLive.FormComponent do
  use WithoutCeasingWeb, :live_component

  alias WithoutCeasing.Content

  @impl true
  def update(%{resource: resource} = assigns, socket) do
    changeset = Content.change_resource(resource)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"resource" => resource_params}, socket) do
    changeset =
      socket.assigns.resource
      |> Content.change_resource(resource_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"resource" => resource_params}, socket) do
    save_resource(socket, socket.assigns.action, resource_params)
  end

  defp save_resource(socket, :edit, resource_params) do
    case Content.update_resource(socket.assigns.resource, resource_params) do
      {:ok, _resource} ->
        {:noreply,
         socket
         |> put_flash(:info, "Resource updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_resource(socket, :new, resource_params) do
    case Content.create_resource(resource_params) do
      {:ok, _resource} ->
        {:noreply,
         socket
         |> put_flash(:info, "Resource created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
