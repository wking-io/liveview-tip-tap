defmodule WithoutCeasing.BibleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WithoutCeasing.Bible` context.
  """

  @doc """
  Generate a pending_verse.
  """
  def pending_verse_fixture(attrs \\ %{}) do
    {:ok, pending_verse} =
      attrs
      |> Enum.into(%{
        book: "some book",
        chapter: 42,
        order: 42,
        text: "some text"
      })
      |> WithoutCeasing.Bible.create_pending_verse()

    pending_verse
  end
end
