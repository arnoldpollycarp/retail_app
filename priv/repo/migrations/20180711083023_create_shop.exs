defmodule Thamani.Repo.Migrations.CreateShop do
  use Ecto.Migration

  def change do
    create table(:shop) do
      add :name, :string
      add :location, :string
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false

      timestamps()
    end

    create index(:shop, [:user_id])
  end
end
