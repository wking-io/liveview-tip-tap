defmodule WithoutCeasing.Repo.Migrations.CreateHighlights do
  use Ecto.Migration

  def change do
    create table(:highlights, primary_key: false) do
      add :verse_id, references(:verses, type: :id), null: false
      add :member_id, references(:members, type: :binary_id), null: false
    end

    create index(:highlights, [:verse_id])
    create index(:highlights, [:member_id])
  end
end
