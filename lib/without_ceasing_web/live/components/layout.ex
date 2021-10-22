defmodule WithoutCeasingWeb.Components.Layout do
  use Phoenix.Component
  require Logger

  # Optionally also bring the HTML helpers
  # use Phoenix.HTML

  def full(assigns) do
    ~H"""
      <div class="py-8 px-16 relative">
        <%= if info = live_flash(@flash, :info) do %>
        <p
          class="alert alert-info"
          role="alert"
          phx-click="lv:clear-flash"
          phx-value-key="info"
        >
          <%= info %>
        </p>
        <% end %>

        <%= if error = live_flash(@flash, :error) do %>
        <p
          class="alert alert-danger"
          role="alert"
          phx-click="lv:clear-flash"
          phx-value-key="error"
        >
          <%= error %>
        </p>
        <% end %>
        <%= render_block(@inner_block) %>
      </div>
    """
  end
end
