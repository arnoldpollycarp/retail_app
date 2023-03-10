defmodule Gs1kenya.Repo.Migrations.CreateSku do
  use Ecto.Migration

  def change do
    create table(:sku) do
      add :name, :string
      add :description, :string
      add :quantity, :integer
      add :weight, :string
      add :weight2, :string
      add :length, :string
      add :width, :string
      add :radius, :string
      add :height, :string
      add :gtin, :string
      add :company, :string
      add :price, :integer
      add :image, :string
      add :active, :string
      add :user_id, references(:users, on_delete:  :delete_all),
                    null: false

      timestamps()
    end

    create index(:sku, [:user_id])

  end
end
