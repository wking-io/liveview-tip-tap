defmodule Mix.Tasks.GenerateChapter do
  use Mix.Task
  require Logger

  @requirements ["app.start"]

  def run([book, chapter_text, chapter_num]) do
    app_dir = File.cwd!()

    new_file_path =
      Path.join([
        app_dir,
        "lib",
        "without_ceasing",
        "bible",
        "data",
        "#{book}",
        "#{chapter_text}.ex"
      ])

    capitalized_book = String.capitalize(book)

    {chapter_num, _} = Integer.parse(chapter_num)

    structure =
      fetch(book, chapter_num)
      |> parse(book_num(book), chapter_num)

    File.write(
      new_file_path,
      """
      defmodule WithoutCeasing.Bible.Data.#{capitalized_book}.#{String.capitalize(chapter_text)} do
        def get() do
          %{
            book: "#{capitalized_book}",
            chapter: #{chapter_num},
            structure: #{inspect(structure, limit: :infinity)}
          }
        end
      end
      """,
      [:write]
    )
  end

  def fetch(book, chapter) do
    # EsvClient.fetch_chapter(book, chapter)
    HTTPoison.start()

    url =
      "https://api.esv.org/v3/passage/text?q=#{book}#{chapter}&include-passage-references=false&include-footnotes=false&include-footnote-body=false&include-short-copyright=false&include-heading-horizontal-lines=true"

    headers = [
      Authorization: "Token #{Application.fetch_env!(:without_ceasing, :esv_api_key)}"
    ]

    %HTTPoison.Response{body: body} = HTTPoison.get!(url, headers, follow_redirect: true)

    body
    |> Jason.decode!()
    |> Map.fetch!("passages")
    |> Enum.fetch!(0)
  end

  defp parse(passage, book, chapter) do
    passage
    |> String.split("_______________________________________________________\n", trim: true)
    |> Enum.flat_map(fn chunk ->
      [section_heading | paragraphs] =
        chunk
        |> String.split("\n\n", trim: true)

      [section_heading] ++ Enum.flat_map(paragraphs, &parse_verses(&1, book, chapter))
    end)
  end

  defp parse_verses(verses, book_num, chapter_num) do
    verses
    |> String.replace("  ", "")
    |> String.split(~r/\[[[:digit:]]+\]/, trim: true, include_captures: true)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [num, text] ->
      parsed_text =
        text
        |> String.trim()
        |> String.replace(["“", "”", "‘", "’"], &replace_fancy/1)

      number = num |> String.replace(~r([\[\]]), "") |> String.to_integer()

      id = String.to_integer("#{book_num}#{to_id(chapter_num)}#{to_id(number)}")

      %{
        id: id,
        text: parsed_text,
        number: number
      }
    end)
  end

  @spec book_num(String.t()) :: integer()
  defp book_num("genesis"), do: 1
  defp book_num("exodus"), do: 2
  defp book_num("leviticus"), do: 3
  defp book_num("numbers"), do: 4
  defp book_num("deuteronomy"), do: 5
  defp book_num("joshua"), do: 6
  defp book_num("judges"), do: 7
  defp book_num("ruth"), do: 8
  defp book_num("samuel-1"), do: 9
  defp book_num("samuel-2"), do: 10
  defp book_num("kings-1"), do: 11
  defp book_num("kings-2"), do: 12
  defp book_num("chronicles-1"), do: 13
  defp book_num("chronicles-2"), do: 14
  defp book_num("ezra"), do: 15
  defp book_num("nehemiah"), do: 16
  defp book_num("esther"), do: 17
  defp book_num("job"), do: 18
  defp book_num("psalms"), do: 19
  defp book_num("proverbs"), do: 20
  defp book_num("ecclesiastes"), do: 21
  defp book_num("song-of-solomon"), do: 22
  defp book_num("isaiah"), do: 23
  defp book_num("jeremiah"), do: 24
  defp book_num("lamentations"), do: 25
  defp book_num("ezekiel"), do: 26
  defp book_num("daniel"), do: 27
  defp book_num("hosea"), do: 28
  defp book_num("joel"), do: 29
  defp book_num("amos"), do: 30
  defp book_num("obadiah"), do: 31
  defp book_num("jonah"), do: 32
  defp book_num("micah"), do: 33
  defp book_num("nahum"), do: 34
  defp book_num("habakkuk"), do: 35
  defp book_num("zephaniah"), do: 36
  defp book_num("haggai"), do: 37
  defp book_num("zechariah"), do: 38
  defp book_num("malachi"), do: 39
  defp book_num("matthew"), do: 40
  defp book_num("mark"), do: 41
  defp book_num("luke"), do: 42
  defp book_num("john"), do: 43
  defp book_num("acts"), do: 44
  defp book_num("romans"), do: 45
  defp book_num("corinthians-1"), do: 46
  defp book_num("corinthians-2"), do: 47
  defp book_num("galatians"), do: 48
  defp book_num("ephesians"), do: 49
  defp book_num("philippians"), do: 50
  defp book_num("colossians"), do: 51
  defp book_num("thessalonians-1"), do: 52
  defp book_num("thessalonians-2"), do: 53
  defp book_num("timothy-1"), do: 54
  defp book_num("timothy-2"), do: 55
  defp book_num("titus"), do: 56
  defp book_num("philemon"), do: 57
  defp book_num("hebrews"), do: 58
  defp book_num("james"), do: 59
  defp book_num("peter-1"), do: 60
  defp book_num("peter-2"), do: 61
  defp book_num("john-1"), do: 62
  defp book_num("john-2"), do: 63
  defp book_num("john-3"), do: 64
  defp book_num("jude"), do: 65
  defp book_num("revelation"), do: 66

  @spec to_id(integer()) :: String.t()
  defp to_id(0), do: raise(ArgumentError, message: "cannot be 0.")
  defp to_id(num) when num < 10, do: "00#{num}"
  defp to_id(num) when num < 100, do: "0#{num}"
  defp to_id(num), do: "#{num}"

  @spec replace_fancy(String.t()) :: String.t()
  defp replace_fancy("“"), do: "\""
  defp replace_fancy("”"), do: "\""
  defp replace_fancy("‘"), do: "'"
  defp replace_fancy("’"), do: "'"
end
