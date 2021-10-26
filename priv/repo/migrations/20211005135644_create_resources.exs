defmodule WithoutCeasing.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def up do
    create table(:resources, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :string
      add :status, :status, null: false, default: "pending"
      add :member_id, references(:members, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create table(:verse_resources, primary_key: false) do
      add :resource_id, references(:resources, type: :binary_id), primary_key: true
      add :verse_id, references(:verses, type: :id), primary_key: true
    end

    create(index(:resources, [:member_id]))
    create(index(:verse_resources, [:resource_id]))
    create(index(:verse_resources, [:verse_id]))

    create(
      unique_index(:verse_resources, [:resource_id, :verse_id], name: :resource_id_verse_id_unique_index)
    )
  end

  def down do
    drop table(:resources)
    drop table(:verse_resources)
  end
end
