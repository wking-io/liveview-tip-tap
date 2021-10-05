defmodule WithoutCeasing.Content.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "resources" do
    field :description, :string
    field :status, Ecto.Enum, values: [:pending, :approved, :rejected]
    field :title, :string

    belongs_to :member, WithoutCeasing.Account.Member

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:title, :description, :status])
    |> validate_required([:title, :description, :status])
  end
end
