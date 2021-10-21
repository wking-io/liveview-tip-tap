defmodule WithoutCeasing.Bible.Parser do
  import NimbleParsec
  alias WithoutCeasing.Bible.Parser.Helpers

  @enforce_keys [:raw]
  defstruct [:parsed, :suggestions, :error] ++ @enforce_keys

  @type book ::
          :genesis
          | :exodus
          | :leviticus
          | :numbers
          | :deuteronomy
          | :joshua
          | :judges
          | :ruth
          | :samuel_1
          | :samuel_2
          | :kings_1
          | :kings_2
          | :chronicles_1
          | :chronicles_2
          | :ezra
          | :nehemiah
          | :esther
          | :job
          | :psalms
          | :proverbs
          | :ecclesiastes
          | :song_of_solomon
          | :isaiah
          | :jeremiah
          | :lamentations
          | :ezekiel
          | :daniel
          | :hosea
          | :joel
          | :amos
          | :obadiah
          | :jonah
          | :micah
          | :nahum
          | :habakkuk
          | :zephaniah
          | :haggai
          | :zechariah
          | :malachi
          | :matthew
          | :mark
          | :luke
          | :john
          | :acts
          | :romans
          | :corinthians_1
          | :corinthians_2
          | :galatians
          | :ephesians
          | :philippians
          | :colossians
          | :thessalonians_1
          | :thessalonians_2
          | :timothy_1
          | :timothy_2
          | :titus
          | :philemon
          | :hebrews
          | :james
          | :peter_1
          | :peter_2
          | :john_1
          | :john_2
          | :john_3
          | :jude
          | :revelation

  @type error :: %{
          message: String.t()
        }

  @type t :: %__MODULE__{
          error: error,
          parsed: [integer()],
          raw: String.t(),
          suggestions: [book]
        }

  @type line_info :: {non_neg_integer, non_neg_integer}
  @type parsec_retval :: {[String.t()], t}

  #############################################################################
  ## INITIALIZATION
  ##
  ## used to initialize nimble_parsec with a struct instead of a generic map.
  ## should be prepended to most things which are turned into parsecs.  You
  ## can also pass information into a parsec function to preseed the context.

  initialize = post_traverse(empty(), :initializer)

  @spec initializer(String.t(), [String.t()], t, line_info, non_neg_integer) ::
          parsec_retval

  defp initializer(_, _, context, _, _), do: {[], struct(__MODULE__, context)}

  # test harness

  if Mix.env() == :test do
    defparsec(:parser_initializer, initialize)
  end

  defparsec(:book, Helpers.book())

  #############################################################################
  ## API

  def parse(input) do
    book(input)
  end
end
