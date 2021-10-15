defmodule WithoutCeasing.Bible.Data do
  alias WithoutCeasing.Bible.Data.John
  require Logger

  def get_chapter("john", "12") do
    John.Twelve.get()
  end
end
