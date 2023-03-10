defmodule Thamani.Dispatches.Dispatch do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Dispatches.Dispatch
  alias Thamani.Items.Sku
  alias Thamani.Accounts.User

  schema "dispatches" do
    field(:active, :string)
    field(:delivery, :string)
    belongs_to(:sku, Sku, foreign_key: :item)
    field(:scode, :string)
    field(:batch, :string)
    field(:expiry, :string)
    field(:production, :string)
    field(:price, :float)
    field(:shipping, :string)
    field(:quantity, :integer)
    field(:uom, :string)
    field(:total, :float)
    belongs_to(:companies, User, foreign_key: :retailer)
    belongs_to(:company, User, foreign_key: :warehouse)
    field(:description, :string)
    field(:transporter, :string)
    field(:transporterid, :string)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(%Dispatch{} = dispatch, attrs) do
    dispatch
    |> cast(attrs, [
      :item,
      :scode,
      :shipping,
      :quantity,
      :uom,
      :total,
      :batch,
      :expiry,
      :production,
      :price,
      :retailer,
      :warehouse,
      :transporter,
      :transporterid,
      :description,
      :delivery,
      :active,
      :user_id
    ])
    |> validate_required([:item, :quantity, :warehouse, :transporter, :transporterid])
    |> unique_constraint(:scode, message: "Already Exists")
  end
end
