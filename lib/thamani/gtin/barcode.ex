defmodule Thamani.GTIN.Barcode do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.GTIN.Barcode
  alias Thamani.Accounts.User
  use Rummage.Ecto

  schema "barcode" do
    field(:active, :string)
    field(:carton, :string)
    field(:code, :string)
    field(:mn, :string)
    field(:name, :string)
    field(:description, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(%Barcode{} = barcode, attrs) do
    barcode
    |> cast(attrs, [:code, :mn, :name, :description, :carton, :active])
    |> validate_required([:code, :mn, :name, :description, :active])
    |> unique_constraint(:code)
  end
end
