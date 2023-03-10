defmodule Thamani.Repo.Migrations.CreateReturns do
  use Ecto.Migration

  def change do
    create table(:returns) do
      add :gtin, :string
      add :company, :integer
      add :quantity, :integer
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false

      timestamps()
    end

    create index(:returns, [:user_id])
  end
end
