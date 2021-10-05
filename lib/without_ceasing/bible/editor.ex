defmodule WithoutCeasing.Bible.Editor do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :book, :string
    field :chapter, :integer
    field :verses, {:array, :string}
    field :translation, :string
  end

  @doc false
  def changeset(editor, attrs) do
    editor
    |> cast(attrs, [:book, :chapter, :verses, :translation])
    |> validate_required([:book, :chapter, :verses, :translation])
  end
end
