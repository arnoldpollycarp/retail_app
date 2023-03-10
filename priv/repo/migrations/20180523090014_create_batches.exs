defmodule Thamani.Repo.Migrations.CreateBatches do
  use Ecto.Migration

  def change do
    create table(:batches) do
      add :item, :integer
      add :quantity, :integer
      add :batch, :string
      add :expiry, :string
      add :production, :string
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false

      timestamps()
    end

    create index(:batches, [:user_id])
  end
end
