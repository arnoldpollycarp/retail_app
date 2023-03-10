defmodule Croptrace.Repo.Migrations.CreateDispatches do
  use Ecto.Migration

  def change do
    create table(:dispatches) do
      add :item, :integer
      add :quantity, :integer
      add :scode, :string
      add :total, :integer
      add :retailer, :integer
      add :warehouse, :integer
      add :transporter, :string
      add :transporterid, :string
      add :description, :text
      add :active, :string
      add :user_id, references(:users, on_delete: :delete_all),
                   null: false

      timestamps()
    end

    create index(:dispatches, [:user_id])
    
  end
end
