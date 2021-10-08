defmodule WithoutCeasing.Bible.Data do
  alias Bible.Data.John
  require Logger

  def get_chapter("john", "1") do
    John.One.get()
  end

  def parse(book, chapter) do
    response =
      "_______________________________________________________\nThe Wedding at Cana\n\n  [1] On the third day there was a wedding at Cana in Galilee, and the mother of Jesus was there. [2] Jesus also was invited to the wedding with his disciples. [3] When the wine ran out, the mother of Jesus said to him, “They have no wine.” [4] And Jesus said to her, “Woman, what does this have to do with me? My hour has not yet come.” [5] His mother said to the servants, “Do whatever he tells you.”\n\n  [6] Now there were six stone water jars there for the Jewish rites of purification, each holding twenty or thirty gallons. [7] Jesus said to the servants, “Fill the jars with water.” And they filled them up to the brim. [8] And he said to them, “Now draw some out and take it to the master of the feast.” So they took it. [9] When the master of the feast tasted the water now become wine, and did not know where it came from (though the servants who had drawn the water knew), the master of the feast called the bridegroom [10] and said to him, “Everyone serves the good wine first, and when people have drunk freely, then the poor wine. But you have kept the good wine until now.” [11] This, the first of his signs, Jesus did at Cana in Galilee, and manifested his glory. And his disciples believed in him.\n\n  [12] After this he went down to Capernaum, with his mother and his brothers and his disciples, and they stayed there for a few days.\n\n_______________________________________________________\nJesus Cleanses the Temple\n\n  [13] The Passover of the Jews was at hand, and Jesus went up to Jerusalem. [14] In the temple he found those who were selling oxen and sheep and pigeons, and the money-changers sitting there. [15] And making a whip of cords, he drove them all out of the temple, with the sheep and oxen. And he poured out the coins of the money-changers and overturned their tables. [16] And he told those who sold the pigeons, “Take these things away; do not make my Father’s house a house of trade.” [17] His disciples remembered that it was written, “Zeal for your house will consume me.”\n\n  [18] So the Jews said to him, “What sign do you show us for doing these things?” [19] Jesus answered them, “Destroy this temple, and in three days I will raise it up.” [20] The Jews then said, “It has taken forty-six years to build this temple, and will you raise it up in three days?” [21] But he was speaking about the temple of his body. [22] When therefore he was raised from the dead, his disciples remembered that he had said this, and they believed the Scripture and the word that Jesus had spoken.\n\n_______________________________________________________\nJesus Knows What Is in Man\n\n  [23] Now when he was in Jerusalem at the Passover Feast, many believed in his name when they saw the signs that he was doing. [24] But Jesus on his part did not entrust himself to them, because he knew all people [25] and needed no one to bear witness about man, for he himself knew what was in man.\n\n"

    result =
      response
      |> String.split("_______________________________________________________\n", trim: true)
      |> Enum.flat_map(fn chunk ->
        [section_heading | paragraphs] =
          chunk
          |> String.split("\n\n", trim: true)

        parsed_paragraphs = Enum.flat_map(paragraphs, &parse_verses(&1, 43, 1))

        Logger.info("parsed paragraphs: #{inspect(parsed_paragraphs)}")
        [section_heading] ++ parsed_paragraphs
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
