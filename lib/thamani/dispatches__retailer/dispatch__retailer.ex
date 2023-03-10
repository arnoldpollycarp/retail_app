defmodule Thamani.Dispatches_Retailer.Dispatch_Retailer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Items.Sku
  alias Thamani.Accounts.User

  schema "dispatches_retailer" do
    field(:active, :string)
    field(:delivery, :string)
    belongs_to(:sku, Sku, foreign_key: :item)
    field(:scode, :string)
    field(:batch, :string)
    field(:expiry, :string)
    field(:production, :string)
    field(:shipping, :string)
    field(:description, :string)
    field(:quantity, :integer)
    field(:uom, :string)
    belongs_to(:company, User, foreign_key: :retailer)
    field(:total, :float)
    field(:transporter, :string)
    field(:transporterid, :string)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(dispatch__retailer, attrs) do
    dispatch__retailer
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
      :retailer,
      :transporter,
      :transporterid,
      :description,
      :delivery,
      :active,
      :user_id
    ])
    |> validate_required([:item, :quantity, :retailer, :transporter, :transporterid])
    |> unique_constraint(:scode, message: "Already Exists")
  end
end
