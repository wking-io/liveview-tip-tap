defmodule WithoutCeasingWeb.UniversalEvents do
  defmacro __using__(_) do
    quote do
      def handle_event(
            "toggle_menu",
            _value,
            socket
          ) do
        {:noreply,
         socket
         |> update(:current_panel, &toggle_panel(&1))
         |> assign(:current_verse, nil)}
      end

      defp toggle_panel(current) when current == "menu", do: nil
      defp toggle_panel(_), do: "menu"
    end
  end
end
