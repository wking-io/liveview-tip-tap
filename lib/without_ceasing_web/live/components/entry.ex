defmodule WithoutCeasingWeb.Components.Entry do
  use Phoenix.Component

  def entry(assigns) do
    ~H"""
      <div x-data={"render(#{Jason.encode!(@entry.content)})"} id={"entry-#{@entry.id}"}>
        <div phx-update="ignore" x-ref="content" class="prose p-4">Loading...</div>
      </div>
    """
  end
end
