defmodule Thamani.Repo.Migrations.CreateStaff do
  use Ecto.Migration

  def change do
    create table(:staff) do
      add :fullname, :string
      add :email, :string
      add :passcode, :integer
      add :active, :string
      add :description, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                   null: false
      timestamps()
    end

    create index(:staff, [:user_id])
    create unique_index(:staff, [:email])
  end
end
