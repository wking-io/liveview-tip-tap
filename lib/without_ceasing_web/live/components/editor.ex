defmodule WithoutCeasingWeb.Components.Editor do
  use Phoenix.Component
  use Phoenix.HTML

  import WithoutCeasingWeb.LiveHelpers
  import WithoutCeasingWeb.Components.MenuButtons

  alias Phoenix.LiveView.JS

  def editor(assigns) do
    ~H"""
      <div id="editor-root" class="h-full flex flex-col" phx-hook="Editor" data-content={@content}>
        <div class="border-b border-gray-900 flex-1 flex flex-col overflow-y-auto overflow-x-hidden">
          <div class="border-b border-gray-900 flex divide-x divide-gray-900">
            <div class="flex">
              <.editor_button name="Heading 1" action={:heading_one} icon="M13 20h-2v-7H4v7H2V4h2v7h7V4h2v16zm8-12v12h-2v-9.796l-2 .536V8.67L19.5 8H21z" />
              <.editor_button name="Heading 2" action={:heading_two} icon="M4 4v7h7V4h2v16h-2v-7H4v7H2V4h2zm14.5 4c2.071 0 3.75 1.679 3.75 3.75 0 .857-.288 1.648-.772 2.28l-.148.18L18.034 18H22v2h-7v-1.556l4.82-5.546c.268-.307.43-.709.43-1.148 0-.966-.784-1.75-1.75-1.75-.918 0-1.671.707-1.744 1.606l-.006.144h-2C14.75 9.679 16.429 8 18.5 8z" />
              <.editor_button name="Heading 3" action={:heading_three} icon="M22 8l-.002 2-2.505 2.883c1.59.435 2.757 1.89 2.757 3.617 0 2.071-1.679 3.75-3.75 3.75-1.826 0-3.347-1.305-3.682-3.033l1.964-.382c.156.806.866 1.415 1.718 1.415.966 0 1.75-.784 1.75-1.75s-.784-1.75-1.75-1.75c-.286 0-.556.069-.794.19l-1.307-1.547L19.35 10H15V8h7zM4 4v7h7V4h2v16h-2v-7H4v7H2V4h2z" />
              <.editor_button name="Heading 4" action={:heading_four} icon="M13 20h-2v-7H4v7H2V4h2v7h7V4h2v16zm9-12v8h1.5v2H22v2h-2v-2h-5.5v-1.34l5-8.66H22zm-2 3.133L17.19 16H20v-4.867z" />
              <.editor_button name="Normal text" action={:paragraph} icon="M12 6v15h-2v-5a6 6 0 1 1 0-12h10v2h-3v15h-2V6h-3zm-2 0a4 4 0 1 0 0 8V6z" />
            </div>
            <div class="flex">
              <.editor_button name="Bold" action={:bold} icon="M8 11h4.5a2.5 2.5 0 1 0 0-5H8v5zm10 4.5a4.5 4.5 0 0 1-4.5 4.5H6V4h6.5a4.5 4.5 0 0 1 3.256 7.606A4.498 4.498 0 0 1 18 15.5zM8 13v5h5.5a2.5 2.5 0 1 0 0-5H8z" />
              <.editor_button name="Italic" action={:italic} icon="M15 20H7v-2h2.927l2.116-12H9V4h8v2h-2.927l-2.116 12H15z" />
              <.editor_button name="Strikethrough" action={:strike} icon="M17.154 14c.23.516.346 1.09.346 1.72 0 1.342-.524 2.392-1.571 3.147C14.88 19.622 13.433 20 11.586 20c-1.64 0-3.263-.381-4.87-1.144V16.6c1.52.877 3.075 1.316 4.666 1.316 2.551 0 3.83-.732 3.839-2.197a2.21 2.21 0 0 0-.648-1.603l-.12-.117H3v-2h18v2h-3.846zm-4.078-3H7.629a4.086 4.086 0 0 1-.481-.522C6.716 9.92 6.5 9.246 6.5 8.452c0-1.236.466-2.287 1.397-3.153C8.83 4.433 10.271 4 12.222 4c1.471 0 2.879.328 4.222.984v2.152c-1.2-.687-2.515-1.03-3.946-1.03-2.48 0-3.719.782-3.719 2.346 0 .42.218.786.654 1.099.436.313.974.562 1.613.75.62.18 1.297.414 2.03.699z" />
              <.editor_button name="Underline" action={:underline} icon="M8 3v9a4 4 0 1 0 8 0V3h2v9a6 6 0 1 1-12 0V3h2zM4 20h16v2H4v-2z" />
              <.editor_button name="Highlight" action={:highlight} icon="M15.243 4.515l-6.738 6.737-.707 2.121-1.04 1.041 2.828 2.829 1.04-1.041 2.122-.707 6.737-6.738-4.242-4.242zm6.364 3.535a1 1 0 0 1 0 1.414l-7.779 7.779-2.12.707-1.415 1.414a1 1 0 0 1-1.414 0l-4.243-4.243a1 1 0 0 1 0-1.414l1.414-1.414.707-2.121 7.779-7.779a1 1 0 0 1 1.414 0l5.657 5.657zm-6.364-.707l1.414 1.414-4.95 4.95-1.414-1.414 4.95-4.95zM4.283 16.89l2.828 2.829-1.414 1.414-4.243-1.414 2.828-2.829z" />
              <.editor_button name="Link" action={:link} icon="M18.364 15.536L16.95 14.12l1.414-1.414a5 5 0 1 0-7.071-7.071L9.879 7.05 8.464 5.636 9.88 4.222a7 7 0 0 1 9.9 9.9l-1.415 1.414zm-2.828 2.828l-1.415 1.414a7 7 0 0 1-9.9-9.9l1.415-1.414L7.05 9.88l-1.414 1.414a5 5 0 1 0 7.071 7.071l1.414-1.414 1.415 1.414zm-.708-10.607l1.415 1.415-7.071 7.07-1.415-1.414 7.071-7.07z" />
            </div>
            <div class="flex">
              <.editor_button name="Bullet List" action={:bullet_list} icon="M8 4h13v2H8V4zM4.5 6.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3zm0 7a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3zm0 6.9a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3zM8 11h13v2H8v-2zm0 7h13v2H8v-2z" />
              <.editor_button name="Ordered List" action={:ordered_list} icon="M8 4h13v2H8V4zM5 3v3h1v1H3V6h1V4H3V3h2zM3 14v-2.5h2V11H3v-1h3v2.5H4v.5h2v1H3zm2 5.5H3v-1h2V18H3v-1h3v4H3v-1h2v-.5zM8 11h13v2H8v-2zm0 7h13v2H8v-2z" />
            </div>
            <div>
              <.menu_button id="extras" class="h-full">
                <:label>Extras</:label>
                <div class="py-1" role="none">
                  <div>
                    <.dropdown_button name="Blockquote" action={:blockquote} icon="M4.583 17.321C3.553 16.227 3 15 3 13.011c0-3.5 2.457-6.637 6.03-8.188l.893 1.378c-3.335 1.804-3.987 4.145-4.247 5.621.537-.278 1.24-.375 1.929-.311 1.804.167 3.226 1.648 3.226 3.489a3.5 3.5 0 0 1-3.5 3.5c-1.073 0-2.099-.49-2.748-1.179zm10 0C13.553 16.227 13 15 13 13.011c0-3.5 2.457-6.637 6.03-8.188l.893 1.378c-3.335 1.804-3.987 4.145-4.247 5.621.537-.278 1.24-.375 1.929-.311 1.804.167 3.226 1.648 3.226 3.489a3.5 3.5 0 0 1-3.5 3.5c-1.073 0-2.099-.49-2.748-1.179z" />
                    <.dropdown_button name="Separator" action={:separator} icon="M2 11h2v2H2v-2zm4 0h12v2H6v-2zm14 0h2v2h-2v-2z" />
                  </div>
                  <div>
                    <h6
                      class="block px-4 py-2 text-xs font-semibold tracking-wider text-gray-700 uppercase"
                      role="none"
                    >Reference</h6>
                    <.dropdown_button name="Verse" action={:verse} icon="M3 18.5V5a3 3 0 0 1 3-3h14a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5A3.5 3.5 0 0 1 3 18.5zM19 20v-3H6.5a1.5 1.5 0 0 0 0 3H19zM10 4H6a1 1 0 0 0-1 1v10.337A3.486 3.486 0 0 1 6.5 15H19V4h-2v8l-3.5-2-3.5 2V4z" />
                    <.dropdown_button name="Entry" action={:entry} icon="M20.005 2C21.107 2 22 2.898 22 3.99v16.02c0 1.099-.893 1.99-1.995 1.99H4v-4H2v-2h2v-3H2v-2h2V8H2V6h2V2h16.005zM8 4H6v16h2V4zm12 0H10v16h10V4z" />
                    <.dropdown_button name="Resource" action={:resource} icon="M3 21a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h7.414l2 2H20a1 1 0 0 1 1 1v3h-2V7h-7.414l-2-2H4v11.998L5.5 11h17l-2.31 9.243a1 1 0 0 1-.97.757H3zm16.938-8H7.062l-1.5 6h12.876l1.5-6z" />
                  </div>
                </div>
              </.menu_button>
            </div>
          </div>

          <div id="editor-element" phx-ref="element" class="flex-1 overflow-auto"></div>
        </div>
        <.form
          let={f}
          for={@changeset}
          id="entry-form"
          phx-submit="save"
        >
          <%= hidden_input f, :content, ["phx-ref": "content"] %>

          <div class="flex justify-end">
            <%= render_slot(@cancel_button) %>
            <%= submit "Save Entry", phx_disable_with: "Saving...", class: "flex items-center justify-center py-4 px-8 border border-transparent text-sm font-medium text-white bg-gray-900 hover:bg-gray-700 focus:bg-gray-700 #{focus_classes()}" %>
          </div>
        </.form>
      </div>
    """
  end

  def editor_button(assigns) do
    ~H"""
    <button
      class={"h-full w-[38px] flex items-center justify-center hover:bg-gray-200 hover:text-gray-900 focus:bg-gray-200 #{focus_classes()}"}
      phx-click={editor_action(@action)}
      data-editor-action={action_name(@action)}
      aria-label={@name}
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        width="16"
        height="16"
        class="fill-current"
      >
        <path d={@icon} />
      </svg>
    </button>
    """
  end

  def dropdown_button(assigns) do
    ~H"""
    <button
      class={"flex items-center w-full text-left py-2 px-4 hover:bg-gray-100 hover:text-gray-900 focus:bg-gray-300 #{focus_classes()}"}
      phx-click={editor_action(@action)}
      data-editor-action={action_name(@action)}
    >
      <%= if assigns[:icon] do %>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          width="16"
          height="16"
          class="fill-current mr-2"
        >
          <path d={@icon} />
        </svg>
      <% end %>
      <span><%= @name %></span>
    </button>
    """
  end

  defp editor_action(:bold) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleBold"})
  end

  defp editor_action(:italic) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleItalic"})
  end

  defp editor_action(:heading_one) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleHeading", level: 1})
  end

  defp editor_action(:heading_two) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleHeading", level: 2})
  end

  defp editor_action(:heading_three) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleHeading", level: 3})
  end

  defp editor_action(:heading_four) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleHeading", level: 4})
  end

  defp editor_action(:paragraph) do
    JS.dispatch("editor-button:action", detail: %{action: "setParagraph"})
  end

  defp editor_action(:bullet_list) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleBulletList"})
  end

  defp editor_action(:ordered_list) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleOrderedList"})
  end

  defp editor_action(:blockquote) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleBlockquote"})
  end

  defp editor_action(:highlight) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleHighlight"})
  end

  defp editor_action(:underline) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleUnderline"})
  end

  defp editor_action(:strike) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleStrike"})
  end

  defp editor_action(:separator) do
    JS.dispatch("editor-button:action", detail: %{action: "setHorizontalRule"})
  end

  defp editor_action(:link) do
    JS.dispatch("editor-button:action", detail: %{action: "toggleLink"})
  end

  defp editor_action(:verse) do
    JS.dispatch("editor-button:action", detail: %{action: "linkVerse"})
  end

  defp editor_action(:entry) do
    JS.dispatch("editor-button:action", detail: %{action: "linkEntry"})
  end

  defp editor_action(:resource) do
    JS.dispatch("editor-button:action", detail: %{action: "linkResource"})
  end

  defp action_name(:heading_one), do: "heading-1"
  defp action_name(:heading_two), do: "heading-2"
  defp action_name(:heading_three), do: "heading-3"
  defp action_name(:heading_four), do: "heading-4"
  defp action_name(:bullet_list), do: "bulletList"
  defp action_name(:ordered_list), do: "orderedList"
  defp action_name(:separator), do: nil
  defp action_name(action), do: Atom.to_string(action)
end
