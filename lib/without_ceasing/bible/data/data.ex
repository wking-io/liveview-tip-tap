defmodule WithoutCeasing.Bible.Data do
  alias Bible.Data.John
  require Logger

  def get_chapter("john", "1") do
    John.One.get()
  end
end
