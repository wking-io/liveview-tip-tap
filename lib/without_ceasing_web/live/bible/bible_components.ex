defmodule BibleComponents do
  use Phoenix.Component

  # Optionally also bring the HTML helpers
  # use Phoenix.HTML

  def chapter(assigns) do
    ~H"""
      <%= for element <- @chapter.structure do %>
        <%= if is_list(element) do %>
          <p>
            <%= for verse <- element do %>
              <span class="verse" data-ref={"#{verse.id}"}><%= verse.text %></span>
            <% end %>
          </p>
        <% else %>
          <h3><%= element %></h3>
        <% end %>
      <% end %>
    """
  end
end
