defmodule Thamani.Retman_orders.Retman_order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Items.Sku
  alias Thamani.Kcitys.KCity
  alias Thamani.Pmasters.Pmaster
  alias Thamani.Accounts.User

  schema "retman_orders" do
    field(:active, :string)
    field(:delivery, :string)
    belongs_to(:pmaster, Pmaster, foreign_key: :category)
    field(:description, :string)
    field(:address, :string)
    belongs_to(:sku, Sku, foreign_key: :item)
    belongs_to(:kcity, KCity, foreign_key: :city)
    field(:order_id, :string)
    field(:quantity, :integer)
    belongs_to(:company, User, foreign_key: :manufacturer)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(retman_order, attrs) do
    retman_order
    |> cast(attrs, [
      :item,
      :category,
      :manufacturer,
      :quantity,
      :delivery,
      :description,
      :address,
      :order_id,
      :active
    ])
    |> validate_required([:item, :category, :manufacturer, :quantity])
  end
end
