defmodule Thamani.Repo.Migrations.AddScodeDispatch do
  use Ecto.Migration

  def change do
    alter table(:dispatches) do

      add :scode, :string

  end
    create unique_index(:dispatches, [:scode])
  end
end
