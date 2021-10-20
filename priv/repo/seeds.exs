# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WithoutCeasing.Repo.insert!(%WithoutCeasing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias WithoutCeasing.Repo
alias WithoutCeasing.Bible.Book.List
alias WithoutCeasing.Bible.Verse
alias Mix.Tasks.GenerateChapter

List.map_by_verse(fn {book, chapter, verse} ->
  Repo.insert!(%Verse{
    id: GenerateChapter.get_verse_id(book, chapter, verse),
    book: book,
    chapter: chapter,
    verse: verse
  })
end)
