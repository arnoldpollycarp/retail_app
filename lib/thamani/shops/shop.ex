defmodule Thamani.Shops.Shop do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User
  alias Thamani.Kcitys.KCity

  schema "shop" do
    field(:active, :string)
    field(:description, :string)
    belongs_to(:kcity, KCity, foreign_key: :location)
    field(:name, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(shop, attrs) do
    shop
    |> cast(attrs, [:name, :location, :description, :active])
    |> validate_required([:name, :location, :active])
  end
end
