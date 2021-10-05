defmodule WithoutCeasing.Repo.Migrations.CreateTranslations do
  use Ecto.Migration

  def change do
    create table(:translations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :slug, :string

      timestamps()
    end

  end
end
