defmodule Thamani.Retail_Returns.Retail_Return do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User
  alias Thamani.Items.Sku

  schema "retail_returns" do
    field(:active, :string)
    belongs_to(:companies, User, foreign_key: :company)
    belongs_to(:sku, Sku, foreign_key: :gtin)
    field(:description, :string)
    field(:comments, :string)
    field(:quantity, :integer)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(retail__return, attrs) do
    retail__return
    |> cast(attrs, [:gtin, :company, :quantity, :description, :comments, :active])
    |> validate_required([:gtin, :company, :quantity, :description, :active])
  end
end
