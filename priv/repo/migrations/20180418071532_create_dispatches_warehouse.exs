defmodule Thamani.Repo.Migrations.CreateDispatchesWarehouse do
  use Ecto.Migration

  def change do
    create table(:dispatches_warehouse) do
      add :item, :integer
      add :quantity, :integer
      add :total, :float
      add :retailer, :integer
      add :transporter, :string
      add :transporterid, :string
      add :description, :text
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false
      timestamps()
    end

    create index(:dispatches_warehouse, [:user_id])
  end
end
