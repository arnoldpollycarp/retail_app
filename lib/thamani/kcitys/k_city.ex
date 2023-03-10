defmodule Thamani.Kcitys.KCity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "kcity" do
    field(:active, :string)
    field(:city, :string)
    field(:county, :string)
    field(:population, :string)
    field(:status, :string)
    field(:user_id, :id)

    timestamps()
  end

  @doc false
  def changeset(k_city, attrs) do
    k_city
    |> cast(attrs, [:city, :status, :population, :county, :active])
    |> validate_required([:city, :status,  :county])
  end
end
