defmodule Thamani.Warehouse_orders.Warehouse_order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Items.Sku
  alias Thamani.Kcitys.KCity
  alias Thamani.Pmasters.Pmaster
  alias Thamani.Accounts.User

  schema "warehouse_orders" do
    field(:active, :string)
    field(:delivery, :string)
    belongs_to(:pmaster, Pmaster, foreign_key: :category)
    field(:description, :string)
    field(:address, :string)
    belongs_to(:sku, Sku, foreign_key: :item)
    belongs_to(:kcity, KCity, foreign_key: :city)
    field(:quantity, :integer)
    field(:order_id, :string)
    belongs_to(:company, User, foreign_key: :warehouse)
    belongs_to(:user, User, foreign_key: :user_id)
    timestamps()
  end

  @doc false
  def changeset(warehouse_order, attrs) do
    warehouse_order
    |> cast(attrs, [
      :item,
      :category,
      :warehouse,
      :delivery,
      :quantity,
      :city,
      :description,
      :address,
      :order_id,
      :user_id,
      :active
    ])
    |> validate_required([:item, :category, :warehouse, :quantity])
  end
end
