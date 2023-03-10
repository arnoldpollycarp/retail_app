defmodule Croptrace.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstname, :string
      add :lastname, :string
      add :email, :string
      add :company, :string
      add :password, :text
      add :userlevel, :boolean
      add :loggedin, :integer
      add :active, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:company])
    create unique_index(:users, [:slug])
  end
end
