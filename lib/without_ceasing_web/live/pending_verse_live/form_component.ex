defmodule WithoutCeasingWeb.VerseRevisionLive.FormComponent do
  use WithoutCeasingWeb, :live_component

  alias WithoutCeasing.Bible

  @impl true
  def update(%{pending_verse: pending_verse} = assigns, socket) do
    changeset = Bible.change_pending_verse(pending_verse)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"pending_verse" => pending_verse_params}, socket) do
    changeset =
      socket.assigns.pending_verse
      |> Bible.change_pending_verse(pending_verse_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"pending_verse" => pending_verse_params}, socket) do
    save_pending_verse(socket, socket.assigns.action, pending_verse_params)
  end

  defp save_pending_verse(socket, :edit, pending_verse_params) do
    case Bible.update_pending_verse(socket.assigns.pending_verse, pending_verse_params) do
      {:ok, _pending_verse} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pending verse updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_pending_verse(socket, :new, pending_verse_params) do
    case Bible.create_pending_verse(pending_verse_params) do
      {:ok, _pending_verse} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pending verse created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
