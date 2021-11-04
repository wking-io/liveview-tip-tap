defmodule WithoutCeasingWeb.Components.Layout do
  use Phoenix.Component
  require Logger

  # Optionally also bring the HTML helpers
  # use Phoenix.HTML

  def full(assigns) do
    ~H"""
      <div class={"py-8 relative #{assigns[:class]}"}>
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

  def with_bible(assigns) do
    ~H"""
      <div class="grid grid-cols-12 h-full">
        <div class="col-span-5 h-full overflow-y-auto overflow-x-hidden px-12 py-8 border-r border-gray-900">
          <%= render_slot(@bible) %>
        </div>
        <div class="col-span-7 h-full overflow-y-auto overflow-x-hidden">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    """
  end
end
