defmodule Thamani.Dispatches_Warehouse.Dispatch_Warehouse do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Dispatches_Warehouse.Dispatch_Warehouse
  alias Thamani.Accounts.User

  schema "dispatches_warehouse" do
    field(:active, :string)
    field(:description, :string)
    field(:item, :string)
    field(:quantity, :integer)
    field(:uom, :string)
    belongs_to(:companies, User, foreign_key: :retailer)
    field(:total, :float)
    field(:transporter, :string)
    field(:transporterid, :string)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(%Dispatch_Warehouse{} = dispatch__warehouse, attrs) do
    dispatch__warehouse
    |> cast(attrs, [
      :item,
      :quantity,
      :uom,
      :total,
      :retailer,
      :transporter,
      :transporterid,
      :description,
      :active,
      :user_id
    ])
    |> validate_required([:item, :retailer, :transporter, :transporterid])
  end
end
