defmodule Thamani.Repo.Migrations.CreateManufacturerOrders do
  use Ecto.Migration

  def change do
    create table(:manufacturer_orders) do
      add :item, :integer
      add :category, :string
      add :manufacturer, :integer
      add :uom, :string
      add :quantity, :integer
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete: :delete_all),
                   null: false
      timestamps()
    end

    create index(:manufacturer_orders, [:user_id])
  end
end
