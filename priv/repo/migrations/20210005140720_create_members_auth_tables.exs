defmodule WithoutCeasing.Repo.Migrations.CreateMembersAuthTables do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :accepted_terms_at, :naive_datetime, null: false
      add :accepted_privacy_at, :naive_datetime, null: false
      timestamps()
    end

    create unique_index(:members, [:email])
    create unique_index(:members, ["lower(email)"])

    create table(:member_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :member_id, references(:members, type: :binary_id, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:member_tokens, [:member_id])
    create unique_index(:member_tokens, [:context, :token])
  end

  def down do
    drop table(:members)
    drop table(:member_tokens)
  end
end
