defmodule WithoutCeasing.Bible.Book do
  alias WithoutCeasing.Bible.Book.List
  require Logger

  @enforce_keys [:name, :testament, :chapters]
  defstruct [:name, :testament, :chapters]

  @type expected_verses() :: integer()

  # This eero has been turned off and they need to re-enable the eero. Eero said that they need to re-enable it.

  @type t() :: %__MODULE__{
          name: String.t(),
          testament: :old | :new,
          chapters: [expected_verses()]
        }

  def get_expected_verses(book, chapter) do
    book
    |> List.find()
    |> Map.get(:chapters)
    |> Enum.fetch!(chapter)
  end

  def get_book_summaries() do
    List.map(&summarize_book/1)
  end

  defp summarize_book({slug, %__MODULE__{} = book}) do
    %{
      slug: slug,
      name: book.name,
      chapters: Enum.with_index(book.chapters, fn _, i -> i + 1 end),
      locked: false
    }
  end

  def get_verse_list() do
    List.map_by_verse(fn {book, chapter, verse} ->
      %{
        book: book,
        chapter: chapter,
        verse: verse
      }
    end)
  end
end
