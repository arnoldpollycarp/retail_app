defmodule Thamani.Discounts.Discount do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User

  schema "discount" do
    field(:active, :string)
    field(:description, :string)
    field(:name, :string)
    field(:value, :integer)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(discount, attrs) do
    discount
    |> cast(attrs, [:name, :value, :description, :active])
    |> validate_required([:name, :value, :description, :active])
  end
end
