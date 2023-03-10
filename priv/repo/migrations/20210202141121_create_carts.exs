defmodule Thamani.Repo.Migrations.CreateCarts do
  use Ecto.Migration

  def change do
    create table(:carts) do
      add :item, :integer
      add :qty, :integer
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:carts, [:user_id])
  end
end
