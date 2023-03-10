defmodule Thamani.Repo.Migrations.CreateSales do
  use Ecto.Migration

  def change do
    create table(:sales) do
      add :item, :integer
      add :quantity, :integer
      add :manufacturer, :integer
      add :warehouse, :float
      add :retailer, :float
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false
      timestamps()
    end

    create index(:sales, [:user_id])
  end
end
