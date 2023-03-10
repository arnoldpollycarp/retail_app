defmodule Thamani.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:device) do
      add :name, :string
      add :imei, :string
      add :description, :string
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false

      timestamps()
    end

    create unique_index(:device, [:imei])
    create index(:device, [:user_id])
  end
end
