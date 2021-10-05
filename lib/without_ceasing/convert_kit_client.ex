defmodule WithoutCeasing.ConvertKitClient do
  alias Finch.Response

  @base_url "https://api.convertkit.com/v3"

  def child_spec do
    {Finch,
     name: __MODULE__,
     pools: %{
       @base_url => [size: pool_size()]
     }}
  end

  def pool_size, do: 25

  def add_subscriber(email, form_id) do
    post("/forms/#{form_id}/subscribe", [{"email", email}])
    |> Finch.request(__MODULE__)
    |> handle_subscriber_response()
  end

  defp handle_subscriber_response({:ok, %Response{body: body, status: 200}}) do
    {:ok, Jason.decode!(body)}
  end

  defp handle_subscriber_response({:ok, %Response{body: body, status: status}}) do
    {:error, Jason.decode!(body), status}
  end

  defp handle_subscriber_response(error), do: error

  defp post(endpoint, query \\ [], headers \\ []) do
    url =
      @base_url <>
        endpoint <>
        "?" <>
        URI.encode_query(
          [{"api_key", Application.fetch_env!(:without_ceasing, :convertkit_api_key)}] ++ query
        )

    Finch.build(:post, url, headers)
  end
end
