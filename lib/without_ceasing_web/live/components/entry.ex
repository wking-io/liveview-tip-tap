defmodule WithoutCeasingWeb.Components.Note do
  use Phoenix.Component

  def note(assigns) do
    ~H"""
      <div x-data={"render(#{Jason.encode!(@note.content)})"} id={"note-#{@note.id}"}>
        <div phx-update="ignore" x-ref="content" class="prose p-4">Loading...</div>
      </div>
    """
  end
end
