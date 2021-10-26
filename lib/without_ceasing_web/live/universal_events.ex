defmodule WithoutCeasingWeb.UniversalEvents do
  defmacro __using__(_) do
    quote do
      def handle_event(
            "close_details",
            _value,
            socket
          ) do
        {:noreply,
         socket
         |> assign(:current_panel, nil)
         |> assign(:current_verses, [])}
      end

      def handle_event(
            "toggle_menu",
            _value,
            socket
          ) do
        {:noreply,
         socket
         |> update(:current_panel, &toggle_panel(&1))}
      end

      defp toggle_panel(current) when current == "menu", do: nil
      defp toggle_panel(_), do: "menu"
    end
  end
end
