defmodule WithoutCeasingWeb.Components.Layout do
  use Phoenix.Component

  import WithoutCeasingWeb.Helpers

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
        <div class="relative col-span-6 h-full overflow-y-auto overflow-x-hidden px-20 py-12 border-r border-gray-900">
          <%= render_slot(@bible) %>
        </div>
        <%= if @show_actions do %>
          <aside class="fixed left-0 top-16 mt-12 w-12 bg-white border border-gray-900 animate-enter-left-full">
            <.action_button action="highlight_verses" name="Highlight" icon="M15.243 4.515l-6.738 6.737-.707 2.121-1.04 1.041 2.828 2.829 1.04-1.041 2.122-.707 6.737-6.738-4.242-4.242zm6.364 3.535a1 1 0 0 1 0 1.414l-7.779 7.779-2.12.707-1.415 1.414a1 1 0 0 1-1.414 0l-4.243-4.243a1 1 0 0 1 0-1.414l1.414-1.414.707-2.121 7.779-7.779a1 1 0 0 1 1.414 0l5.657 5.657zm-6.364-.707l1.414 1.414-4.95 4.95-1.414-1.414 4.95-4.95zM4.283 16.89l2.828 2.829-1.414 1.414-4.243-1.414 2.828-2.829z" />
            <.action_button action="unselect_all" name="Unselect" icon="M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm0-2a8 8 0 1 0 0-16 8 8 0 0 0 0 16zm0-9.414l2.828-2.829 1.415 1.415L13.414 12l2.829 2.828-1.415 1.415L12 13.414l-2.828 2.829-1.415-1.415L10.586 12 7.757 9.172l1.415-1.415L12 10.586z" />
            <.action_button action="copy_verses" name="Copy" icon="M7 6V3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1h-3v3c0 .552-.45 1-1.007 1H4.007A1.001 1.001 0 0 1 3 21l.003-14c0-.552.45-1 1.007-1H7zM5.003 8L5 20h10V8H5.003zM9 6h8v10h2V4H9v2z" />
            <.action_button action="share_verses" name="Share" icon="M10 3v2H5v14h14v-5h2v6a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h6zm7.707 4.707L12 13.414 10.586 12l5.707-5.707L13 3h8v8l-3.293-3.293z" />
          </aside>
        <% end %>
        <div class="col-span-6 h-full overflow-y-auto overflow-x-hidden">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    """
  end

  defp action_button(assigns) do
    ~H"""
    <button
      class={"h-12 w-full flex items-center justify-center hover:bg-gray-200 hover:text-gray-900 focus:bg-white #{focus_classes()}"}
      phx-click={@action}
      aria-label={@name}
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        width="20"
        height="20"
        class="fill-current"
      >
        <path d={@icon} />
      </svg>
    </button>
    """
  end
end
