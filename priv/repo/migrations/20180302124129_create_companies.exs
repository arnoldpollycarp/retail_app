defmodule Croptrace.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :description, :text
      add :category, :integer
      add :active, :string
      add :user_id, references(:users, on_delete: :delete_all),
                   null: false

      timestamps()
    end

    create index(:companies, [:user_id])
  end
end
