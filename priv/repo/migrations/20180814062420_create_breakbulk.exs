defmodule Thamani.Repo.Migrations.CreateBreakbulk do
  use Ecto.Migration

  def change do
    create table(:breakbulk) do
      add :code, :string
      add :scode, :string
      add :quantity, :integer
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false

      timestamps()
    end

    create index(:breakbulk, [:user_id])
  end
end
