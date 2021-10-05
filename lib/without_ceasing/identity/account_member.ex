defmodule WithoutCeasing.Identity.AccountMember do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account_members" do
    field :role, Ecto.Enum, values: [:owner, :admin, :member]
    field :state, Ecto.Enum, values: [:active, :disabled], default: :active
    belongs_to :account, WithoutCeasing.Identity.Account
    belongs_to :member, WithoutCeasing.Identity.Member

    timestamps()
  end

  @doc false
  def create_changeset(account_member, attrs) do
    account_member
    |> cast(attrs, [:role])
    |> validate_required([:role])
    |> put_assoc(:member, attrs.member)
    |> put_assoc(:account, attrs.account)
  end
end
