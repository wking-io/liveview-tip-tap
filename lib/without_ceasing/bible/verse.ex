defmodule WithoutCeasing.Bible.Verse do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: false}
  @foreign_key_type :id
  schema "verses" do
    field :book, :string
    field :chapter, :integer
    field :verse, :integer

    has_many :verse_revisions, WithoutCeasing.Bible.VerseRevision

    many_to_many :resources, WithoutCeasing.Content.Resource,
      join_through: "verse_resources",
      on_replace: :delete
  end

  @doc false
  def changeset(verse, attrs) do
    verse
    |> cast(attrs, [])
  end

  @doc false
  def create_changeset(verse, attrs) do
    changeset(verse, attrs)
    |> unique_constraint([:book, :chapter, :order, :translation])
  end
end
