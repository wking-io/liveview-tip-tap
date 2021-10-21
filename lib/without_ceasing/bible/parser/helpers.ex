defmodule WithoutCeasing.Bible.Parser.Helpers do
  import NimbleParsec
  require Logger

  @books_with_numbers [
    {:samuel_1, "1 Samuel"},
    {:samuel_2, "2 Samuel"},
    {:kings_1, "1 Kings"},
    {:kings_2, "2 Kings"},
    {:chronicles_1, "1 Chronicles"},
    {:chronicles_2, "2 Chronicles"},
    {:corinthians_1, "1 Corinthians"},
    {:corinthians_2, "2 Corinthians"},
    {:thessalonians_1, "1 Thessalonians"},
    {:thessalonians_2, "2 Thessalonians"},
    {:timothy_1, "1 Timothy"},
    {:timothy_2, "2 Timothy"},
    {:peter_1, "1 Peter"},
    {:peter_2, "2 Peter"},
    {:john_1, "1 John"},
    {:john_2, "2 John"},
    {:john_3, "3 John"}
  ]

  @books_without_numbers [
    {:genesis, "Genesis"},
    {:exodus, "Exodus"},
    {:leviticus, "Leviticus"},
    {:numbers, "Numbers"},
    {:deuteronomy, "Deuteronomy"},
    {:joshua, "Joshua"},
    {:judges, "Judges"},
    {:ruth, "Ruth"},
    {:ezra, "Ezra"},
    {:nehemiah, "Nehemiah"},
    {:esther, "Esther"},
    {:job, "Job"},
    {:psalms, "Psalms"},
    {:proverbs, "Proverbs"},
    {:ecclesiastes, "Ecclesiastes"},
    {:song_of_solomon, "Song Of Solomon"},
    {:isaiah, "Isaiah"},
    {:jeremiah, "Jeremiah"},
    {:lamentations, "Lamentations"},
    {:ezekiel, "Ezekiel"},
    {:daniel, "Daniel"},
    {:hosea, "Hosea"},
    {:joel, "Joel"},
    {:amos, "Amos"},
    {:obadiah, "Obadiah"},
    {:jonah, "Jonah"},
    {:micah, "Micah"},
    {:nahum, "Nahum"},
    {:habakkuk, "Habakkuk"},
    {:zephaniah, "Zephaniah"},
    {:haggai, "Haggai"},
    {:zechariah, "Zechariah"},
    {:malachi, "Malachi"},
    {:matthew, "Matthew"},
    {:mark, "Mark"},
    {:luke, "Luke"},
    {:john, "John"},
    {:acts, "Acts"},
    {:romans, "Romans"},
    {:galatians, "Galatians"},
    {:ephesians, "Ephesians"},
    {:philippians, "Philippians"},
    {:colossians, "Colossians"},
    {:titus, "Titus"},
    {:philemon, "Philemon"},
    {:hebrews, "Hebrews"},
    {:james, "James"},
    {:jude, "Jude"},
    {:revelation, "Revelation"}
  ]

  @books [
    {:genesis, "Genesis"},
    {:exodus, "Exodus"},
    {:leviticus, "Leviticus"},
    {:numbers, "Numbers"},
    {:deuteronomy, "Deuteronomy"},
    {:joshua, "Joshua"},
    {:judges, "Judges"},
    {:ruth, "Ruth"},
    {:samuel_1, "1 Samuel"},
    {:samuel_2, "2 Samuel"},
    {:kings_1, "1 Kings"},
    {:kings_2, "2 Kings"},
    {:chronicles_1, "1 Chronicles"},
    {:chronicles_2, "2 Chronicles"},
    {:ezra, "Ezra"},
    {:nehemiah, "Nehemiah"},
    {:esther, "Esther"},
    {:job, "Job"},
    {:psalms, "Psalms"},
    {:proverbs, "Proverbs"},
    {:ecclesiastes, "Ecclesiastes"},
    {:song_of_solomon, "Song Of Solomon"},
    {:isaiah, "Isaiah"},
    {:jeremiah, "Jeremiah"},
    {:lamentations, "Lamentations"},
    {:ezekiel, "Ezekiel"},
    {:daniel, "Daniel"},
    {:hosea, "Hosea"},
    {:joel, "Joel"},
    {:amos, "Amos"},
    {:obadiah, "Obadiah"},
    {:jonah, "Jonah"},
    {:micah, "Micah"},
    {:nahum, "Nahum"},
    {:habakkuk, "Habakkuk"},
    {:zephaniah, "Zephaniah"},
    {:haggai, "Haggai"},
    {:zechariah, "Zechariah"},
    {:malachi, "Malachi"},
    {:matthew, "Matthew"},
    {:mark, "Mark"},
    {:luke, "Luke"},
    {:john, "John"},
    {:acts, "Acts"},
    {:romans, "Romans"},
    {:corinthians_1, "1 Corinthians"},
    {:corinthians_2, "2 Corinthians"},
    {:galatians, "Galatians"},
    {:ephesians, "Ephesians"},
    {:philippians, "Philippians"},
    {:colossians, "Colossians"},
    {:thessalonians_1, "1 Thessalonians"},
    {:thessalonians_2, "2 Thessalonians"},
    {:timothy_1, "1 Timothy"},
    {:timothy_2, "2 Timothy"},
    {:titus, "Titus"},
    {:philemon, "Philemon"},
    {:hebrews, "Hebrews"},
    {:james, "James"},
    {:peter_1, "1 Peter"},
    {:peter_2, "2 Peter"},
    {:john_1, "1 John"},
    {:john_2, "2 John"},
    {:john_3, "3 John"},
    {:jude, "Jude"},
    {:revelation, "Revelation"}
  ]

  #############################################################################
  ## GENERIC NIMBLE_PARSEC PARSERS

  def blankspace(), do: ignore(ascii_string([?\s], min: 1))

  #############################################################################
  ## Book Parser

  def book_number(), do: integer(1)

  def suggest([number, value]) do
    List.foldr(@books, [], fn {book, name}, acc ->
      name
      |> String.downcase()
      |> String.contains?("#{to_string(number)} #{String.downcase(value)}")
      |> if(do: [book | acc], else: acc)
    end)
  end

  def suggest([number]) when is_integer(number) do
    List.foldr(@books_with_numbers, [], fn {book, name}, acc ->
      if(String.contains?(name, to_string(number)), do: [book | acc], else: acc)
    end)
  end

  def suggest([input]) do
    List.foldr(@books_without_numbers, [], fn {book, name}, acc ->
      if(String.contains?(name, input), do: [book | acc], else: acc)
    end)
  end

  def book() do
    optional(book_number())
    |> optional(blankspace())
    |> optional(ascii_string([?a..?z, ?A..?Z], min: 1))
    |> reduce({__MODULE__, :suggest, []})
  end
end
