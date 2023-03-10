defmodule Thamani.Repo.Migrations.CreateDiscount do
  use Ecto.Migration

  def change do
    create table(:discount) do
      add :name, :string
      add :value, :integer
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false

      timestamps()
    end

    create index(:discount, [:user_id])
  end
end
