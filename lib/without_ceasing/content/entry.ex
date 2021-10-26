defmodule WithoutCeasing.Content.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "entries" do
    field :content, :map

    belongs_to :member, WithoutCeasing.Identity.Member

    many_to_many :verses, WithoutCeasing.Bible.Verse,
      join_through: "verse_entries",
      on_replace: :delete

    timestamps()
  end

  @doc false
  def create_changeset(entry, attrs, verses, member) do
    entry
    |> cast(attrs, [:content])
    |> validate_required([:content])
    |> put_assoc(:verses, verses)
    |> put_assoc(:member, member)
  end

  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
