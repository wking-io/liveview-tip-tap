defmodule WithoutCeasingWeb.HomeLive do
  use WithoutCeasingWeb, :live_view

  alias WithoutCeasing.Newsletter
  alias WithoutCeasing.Newsletter.Form

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:newsletter_form, %Newsletter.Form{})
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

  def render(assigns) do
    ~H"""
    <section class="flex items-center min-h-screen">
      <div class="flex-1 flex justify-center">
        <div class="space-y-8">
          <p class="flex items-center text-xl font-bold gap-3">
            <svg
              height="32"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 124 74"
              class="fill-current h-6"
              aria-hidden
            >
              <path
                d="M103.74,16.63H54.35a6.73,6.73,0,0,1-5.85-3.37L44.25,5.91A11.82,11.82,0,0,0,34,0H20.26A20.25,20.25,0,0,0,0,20.25V37.12A20.26,20.26,0,0,0,20.26,57.37H69.65a6.73,6.73,0,0,1,5.85,3.37l4.25,7.35A11.82,11.82,0,0,0,90,74h13.75A20.25,20.25,0,0,0,124,53.75V36.88A20.26,20.26,0,0,0,103.74,16.63Zm3.38,37.12a3.38,3.38,0,0,1-3.38,3.38h-26a6.77,6.77,0,0,1-5.85-3.38L67.64,46.4a11.83,11.83,0,0,0-10.23-5.91H20.26a3.38,3.38,0,0,1-3.38-3.37V20.25a3.38,3.38,0,0,1,3.38-3.38h26a6.77,6.77,0,0,1,5.85,3.38l4.25,7.35a11.83,11.83,0,0,0,10.23,5.91h37.15a3.38,3.38,0,0,1,3.38,3.37Z"
              />
            </svg>
            <span>Without Ceasing</span>
          </p>
          <div class="lg:max-w-3xl space-y-4">
            <h1 class="font-extrabold text-4xl md:text-5xl mt-6 md:mt-2"><span class="bg-success-400 inline-block">Saveable</span>, <span class="bg-warning-400 inline-block">Searchable</span>, <span class="bg-error-400 inline-block">Shareable</span> Bible Notes and Resources</h1>
            <p class="text-gray-500">Supercharge your Bible study with access to notes, sermons, images, devotionals, and more from past you and people you know.</p>
          </div>
          <div>
            <%= if (@subscribed) do %>
              <p class="mt-10 max-w-xl w-full text-center text-center sm:text-left text-sm px-6 py-3 border border-transparent text-white bg-brand-200 shadow-box-300-sm" id="early-access-success" phx-hook="EarlyAccessEvent">
                Got it! You should have an email to confirm the subscription now. If you don't reach out at hi@fabledlabs.com.
              </p>
            <% else %>
              <.form let={f} for={@changeset} url="#" id="subscription-form" phx_change="validate" phx_submit="save" class="mt-10 flex flex-col sm:flex-row max-w-xl">
                <div class="flex-1 relative">
                  <%= label f, :email, class: "sr-only" %>
                  <%= email_input f, :email, class: "text-center sm:text-left appearance-none w-full px-4 py-3 border border-gray-900 text-base bg-white #{focus_classes()}", placeholder: "Enter your email" %>
                  <%= error_tag f, :email, class: "sm:absolute top-full left-0 w-full text-sm bg-error-500 text-white py-2 px-4" %>
                </div>
                <div
                  class="flex-shrink-0 w-full flex rounded-md shadow-sm sm:mt-0 sm:ml-3 sm:w-auto sm:inline-flex"
                >
                  <%= submit "Get Early Access", phx_disable_with: "Saving...", class: "w-full text-center flex items-center justify-center px-6 py-3 border border-transparent text-base font-semibold text-white bg-gray-900 #{focus_classes()}" %>
                </div>
              </.form>
            <% end %>
          </div>
        </div>
      </div>
      <div class="w-1/3">
        <img class="border-t-4 border-l-4 border-b-4 border-gray-900 rounded-l-3xl" src={Routes.static_path(@socket, "/images/app-preview.png")} alt="App Preview" />
      </div>
    </section>
    """
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
