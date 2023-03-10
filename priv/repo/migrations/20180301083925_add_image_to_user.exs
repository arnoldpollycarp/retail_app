defmodule Croptrace.Repo.Migrations.AddImageToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do

      add :image, :text

    end
  end
end
