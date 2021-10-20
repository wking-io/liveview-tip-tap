defmodule WithoutCeasing.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WithoutCeasing.Content` context.
  """

  @doc """
  Generate a resource.
  """
  def resource_fixture(attrs \\ %{}) do
    {:ok, resource} =
      attrs
      |> Enum.into(%{
        description: "some description",
        status: :pending,
        title: "some title"
      })
      |> WithoutCeasing.Content.create_resource()

    resource
  end

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        content: %{}
      })
      |> WithoutCeasing.Content.create_entry()

    entry
  end
end
