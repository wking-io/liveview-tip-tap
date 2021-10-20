defmodule WithoutCeasing.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def up do
    create table(:resources, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :string
      add :status, :status, null: false, default: "pending"

      timestamps()
    end

    create table(:verse_resources, primary_key: false) do
      add :resource_id, references(:resources, type: :binary_id), null: false
      add :verse_id, references(:verses, type: :id), null: false
      timestamps()
    end
  end

  def down do
    drop table(:resources)
    drop table(:verse_resources)
  end
end
