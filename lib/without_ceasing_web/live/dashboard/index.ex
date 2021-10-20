defmodule WithoutCeasingWeb.DashboardLive.Index do
  use WithoutCeasingWeb, :live_view
  use WithoutCeasingWeb.UniversalEvents

  alias WithoutCeasing.Newsletter
  alias WithoutCeasing.NewsletterForm

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:newsletter_form, %NewsletterForm{})
     |> assign(:changeset, Newsletter.change())
     |> assign(:subscribed, false)}
  end

  @impl true
  def handle_event(
        "validate",
        %{"newsletter_form" => newsletter_params},
        socket
      ) do
    changeset =
      Newsletter.change(newsletter_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"newsletter_form" => newsletter_params}, socket) do
    save_newsletter(socket, socket.assigns.live_action, newsletter_params)
  end

  defp save_newsletter(socket, :index, newsletter_params) do
    case Newsletter.subscribe(newsletter_params) do
      {:ok, _changeset} ->
        {:noreply,
         socket
         |> assign(:subscribed, true)
         |> push_event("subscribed", %{subscribed: true})}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)}
    end
  end
end
