defmodule WithoutCeasingWeb.Components.Bible do
  use Phoenix.Component

  # Optionally also bring the HTML helpers
  # use Phoenix.HTML

  def chapter(assigns) do
    ~H"""
      <%= for element <- @chapter.structure do %>
        <%= if is_list(element) do %>
          <p class="paragraph font-serif leading-relaxed">
            <%= for verse <- element do %>
              <span class={"verse pl-4 relative #{maybe_highlight(verse.id in @chapter.highlights, is_current_verse(@current_verses, verse.id))}"} phx-click={verse_action(verse.id, @current_verses)} phx-value-verse={"#{verse.id}"} phx-value-action={@action}>
              <%= unless is_nil(verse.number) do %>
                <span class="absolute text-[10px] top-0 left-0 w-4 flex justify-end pr-1"><%= verse.number %></span>
              <% end %>
              <%= for part <- verse.text do %>
                <.verse content={part} />
              <% end %>
            </span>
            <% end %>
          </p>
        <% else %>
          <h3 class="font-bold mt-6 mb-3 font-serif"><%= element %></h3>
        <% end %>
      <% end %>
    """
  end

  defp is_current_verse([], _), do: false
  defp is_current_verse(current, instance), do: Enum.member?(current, to_string(instance))

  defp verse_action(_current, []), do: "select_verse"

  defp verse_action(current, [verse | _rest = []]) do
    if verse == to_string(current) do
      "unselect_all"
    else
      "select_verse"
    end
  end

  defp verse_action(current, verses) do
    if is_current_verse(verses, current) do
      "unselect_verse"
    else
      "select_verse"
    end
  end

  defp maybe_highlight(_, true), do: "bg-brand-400 bg-opacity-40"
  defp maybe_highlight(true, _), do: "bg-brand-400 bg-opacity-20"
  defp maybe_highlight(_, _), do: ""

  defp verse(%{content: {:normal, text}} = assigns) do
    ~H"""
      <%= text %>
    """
  end

  defp verse(%{content: {:poetry, lines}} = assigns) do
    ~H"""
      <span class="inline-flex flex-col py-6">
      <%= for line <- lines do %>
        <span><%= line %></span>
      <% end %>
      </span>
    """
  end
end
