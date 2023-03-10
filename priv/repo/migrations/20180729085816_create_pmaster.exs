defmodule Thamani.Repo.Migrations.CreatePmaster do
  use Ecto.Migration

  def change do
    create table(:pmaster) do
      add :name, :string
      add :type, :string
      add :min, :integer
      add :max, :integer
      add :description, :string
      add :active, :string
      add :user_id, :string

      timestamps()
    end

  end
end
