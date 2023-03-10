defmodule Thamani.Repo.Migrations.CreateReorders do
  use Ecto.Migration

  def change do
    create table(:reorders) do
      add :item, :integer
      add :quantity, :integer
      add :manufacturer, :string
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false
      timestamps()
    end

    create index(:reorders, [:user_id])
  end
end
