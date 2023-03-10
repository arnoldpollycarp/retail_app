defmodule Thamani.Repo.Migrations.CreateFloat do
  use Ecto.Migration

  def change do
    create table(:float) do
      add :account, :integer
      add :type, :string
      add :amount, :integer
      add :from, :string
      add :description, :string
      add :active, :string
      add :user_id, :string

      timestamps()
    end

  end
end
