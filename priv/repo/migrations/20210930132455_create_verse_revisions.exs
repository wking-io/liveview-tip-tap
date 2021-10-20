defmodule WithoutCeasing.Repo.Migrations.CreateVerseRevisions do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE status AS ENUM ('pending','approved','rejected')")
    create table(:verse_revisions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :string, null: false
      add :status, :status, null: false, default: "pending"
      add :verse_id, references(:verses, on_delete: :nothing, type: :id), null: false

      timestamps()
    end

    create index(:verse_revisions, [:verse_id])
    create unique_index(:verse_revisions, [:verse_id, :status])
  end

  def down do
    execute("DROP TYPE status")
    drop table(:verse_revisions)
  end
end
