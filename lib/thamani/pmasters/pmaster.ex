defmodule Thamani.Pmasters.Pmaster do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pmaster" do
    field(:active, :string)
    field(:description, :string)
    field(:max, :float)
    field(:min, :float)
    field(:names, :string)
    field(:type, :string)
    field(:user_id, :string)

    timestamps()
  end

  @doc false
  def changeset(pmaster, attrs) do
    pmaster
    |> cast(attrs, [:names, :type, :min, :max, :description, :active, :user_id])
    |> validate_required([:names, :type, :min, :max, :active])
  end
end
