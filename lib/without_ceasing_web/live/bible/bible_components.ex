defmodule BibleComponents do
  use Phoenix.Component
  require Logger

  # Optionally also bring the HTML helpers
  # use Phoenix.HTML

  def chapter(assigns) do
    ~H"""
      <%= for element <- @chapter.structure do %>
        <%= if is_list(element) do %>
          <p class="paragraph">
            <%= for verse <- element do %>
              <.verse verse={verse}/>
            <% end %>
          </p>
        <% else %>
          <h3 class="font-bold mt-6 mb-3"><%= element %></h3>
        <% end %>
      <% end %>
    """
  end

  def verse(assigns) do
    ~H"""
      <span class="verse pl-4 relative cursor-pointer" data-ref={"#{@verse.id}"}>
        <%= unless is_nil(@verse.number) do %>
          <span class="absolute text-[10px] top-0 left-0 w-4 flex justify-end pr-1"><%= @verse.number %></span>
        <% end %>
        <%= for part <- @verse.text do %>
          <%= render_verse(part) %>
        <% end %>
      </span>
    """
  end

  defp render_verse({:normal, text}), do: text
  defp render_verse({:poetry, text}), do: text
end
