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
        <div class="relative col-span-6 h-full overflow-y-auto overflow-x-hidden px-16 py-8 border-r border-gray-900">
          <%= render_slot(@bible) %>
        </div>
        <%= if @show_actions do %>
          <aside class="fixed left-0 top-16 mt-12 w-12 bg-gray-50 border border-gray-900 animate-enter-left-full">
            <button phx-click="highlight_verses">
              Highlight
            </button>
            <button phx-click="unselect_all">
              Clear Selection
            </button>
            <button phx-click="">
              Copy
            </button>
            <button phx-click="">
              Share
            </button>
          </aside>
        <% end %>
        <div class="col-span-6 h-full overflow-y-auto overflow-x-hidden">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    """
  end
end
