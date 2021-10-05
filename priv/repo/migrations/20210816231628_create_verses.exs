defmodule WithoutCeasing.Repo.Migrations.CreateVerses do
  use Ecto.Migration

  def up do
    create table(:verses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :book, :string, null: false
      add :chapter, :integer, null: false
      add :verse, :integer, null: false
      add :translation_id, references(:translations, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:verses, [:translation_id])
    create unique_index(:verses, [:book, :chapter, :verse, :translation_id])
  end

  def down do
    drop table(:verses)
  end
end
