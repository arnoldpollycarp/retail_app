defmodule Thamani.Carts.Cart do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User
  alias Thamani.Items.Sku


  schema "carts" do
    belongs_to(:sku, Sku, foreign_key: :item)
    field :qty, :integer
    field :status, :string
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:item, :qty, :status, :user_id])
    |> validate_required([:item, :qty])
  end
end
