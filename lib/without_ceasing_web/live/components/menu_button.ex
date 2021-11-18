defmodule WithoutCeasingWeb.Components.MenuButtons do
  use Phoenix.Component

  import WithoutCeasingWeb.LiveHelpers

  alias Phoenix.LiveView.JS

  def menu_button(assigns) do
    ~H"""
      <div class={"relative text-left #{@class}"} phx-click-away={hide(@id)}>
        <button
          aria-controls={"menu-content-#{@id}"}
          aria-haspopup="true"
          class={"flex items-center justify-between w-full h-full border border-transparent bg-white px-4 py-2 text-sm font-medium hover:bg-white #{focus_classes()}"}
          id={"menu-button-#{@id}"}
          type="button"
          phx-click={toggle(@id)}
          aria-expanded="false"
        >
          <%= render_slot(@label) %>
          <svg
            class="-mr-1 ml-2 h-5 w-5"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden="true"
          >
            <path
              fill-rule="evenodd"
              d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
              clip-rule="evenodd"
            />
          </svg>
        </button>
        <div
          aria-labledby={"menu-button-#{@id}"}
          class={"hidden origin-top-left absolute -left-px mt-2 shadow-lg bg-white border border-gray-900 z-50 max-h-96 overflow-y-auto overflow-x-hidden #{focus_classes()}"}
          id={"menu-content-#{@id}"}
          role="menu"
        >
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    """
  end

  def menu_icon_button(assigns) do
    ~H"""
      <div class={"relative text-left #{@class}"} phx-click-away={hide(@id)}>
        <button
          aria-controls={"menu-content-#{@id}"}
          aria-haspopup="true"
          class={"flex items-center justify-center w-full h-full border border-transparent p-2 text-sm font-medium text-gray-700 hover:bg-white #{focus_classes()}"}
          id={"menu-button-#{@id}"}
          type="button"
          phx-click={toggle(@id)}
          aria-expanded="false"
        >
          <%= render_slot(@label) %>
        </button>
        <div
          aria-labledby={"menu-button-#{@id}"}
          class={"hidden origin-top-right absolute right-0 mt-2 shadow-lg bg-white border border-gray-900 z-50 max-h-60 overflow-y-auto overflow-x-hidden #{focus_classes()}"}
          id={"menu-content-#{@id}"}
          role="menu"
        >
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    """
  end

  defp toggle(id) do
    JS.toggle(
      to: "#menu-content-#{id}",
      in:
        {"transition ease-out duration-100", "opacity-0 transform scale-95",
         "opacity-100 transform scale-100"},
      out:
        {"transition ease-in duration-75", "opacity-100 transform scale-100",
         "opacity-0 transform scale-95"}
    )
    |> JS.dispatch("menu-button:toggle", detail: %{id: id})
  end

  defp hide(id) do
    JS.hide(
      to: "#menu-content-#{id}",
      transition:
        {"transition ease-in duration-75", "opacity-100 transform scale-100",
         "opacity-0 transform scale-95"}
    )
    |> JS.dispatch("menu-button:hide", detail: %{id: id})
  end
end
