defmodule WithoutCeasing.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def up do
    create table(:entries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :map
      add :member_id, references(:members, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create table(:verse_entries, primary_key: false) do
      add :entry_id, references(:entries, type: :binary_id)
      add :verse_id, references(:verses, type: :id)
    end


    create(index(:entries, [:member_id]))
    create(index(:verse_entries, [:entry_id]))
    create(index(:verse_entries, [:verse_id]))

    create(
      unique_index(:verse_entries, [:entry_id, :verse_id], name: :entry_id_verse_id_unique_index)
    )
  end

  def down do
    drop table(:entries)
    drop table(:verse_entries)
  end
end
