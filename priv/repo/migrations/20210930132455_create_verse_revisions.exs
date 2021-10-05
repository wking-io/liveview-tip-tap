defmodule WithoutCeasing.Repo.Migrations.CreateVerseRevisions do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE verse_revision_status AS ENUM ('pending','approved')")
    create table(:verse_revisions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :string, null: false
      add :status, :verse_revision_status, null: false, default: "pending"
      add :verse_id, references(:verses, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:verse_revisions, [:verse_id])
    create unique_index(:verse_revisions, [:verse_id, :status])
  end

  def down do
    drop table(:verse_revisions)
    execute("DROP TYPE account_user_role")
  end
end
