defmodule Thamani.Repo.Migrations.CreateWarehouseOrders do
  use Ecto.Migration

  def change do
    create table(:warehouse_orders) do
      add :item, :integer
      add :category, :string
      add :warehouse, :integer
      add :uom, :string
      add :quantity, :integer
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete: :delete_all),
                   null: false

      timestamps()
    end

    create index(:warehouse_orders, [:user_id])
  end
end
