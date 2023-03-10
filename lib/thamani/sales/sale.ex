defmodule Thamani.Sales.Sale do
  use Ecto.Schema
  import Ecto.Changeset
  use Rummage.Ecto
  alias Thamani.Items.Sku
  alias Thamani.Sales.Sale
  alias Thamani.Accounts.User

  schema "sales" do
    field(:active, :string)
    field(:gs1, :float)
    belongs_to(:sku, Sku, foreign_key: :item)
    field(:manufacturer, :float)
    field(:mid, :integer)
    field(:mode, :string)
    field(:quantity, :integer)
    field(:retailer, :float)
    field(:retailer_name, :string)
    field(:warehouse, :float)
    field(:wid, :integer)
    field(:sale_id, :string)
    field(:imei, :string)
    field(:staff, :integer)
    field(:date, :string)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(%Sale{} = sale, attrs) do
    sale
    |> cast(attrs, [
      :item,
      :quantity,
      :mode,
      :date,
      :staff,
      :manufacturer,
      :mid,
      :warehouse,
      :wid,
      :gs1,
      :retailer,
      :retailer_name,
      :sale_id,
      :imei,
      :user_id
    ])
    |> validate_required([:item])
  end
end
