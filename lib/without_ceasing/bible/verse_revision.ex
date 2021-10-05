defmodule WithoutCeasing.Bible.VerseRevision do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "verse_revisions" do
    field :text, :string
    field :status, Ecto.Enum, values: [:pending, :approved]

    belongs_to :verse, WithoutCeasing.Bible.Verse
    belongs_to :translation, WithoutCeasing.Bible.Translation

    timestamps()
  end

  @doc false
  def changeset(verse_revision, attrs) do
    verse_revision
    |> cast(attrs, [:text, :status, :verse_id])
    |> cast_assoc(:verse)
    |> validate_required([:text, :status])
  end
end
