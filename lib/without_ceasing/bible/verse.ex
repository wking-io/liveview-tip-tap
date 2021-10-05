defmodule WithoutCeasing.Bible.Verse do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "verses" do
    field :book, :string
    field :chapter, :integer
    field :verse, :integer

    has_many :verse_revisions, WithoutCeasing.Bible.VerseRevision
    many_to_many :resources, WithoutCeasing.Content.Resource, join_through: "verse_resources"
    many_to_many :entries, WithoutCeasing.Content.Entry, join_through: "verse_entries"

    timestamps()
  end

  @doc false
  def changeset(verse, attrs) do
    verse
    |> cast(attrs, [:book, :chapter, :order, :translation_id])
    |> cast_assoc(:translation)
    |> validate_required([:book, :chapter, :order])
  end

  @doc false
  def create_changeset(verse, attrs) do
    changeset(verse, attrs)
    |> unique_constraint([:book, :chapter, :order, :translation])
  end
end
