defmodule WithoutCeasingWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `WithoutCeasingWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, WithoutCeasingWeb.VerseLive.FormComponent,
        id: @verse.id || :new,
        action: @live_action,
        verse: @verse,
        return_to: Routes.verse_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(WithoutCeasingWeb.Component.Modal, modal_opts)
  end

  def normalize_slug(string) do
    cond do
      String.contains?(string, "-1") ->
        String.replace(string, "-1", "one")

      String.contains?(string, "-2") ->
        String.replace(string, "-2", "two")

      String.contains?(string, "-3") ->
        String.replace(string, "-3", "three")

      true ->
        string
    end
  end

  def focus_classes(:offset),
    do: "rounded focus:outline-none focus:ring-offset-2 focus:ring-1 focus:ring-gray-900"

  def focus_classes(:within),
    do: "rounded focus-within:outline-none focus-within:ring-1 focus-within:ring-gray-900"

  def focus_classes(), do: "rounded focus:outline-none focus:ring-1 focus:ring-gray-900"
end
