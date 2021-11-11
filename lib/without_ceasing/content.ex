defmodule WithoutCeasing.Content do
  @moduledoc """
  The Content context.
  """

  require Logger

  import Ecto.Query, warn: false

  alias WithoutCeasing.Repo
  alias WithoutCeasing.Content.Resource
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

  alias WithoutCeasing.Content.Entry

  @doc """
  Returns the list of Entrys.

  ## Examples

      iex> list_Entrys()
      [%Entry{}, ...]

  """
  def list_entries do
    Repo.all(Entry)
  end

  @doc """
  Returns the list of Entries based on member and list of associated verses.

  ## Examples

      iex> list_Entrys()
      [%Entry{}, ...]

  """
  def get_entries(verses, %Member{} = member) do
    Entry
    |> join(:inner, [e], v in assoc(e, :verses))
    |> join(:inner, [e, v], m in assoc(e, :member))
    |> where([e, v, m], v.id in ^verses)
    |> where([e, v, m], m.id == ^member.id)
    |> preload([], [:verses])
    |> group_by([e], [e.id])
    |> Repo.all()
  end

  @doc """
  Returns the list of Entries based on member and list of associated verses.

  ## Examples

      iex> list_Entrys()
      [%Entry{}, ...]

  """
  def get_chapter_entries(book, chapter, %Member{} = member) do
    Entry
    |> join(:inner, [e], v in assoc(e, :verses))
    |> join(:inner, [e, v], m in assoc(e, :member))
    |> where([e, v, m], v.book == ^book)
    |> where([e, v, m], v.chapter == ^chapter)
    |> where([e, v, m], m.id == ^member.id)
    |> preload([], [:verses])
    |> group_by([e], [e.id])
    |> Repo.all()
  end

  @doc """
  Gets a single Entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

      iex> get_Entry!(123)
      %Entry{}

      iex> get_Entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entry!(id), do: Repo.get!(Entry, id) |> Repo.preload([:verses])

  @doc """
  Creates an Entry.

  ## Examples

      iex> create_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(attrs \\ %{}, verse_ids, user) when is_list(verse_ids) do
    verses =
      Verse
      |> where([verse], verse.id in ^verse_ids)
      |> Repo.all()

    attrs =
      attrs
      |> Map.update!("content", &Jason.decode!(&1))

    %Entry{}
    |> Entry.create_changeset(attrs, verses, user)
    |> Repo.insert()
  end

  @doc """
  Updates a Entry.

  ## Examples

      iex> update_entry(entry, %{field: new_value})
      {:ok, %Entry{}}

      iex> update_entry(entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entry(%Entry{} = entry, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Entry.

  ## Examples

      iex> delete_entry(entry)
      {:ok, %Entry{}}

      iex> delete_entry(entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Entry changes.

  ## Examples

      iex> change_entry(entry)
      %Ecto.Changeset{data: %Entry{}}

  """
  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    Entry.changeset(entry, attrs)
  end
end
