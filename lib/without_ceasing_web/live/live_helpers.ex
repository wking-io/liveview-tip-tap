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

  def get_workspace_classes("menu"), do: "md:ml-64 md:pl-8"
  def get_workspace_classes("details"), do: "lg:mr-[500px] xl:mr-[700px]"
  def get_workspace_classes(_), do: ""

  def get_sidenav_classes("menu"), do: "translate-x-full"
  def get_sidenav_classes(_), do: "translate-x-0"

  def get_topnav_classes("menu"), do: "left-56 right-0"
  def get_topnav_classes("details"), do: "left-0 right-0 lg:mr-[500px] xl:mr-[700px]"
  def get_topnav_classes(_), do: "left-0 right-0"

  def get_details_classes("details"), do: "-translate-x-full"
  def get_details_classes(_), do: "translate-x-0"
end
