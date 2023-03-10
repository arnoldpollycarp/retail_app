defmodule Thamani.Repo.Migrations.CreateRetmanOrders do
  use Ecto.Migration

  def change do
    create table(:retman_orders) do
      add :item, :integer
      add :category, :string
      add :manufacturer, :integer
      add :uom, :string
      add :quantity, :integer
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false
      timestamps()
    end

    create index(:retman_orders, [:user_id])
  end
end
