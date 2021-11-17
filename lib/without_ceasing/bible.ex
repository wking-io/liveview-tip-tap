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
  alias WithoutCeasing.Identity.Member
  require Logger

  def get_verses(verse_ids) when is_list(verse_ids) do
    Verse
    |> where([verse], verse.id in ^verse_ids)
    |> Repo.all()
  end

  def get_book_summaries() do
    Book.get_book_summaries()
  end

  def get_chapter(book, chapter, member) do
    Data.get_chapter(book, chapter)
    |> Map.put(:highlights, get_highlighted_verses(book, chapter, member))
  end

  defp get_highlighted_verses(book, chapter, member) do
    Member
    |> join(:inner, [m], h in assoc(m, :highlights))
    |> where([m, h], h.book == ^book)
    |> where([m, h], h.chapter == ^chapter)
    |> where([m], m.id == ^member.id)
    |> select([m, h], h.id)
    |> Repo.all()
  end

  def highlight_verses(verse_ids, member) do
    verses = get_verses(verse_ids)

    loaded =
      member
      |> Repo.preload(:highlights)

    loaded
    |> Changeset.change()
    |> Changeset.put_assoc(:highlights, verses ++ loaded.highlights)
    |> Repo.update()
  end

  def prettify_verses(verses) do
    verses
    |> Enum.reduce([], &verse_grouper/2)
    |> Enum.reduce([], &group_stringify/2)
  end

  defp verse_grouper(verse, []), do: [{verse}]

  defp verse_grouper(verse, [{first, last} | rest] = groups) do
    if last + 1 == verse do
      [{first, verse} | rest]
    else
      [{verse} | groups]
    end
  end

  defp verse_grouper(verse, [{first} | rest] = groups) do
    if first + 1 == verse do
      [{first, verse} | rest]
    else
      [{verse} | groups]
    end
  end

  defp group_stringify({first, last}, acc) do
    %{book: book, chapter: chapter, verse: first_verse} =
      first
      |> Integer.digits()
      |> get_verse_data()

    %{verse: last_verse} =
      last
      |> Integer.digits()
      |> get_verse_data()

    ["#{book} #{chapter}:#{first_verse}-#{last_verse}" | acc]
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
