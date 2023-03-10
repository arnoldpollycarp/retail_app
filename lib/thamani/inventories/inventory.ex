defmodule Thamani.Inventories.Inventory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Items.Sku
  alias Thamani.Discounts.Discount
  alias Thamani.Accounts.User

  schema "inventories" do
    field(:active, :string)
    field(:confirm, :string)
    field(:category, :string)
    field(:description, :string)
    field(:quantity, :integer)
    field(:sold, :decimal)
    field(:remain, :integer)
    field(:reorderstock, :integer)
    field(:reorderlevel, :integer)
    field(:batch, :string)
    field(:expiry, :string)
    field(:production, :string)
    field(:breakbulk_code, :integer)
    field(:recieved_id, :integer)
    field(:type, :string)
    field(:manufacturer, :float)
    field(:mid, :integer)
    field(:warehouse, :float)
    field(:wid, :integer)
    field(:gs1, :float)
    belongs_to(:discounts, Discount, foreign_key: :discount)
    belongs_to(:sku, Sku, foreign_key: :item)
    field(:price, :string)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [
      :item,
      :manufacturer,
      :mid,
      :discount,
      :warehouse,
      :wid,
      :gs1,
      :price,
      :category,
      :description,
      :reorderstock,
      :reorderlevel,
      :batch,
      :expiry,
      :production,
      :breakbulk_code,
      :recieved_id,
      :type,
      :quantity,
      :sold,
      :remain,
      :active,
      :confirm,
      :user_id
    ])
    |> validate_required([:item, :price, :active])
  end
end
