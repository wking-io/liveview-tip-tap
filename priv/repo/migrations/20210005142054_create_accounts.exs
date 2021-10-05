defmodule WithoutCeasing.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def up do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :city, :string, null: false
      add :region, :string, null: false
      add :country, :string, null: false

      timestamps()
    end

    create index(:accounts, [:id])
    create unique_index(:accounts, ["lower(name)", :city, :region, :country], name: :unique_account_by_location)

    create table(:account_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :account_id, references(:accounts, type: :binary_id, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:account_tokens, [:id])
    create index(:account_tokens, [:account_id])
    create unique_index(:account_tokens, [:context, :token])

    execute("CREATE TYPE account_member_role AS ENUM ('owner','admin','member')")
    execute("CREATE TYPE account_member_state AS ENUM ('active','disabled')")

    create table(:account_members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role, :account_member_role, null: false, default: "member"
      add :state, :account_member_state, null: false, default: "active"
      add :member_id, references(:members, on_delete: :delete_all, type: :binary_id)
      add :account_id, references(:accounts, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:account_members, [:id])
    create unique_index(:account_members, [:member_id, :account_id])
  end

  def down do
    drop table(:accounts)
    drop table(:account_tokens)
    drop table(:account_members)
    execute("DROP TYPE account_member_role")
    execute("DROP TYPE account_member_state")
  end
end
