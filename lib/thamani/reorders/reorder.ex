defmodule Thamani.Reorders.Reorder do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User
  alias Thamani.Items.Sku

  schema "reorders" do
    field(:active, :string)
    field(:description, :string)
    belongs_to(:sku, Sku, foreign_key: :item)
    field(:type, :string)
    field(:quantity, :integer)
    belongs_to(:manufacturer, User, foreign_key: :mid)
    belongs_to(:warehouse, User, foreign_key: :wid)
    field(:date, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(reorder, attrs) do
    reorder
    |> cast(attrs, [:item, :quantity, :type, :mid, :wid, :date, :description, :active])
    |> validate_required([:item, :quantity, :type, :mid, :wid, :active])
  end
end
