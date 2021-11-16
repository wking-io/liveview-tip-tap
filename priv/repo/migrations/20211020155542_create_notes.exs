defmodule WithoutCeasing.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def up do
    create table(:notes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :map
      add :member_id, references(:members, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create table(:verse_notes, primary_key: false) do
      add :note_id, references(:notes, type: :binary_id)
      add :verse_id, references(:verses, type: :id)
    end


    create(index(:notes, [:member_id]))
    create(index(:verse_notes, [:note_id]))
    create(index(:verse_notes, [:verse_id]))

    create(
      unique_index(:verse_notes, [:note_id, :verse_id], name: :note_id_verse_id_unique_index)
    )
  end

  def down do
    drop table(:notes)
    drop table(:verse_notes)
  end
end
