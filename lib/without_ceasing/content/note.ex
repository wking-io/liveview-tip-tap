defmodule WithoutCeasing.Content.Note do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notes" do
    field :content, :map

    belongs_to :member, WithoutCeasing.Identity.Member

    many_to_many :verses, WithoutCeasing.Bible.Verse,
      join_through: "verse_notes",
      on_replace: :delete

    timestamps()
  end

  @doc false
  def create_changeset(note, attrs) do
    note
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> put_assoc(:verses, attrs.verses)
    |> put_assoc(:member, attrs.member)
  end

  def update_changeset(note, attrs) do
    note
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> put_assoc(:verses, attrs.verses)
  end

  def changeset(note, attrs) do
    note
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
