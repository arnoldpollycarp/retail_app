defmodule Thamani.Returns.Return do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User
  alias Thamani.Items.Sku

  schema "returns" do
    field(:active, :string)
    field(:description, :string)
    field(:comments, :string)
    belongs_to(:companies, User, foreign_key: :company)
    belongs_to(:sku, Sku, foreign_key: :gtin)
    field(:quantity, :integer)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(return, attrs) do
    return
    |> cast(attrs, [:gtin, :quantity, :company, :description, :comments, :active])
    |> validate_required([:gtin, :quantity, :company, :description])
  end
end
