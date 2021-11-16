defmodule WithoutCeasing.Content do
  @moduledoc """
  The Content context.
  """

  require Logger

  import Ecto.Query, warn: false

  alias WithoutCeasing.Repo
  alias WithoutCeasing.Content.Resource
  alias WithoutCeasing.Bible
  alias WithoutCeasing.Bible.Verse
  alias WithoutCeasing.Identity.Member

  @doc """
  Returns the list of resources.

  ## Examples

      iex> list_resources()
      [%Resource{}, ...]

  """
  def list_resources do
    Repo.all(Resource)
  end

  @doc """
  Gets a single resource.

  Raises `Ecto.NoResultsError` if the Resource does not exist.

  ## Examples

      iex> get_resource!(123)
      %Resource{}

      iex> get_resource!(456)
      ** (Ecto.NoResultsError)

  """
  def get_resource!(id), do: Repo.get!(Resource, id)

  @doc """
  Creates a resource.

  ## Examples

      iex> create_resource(%{field: value})
      {:ok, %Resource{}}

      iex> create_resource(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_resource(attrs \\ %{}) do
    %Resource{}
    |> Resource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a resource.

  ## Examples

      iex> update_resource(resource, %{field: new_value})
      {:ok, %Resource{}}

      iex> update_resource(resource, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_resource(%Resource{} = resource, attrs) do
    resource
    |> Resource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a resource.

  ## Examples

      iex> delete_resource(resource)
      {:ok, %Resource{}}

      iex> delete_resource(resource)
      {:error, %Ecto.Changeset{}}

  """
  def delete_resource(%Resource{} = resource) do
    Repo.delete(resource)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking resource changes.

  ## Examples

      iex> change_resource(resource)
      %Ecto.Changeset{data: %Resource{}}

  """
  def change_resource(%Resource{} = resource, attrs \\ %{}) do
    Resource.changeset(resource, attrs)
  end

  alias WithoutCeasing.Content.Note

  @doc """
  Returns the list of Notes.

  ## Examples

      iex> list_Notes()
      [%Note{}, ...]

  """
  def list_notes do
    Repo.all(Note)
  end

  @doc """
  Returns the list of Notes based on member and list of associated verses.

  ## Examples

      iex> list_Notes()
      [%Note{}, ...]

  """
  def get_notes(verses, %Member{} = member) do
    Note
    |> join(:inner, [h], v in assoc(h, :verses))
    |> join(:inner, [h, v], m in assoc(h, :member))
    |> where([h, v, m], v.id in ^verses)
    |> where([h, v, m], m.id == ^member.id)
    |> preload([], [:verses])
    |> group_by([h], [h.id])
    |> Repo.all()
  end

  @doc """
  Returns the list of Notes based on member and list of associated verses.

  ## Examples

      iex> list_Notes()
      [%Note{}, ...]

  """
  def get_chapter_notes(book, chapter, %Member{} = member) do
    Note
    |> join(:inner, [h], v in assoc(h, :verses))
    |> join(:inner, [h, v], m in assoc(h, :member))
    |> where([h, v, m], v.book == ^book)
    |> where([h, v, m], v.chapter == ^chapter)
    |> where([h, v, m], m.id == ^member.id)
    |> preload([], [:verses])
    |> group_by([h], [h.id])
    |> Repo.all()
  end

  @doc """
  Gets a single Note.

  Raises `Ecto.NoResultsError` if the Note does not exist.

  ## Examples

      iex> get_Note!(123)
      %Note{}

      iex> get_Note!(456)
      ** (Ecto.NoResultsError)

  """
  def get_note!(id), do: Repo.get!(Note, id) |> Repo.preload([:verses])

  @doc """
  Creates an Note.

  ## Examples

      iex> create_note(%{field: value})
      {:ok, %Note{}}

      iex> create_note(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_note(attrs \\ %{}) do
    attrs =
      attrs
      |> Map.update!("content", &Jason.decode!(&1))
      |> Map.update!(:verses, &Bible.get_verses/1)

    %Note{}
    |> Note.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Note.

  ## Examples

      iex> update_note(note, %{field: new_value})
      {:ok, %Note{}}

      iex> update_note(note, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_note(%Note{} = note, attrs) do
    attrs =
      attrs
      |> Map.update!("content", &Jason.decode!(&1))
      |> Map.update!(:verses, &Bible.get_verses/1)

    note
    |> Note.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Note.

  ## Examples

      iex> delete_note(note)
      {:ok, %Note{}}

      iex> delete_note(note)
      {:error, %Ecto.Changeset{}}

  """
  def delete_note(%Note{} = note) do
    Repo.delete(note)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Note changes.

  ## Examples

      iex> change_note(note)
      %Ecto.Changeset{data: %Note{}}

  """
  def change_note(%Note{} = note, attrs \\ %{}) do
    Note.changeset(note, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Note changes.

  ## Examples

      iex> change_note(note)
      %Ecto.Changeset{data: %Note{}}

  """
  def change_note() do
    Note.changeset(%Note{}, %{})
  end
end
