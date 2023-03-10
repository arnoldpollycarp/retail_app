defmodule Gs1kenya.Repo.Migrations.CreateBarcode do
  use Ecto.Migration

  def change do
    create table(:barcode) do
      add :code, :string
      add :mn, :string
      add :name, :string
      add :description, :string
      add :carton, :string
      add :active, :integer
      add :user_id, references(:users, on_delete:  :delete_all),
                    null: false

      timestamps()
    end

    create unique_index(:barcode, [:code])
    create unique_index(:barcode, [:carton])
    create index(:barcode, [:user_id])
  end
end
