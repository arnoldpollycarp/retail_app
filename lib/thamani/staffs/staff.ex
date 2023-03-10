defmodule Thamani.Staffs.Staff do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User
  alias Thamani.Shops.Shop

  schema "staff" do
    field(:active, :string)
    field(:phone, :integer)
    field(:fullname, :string)
    field(:passcode, :integer)
    belongs_to(:shops, Shop, foreign_key: :shop)
    field(:description, :string)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(staff, attrs) do
    staff
    |> cast(attrs, [:fullname, :phone, :passcode, :shop, :description, :active, :user_id])
    |> validate_required([:fullname, :phone, :passcode, :shop, :active])
    |> unique_constraint(:phone, message: "Already Exists")
  end
end
