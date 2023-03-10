defmodule Thamani.Repo.Migrations.CreateInventories do
  use Ecto.Migration

  def change do
    create table(:inventories) do
      add :item, :integer
      add :price, :integer
      add :category, :string
      add :description, :text
      add :active, :string
      add :user_id, references(:users, on_delete: :delete_all),
                   null: false
      timestamps()
    end

    create index(:inventories, [:user_id])
    
  end
end
