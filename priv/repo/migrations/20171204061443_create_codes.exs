defmodule Gs1kenya.Repo.Migrations.CreateCodes do
  use Ecto.Migration

  def change do
    create table(:codes) do
      add :gtin, :integer
      add :number, :integer
      add :batch, :string
      add :expiry, :string
      add :production, :string
      add :active, :integer
      add :code, :string
      add :user_id, references(:users, on_delete: :delete_all),
                    null: false

      timestamps()
    end

    create index(:codes, [:user_id])
  end
end
