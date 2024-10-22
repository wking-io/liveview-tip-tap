defmodule WithoutCeasing.Content.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "resources" do
    field :description, :string
    field :status, Ecto.Enum, values: [:pending, :approved, :rejected]
    field :title, :string

    belongs_to :member, WithoutCeasing.Identity.Member

    many_to_many :verses, WithoutCeasing.Bible.Verse,
      join_through: "verse_resources",
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:title, :description, :status])
    |> validate_required([:title, :description, :status])
  end
end
