defmodule WithoutCeasing.Bible.Translation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "translations" do
    field :name, :string
    field :slug, :string

    has_many :verse_revisions, WithoutCeasing.Bible.VerseRevisions
    timestamps()
  end

  @doc false
  def changeset(translation, attrs) do
    translation
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
  end
end
