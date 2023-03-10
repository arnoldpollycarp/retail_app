defmodule Thamani.Repo.Migrations.CreateRetailReturns do
  use Ecto.Migration

  def change do
    create table(:retail_returns) do
      add :gtin, :integer
      add :company, :integer
      add :quantity, :integer
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false
      timestamps()
    end

    create index(:retail_returns, [:user_id])
  end
end
