defmodule WithoutCeasing.Bible do
  @moduledoc """
  The Bible context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset

  alias WithoutCeasing.Repo
  alias WithoutCeasing.Bible.Verse
  alias WithoutCeasing.Bible.Book
  alias WithoutCeasing.Bible.Data
  require Logger

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

  def get_book_summaries() do
    Book.get_book_summaries()
  end

  def get_chapter(book, chapter), do: Data.get_chapter(book, chapter)

  def prettify_verses(verses) do
    verses
    |> Enum.reduce([], &verse_grouper/2)
    |> Enum.reduce([], &group_stringify/2)
  end

  defp verse_grouper(verse, []), do: [{verse}]

  defp verse_grouper(verse, [{first, last} | rest] = groups),
    do: if(last + 1 == verse, do: [{first, verse}, rest], else: [{verse} | groups])

  defp verse_grouper(verse, [{first} | rest] = groups),
    do: if(first + 1 == verse, do: [{first, verse}, rest], else: [{verse} | groups])

  defp group_stringify({first, last}, string) do
    %{book: book, chapter: chapter, verse: first_verse} =
      first
      |> Integer.digits()
      |> get_verse_data()

    %{verse: last_verse} =
      last
      |> Integer.digits()
      |> get_verse_data()

    ["#{book} #{chapter}:#{first_verse}-#{last_verse}"]
  end

  defp group_stringify({first}, acc) do
    %{book: book, chapter: chapter, verse: verse} =
      first
      |> Integer.digits()
      |> get_verse_data()

    ["#{book} #{chapter}:#{verse}" | acc]
  end

  defp get_verse_data([b1, c1, c2, c3, v1, v2, v3]) do
    %{
      book: Data.get_book_name(b1),
      chapter: Integer.undigits([c1, c2, c3]),
      verse: Integer.undigits([v1, v2, v3])
    }
  end

  defp get_verse_data([b1, b2, c1, c2, c3, v1, v2, v3]) do
    book =
      [b1, b2]
      |> Integer.undigits()
      |> Data.get_book_name()

    %{
      book: book,
      chapter: Integer.undigits([c1, c2, c3]),
      verse: Integer.undigits([v1, v2, v3])
    }
  end
end
