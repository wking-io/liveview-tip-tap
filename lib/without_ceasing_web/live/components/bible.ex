defmodule WithoutCeasingWeb.Components.Bible do
  use Phoenix.Component

  # Optionally also bring the HTML helpers
  # use Phoenix.HTML

  def chapter(assigns) do
    ~H"""
      <%= for element <- @chapter.structure do %>
        <%= if is_list(element) do %>
          <p class="paragraph">
            <%= for verse <- element do %>
              <span class={"verse pl-4 relative cursor-pointer #{maybe_highlight(@current_verses, verse.id)}"} phx-click={if is_current_verse(@current_verses, verse.id), do: "unselect_verse", else: "select_verse"} phx-value-verse={"#{verse.id}"}>
              <%= unless is_nil(verse.number) do %>
                <span class="absolute text-[10px] top-0 left-0 w-4 flex justify-end pr-1"><%= verse.number %></span>
              <% end %>
              <%= for part <- verse.text do %>
                <%= render_verse(part) %>
              <% end %>
            </span>
            <% end %>
          </p>
        <% else %>
          <h3 class="font-bold mt-6 mb-3"><%= element %></h3>
        <% end %>
      <% end %>
    """
  end

  defp is_current_verse([], _), do: false
  defp is_current_verse(current, instance), do: Enum.member?(current, to_string(instance))

  defp maybe_highlight(current, instance),
    do: if(is_current_verse(current, instance), do: "bg-brand-200 bg-opacity-40", else: "")

  defp render_verse({:normal, text}), do: text
  defp render_verse({:poetry, text}), do: text
end
