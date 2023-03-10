defmodule Thamani.Repo.Migrations.CreateKcity do
  use Ecto.Migration

  def change do
    create table(:kcity) do
      add :city, :string
      add :status, :string
      add :population, :text
      add :county, :string
      add :active, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:kcity, [:user_id])
  end
end
