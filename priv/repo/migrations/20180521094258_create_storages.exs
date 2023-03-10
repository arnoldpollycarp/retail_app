defmodule Thamani.Repo.Migrations.CreateStorages do
  use Ecto.Migration

  def change do
    create table(:storages) do
      add :name, :string
      add :item, :integer
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:storages, [:name])
    create index(:storages, [:user_id])
  end
end
