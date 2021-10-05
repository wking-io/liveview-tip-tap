defmodule WithoutCeasing.TestFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WithoutCeasing.Test` context.
  """

  @doc """
  Generate a highlight.
  """
  def highlight_fixture(attrs \\ %{}) do
    {:ok, highlight} =
      attrs
      |> Enum.into(%{
        verse: "some verse"
      })
      |> WithoutCeasing.Test.create_highlight()

    highlight
  end
end
