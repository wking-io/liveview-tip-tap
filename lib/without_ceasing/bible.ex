defmodule WithoutCeasing.Bible do
  @moduledoc """
  The Bible context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset

  alias WithoutCeasing.Repo
  alias WithoutCeasing.Bible.{Verse, VerseRevision, Book, Editor, VerseRevision, Data}
  require Logger

  @doc """
  Returns the list of verses.

  ## Examples

      iex> list_verses()
      [%Verse{}, ...]

  """
  def list_verses do
    Repo.all(Verse)
  end

  @doc """
  Gets a single verse.

  Raises `Ecto.NoResultsError` if the Verse does not exist.

  ## Examples

      iex> get_verse!(123)
      %Verse{}

      iex> get_verse!(456)
      ** (Ecto.NoResultsError)

  """
  def get_verse!(id), do: Repo.get!(Verse, id)

  @doc """
  Creates a verse.

  ## Examples

      iex> create_verse(%{field: value})
      {:ok, %Verse{}}

      iex> create_verse(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_verse(attrs \\ %{}) do
    %Verse{}
    |> Verse.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a verse.

  ## Examples

      iex> update_verse(verse, %{field: new_value})
      {:ok, %Verse{}}

      iex> update_verse(verse, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_verse(%Verse{} = verse, attrs) do
    verse
    |> Verse.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a verse.

  ## Examples

      iex> delete_verse(verse)
      {:ok, %Verse{}}

      iex> delete_verse(verse)
      {:error, %Ecto.Changeset{}}

  """
  def delete_verse(%Verse{} = verse) do
    Repo.delete(verse)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking verse changes.

  ## Examples

      iex> change_verse(verse)
      %Ecto.Changeset{data: %Verse{}}

  """
  def change_verse(%VerseRevision{} = verse, attrs \\ %{}) do
    VerseRevision.changeset(verse, attrs)
  end

  alias WithoutCeasing.Bible.Translation

  @doc """
  Returns the list of translations.

  ## Examples

      iex> list_translations()
      [%Translation{}, ...]

  """
  def list_translations do
    Repo.all(Translation)
  end

  @doc """
  Gets a single translation.

  Raises `Ecto.NoResultsError` if the Translation does not exist.

  ## Examples

      iex> get_translation!(123)
      %Translation{}

      iex> get_translation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_translation!(id), do: Repo.get!(Translation, id)

  @doc """
  Gets a single translation by slug key

  Raises `Ecto.NoResultsError` if the Translation does not exist.

  ## Examples

      iex> get_translation_by_slug!(esv)
      %Translation{}

      iex> get_translation_by_slug!(abc)
      ** (Ecto.NoResultsError)

  """
  def get_translation_by_slug!(slug),
    do: Repo.get_by!(Translation, slug: slug)

  @doc """
  Creates a translation.

  ## Examples

      iex> create_translation(%{field: value})
      {:ok, %Translation{}}

      iex> create_translation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_translation(attrs \\ %{}) do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:translation, Translation.changeset(%Translation{}, attrs))

    Enum.reduce(
      Book.get_verse_list(),
      multi,
      &Ecto.Multi.insert(
        &2,
        {:verse, "#{&1.book}-#{&1.chapter}-#{&1.verse}"},
        fn %{translation: translation} ->
          Ecto.build_assoc(translation, :verses, &1)
        end
      )
    )
    |> Repo.transaction()
  end

  @doc """
  Updates a translation.

  ## Examples

      iex> update_translation(translation, %{field: new_value})
      {:ok, %Translation{}}

      iex> update_translation(translation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_translation(%Translation{} = translation, attrs) do
    translation
    |> Translation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a translation.

  ## Examples

      iex> delete_translation(translation)
      {:ok, %Translation{}}

      iex> delete_translation(translation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_translation(%Translation{} = translation) do
    Repo.delete(translation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking translation changes.

  ## Examples

      iex> change_translation(translation)
      %Ecto.Changeset{data: %Translation{}}

  """
  def change_translation(%Translation{} = translation, attrs \\ %{}) do
    Translation.changeset(translation, attrs)
  end

  def get_editor(translation, book, chapter) do
    verses = get_verses(translation, book, chapter)

    editor =
      Changeset.change(%Editor{
        book: book,
        chapter: chapter,
        translation: translation,
        verses: Enum.map(verses, &get_verse_text/1)
      })

    {verses, editor}
  end

  defp get_verse_text(%Verse{verse_revisions: []}), do: ""
  defp get_verse_text(%Verse{verse_revisions: [%VerseRevision{text: text} | _]}), do: text

  def with_most_recent_version(query) do
    query
    |> join(:left, [verse: v], r in assoc(v, :verse_revisions), as: :revision)
    |> preload([revision: r], verse_revisions: r)
  end

  def get_verses(translation, book, chapter) do
    from(v in Verse, as: :verse)
    |> join(:left, [v], t in Translation, on: t.id == v.translation_id, as: :translation)
    |> with_most_recent_version()
    |> where([v], v.book == ^book)
    |> where([v], v.chapter == ^chapter)
    |> where([_, t], t.slug == ^translation)
    |> Repo.all()
  end

  def save_verse_revision(%VerseRevision{status: :approved} = _revision, attrs) do
    attrs
    |> Map.put(:status, :approved)
    |> create_pending_verse()
  end

  def save_verse_revision(%VerseRevision{status: :pending} = revision, attrs) do
    update_pending_verse(revision, attrs)
  end

  # defp empty_verse(book, chapter) do
  #   %Verse{
  #     book: book,
  #     chapter: chapter
  #   }
  # end

  def get_book_summaries() do
    Book.get_book_summaries()
  end

  @doc """
  Returns the list of pending_verses.

  ## Examples

      iex> list_pending_verses()
      [%VerseRevision{}, ...]

  """
  def list_pending_verses do
    Repo.all(VerseRevision)
  end

  @doc """
  Gets a single pending_verse.

  Raises `Ecto.NoResultsError` if the Pending verse does not exist.

  ## Examples

      iex> get_pending_verse!(123)
      %VerseRevision{}

      iex> get_pending_verse!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pending_verse!(id), do: Repo.get!(VerseRevision, id)

  @doc """
  Creates a pending_verse.

  ## Examples

      iex> create_pending_verse(%{field: value})
      {:ok, %VerseRevision{}}

      iex> create_pending_verse(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pending_verse(attrs \\ %{}) do
    %VerseRevision{}
    |> VerseRevision.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pending_verse.

  ## Examples

      iex> update_pending_verse(pending_verse, %{field: new_value})
      {:ok, %VerseRevision{}}

      iex> update_pending_verse(pending_verse, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pending_verse(%VerseRevision{} = pending_verse, attrs) do
    pending_verse
    |> VerseRevision.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pending_verse.

  ## Examples

      iex> delete_pending_verse(pending_verse)
      {:ok, %VerseRevision{}}

      iex> delete_pending_verse(pending_verse)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pending_verse(%VerseRevision{} = pending_verse) do
    Repo.delete(pending_verse)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pending_verse changes.

  ## Examples

      iex> change_pending_verse(pending_verse)
      %Ecto.Changeset{data: %VerseRevision{}}

  """
  def change_pending_verse(%VerseRevision{} = pending_verse, attrs \\ %{}) do
    VerseRevision.changeset(pending_verse, attrs)
  end

  def get_chapter(book, chapter), do: Data.get_chapter(book, chapter)
end
