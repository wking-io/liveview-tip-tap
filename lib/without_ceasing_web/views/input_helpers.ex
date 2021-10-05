defmodule WithoutCeasingWeb.InputHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML
  require Logger

  def array_input_values(form, field), do: Phoenix.HTML.Form.input_value(form, field) || [""]

  @doc """
  Generates tags for array field type in changeset.
  """
  def editor_fields(form, field) do
    values = Phoenix.HTML.Form.input_value(form, field) || [""]

    values
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      form_elements(form, field, value, index)
    end)
  end

  defp form_elements(form, field, value, index) do
    id = Phoenix.HTML.Form.input_id(form, field)
    new_id = id <> "_#{index}"

    label_opts = [
      id: new_id <> "-label",
      form: new_id,
      class: "w-4 text-gray-400 font-bold text-sm mr-4 absolute top-0 right-full"
    ]

    input_opts = [
      name: new_field_name(form, field),
      value: value,
      id: new_id,
      class:
        "flex-1 border-none py-2 px-3 bg-gray-100 rounded focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-200 focus:ring-brand-200",
      placeholder: "Enter verse text here..."
    ]

    content_tag :li, class: "w-full flex items-start relative" do
      [
        apply(Phoenix.HTML.Form, :textarea, [form, field, input_opts]),
        apply(Phoenix.HTML.Form, :label, [form, field, "#{index + 1}", label_opts])
      ]
    end
  end

  defp new_field_name(form, field) do
    Phoenix.HTML.Form.input_name(form, field) <> "[]"
  end
end
