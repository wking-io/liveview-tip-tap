defmodule WithoutCeasing.Repo.Migrations.CreateVerses do
  use Ecto.Migration

  def up do
    create table(:verses, primary_key: false) do
      add :id, :id, primary_key: true
      add :book, :string, null: false
      add :chapter, :integer, null: false
      add :verse, :integer, null: false

      timestamps()
    end

    create unique_index(:verses, [:book, :chapter, :verse])
  end

  def down do
    drop table(:verses)
  end
end
