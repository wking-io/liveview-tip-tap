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
    live_component(WithoutCeasingWeb.ModalComponent, modal_opts)
  end
end
