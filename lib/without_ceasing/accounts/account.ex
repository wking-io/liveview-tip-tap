defmodule WithoutCeasing.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :name, :string
    field :city, :string
    field :region, :string
    field :country, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :city, :region, :country])
    |> validate_required([:name, :city, :region, :country])
  end
end
