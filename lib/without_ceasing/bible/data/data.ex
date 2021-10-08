defmodule Bible.Data do
  alias Bible.Data.John

  def get_chapter("john", "1") do
    John.One.get()
  end
end
