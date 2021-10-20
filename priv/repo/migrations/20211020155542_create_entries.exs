defmodule WithoutCeasing.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def up do
    create table(:entries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :map

      timestamps()
    end

    create table(:verse_entries, primary_key: false) do
      add :entry_id, references(:entries, type: :binary_id), null: false
      add :verse_id, references(:verses, type: :id), null: false
      timestamps()
    end
  end

  def down do
    drop table(:entries)
    drop table(:verse_entries)
  end
end
