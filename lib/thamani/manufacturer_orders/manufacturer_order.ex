defmodule Thamani.Manufacturer_orders.Manufacturer_order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Items.Sku
  alias Thamani.Kcitys.KCity
  alias Thamani.Accounts.User
  alias Thamani.Pmasters.Pmaster

  schema "manufacturer_orders" do
    field(:active, :string)
    belongs_to(:pmaster, Pmaster, foreign_key: :category)
    field(:description, :string)
    field(:address, :string)
    belongs_to(:sku, Sku, foreign_key: :item)
    belongs_to(:kcity, KCity, foreign_key: :city)
    field(:delivery, :string)
    field(:order_id, :string)
    belongs_to(:company, User, foreign_key: :manufacturer)
    field(:quantity, :integer)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(manufacturer_order, attrs) do
    manufacturer_order
    |> cast(attrs, [
      :item,
      :category,
      :manufacturer,
      :city,
      :delivery,
      :quantity,
      :description,
      :address,
      :order_id,
      :active
    ])
    |> validate_required([:item, :category, :manufacturer, :city, :delivery, :quantity])
  end
end
