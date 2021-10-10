defmodule WithoutCeasing.EsvClient do
  alias Finch.Response

  require Logger

  @base_url "https://api.esv.org/v3"

  def child_spec do
    {Finch,
     name: __MODULE__,
     pools: %{
       @base_url => [size: pool_size()]
     }}
  end

  def pool_size, do: 25

  def fetch_chapter(book, chapter) do
    get("/passage/text?q=#{book}#{chapter}")
    |> Finch.request(__MODULE__)
    |> handle_chapter_response!()
    |> Map.fetch!("passages")
    |> Enum.fetch!(0)
  end

  defp handle_chapter_response!({:ok, %Response{body: body, status: 200} = response}) do
    Logger.debug("Response: #{inspect(response)}")
    Jason.decode!(body)
  end

  defp handle_chapter_response!({:ok, %Response{body: body} = response}) do
    Logger.debug("Response: #{inspect(response)}")
    Jason.decode!(body)
  end

  defp handle_chapter_response!(error), do: error

  defp get(endpoint) do
    url =
      @base_url <>
        endpoint

    build =
      Finch.build(
        :get,
        url,
        [{"Authorization", "Token #{Application.fetch_env!(:without_ceasing, :esv_api_key)}"}]
      )

    Logger.debug(build)

    build
  end
end
