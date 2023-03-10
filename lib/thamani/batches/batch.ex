defmodule Thamani.Batches.Batch do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User
  alias Thamani.Items.Sku

  schema "batches" do
    field(:active, :string)
    field(:batch, :string)
    field(:description, :string)
    field(:expiry, :date)
    belongs_to(:sku, Sku, foreign_key: :item)
    field(:production, :date)
    field(:quantity, :integer)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(batch, attrs) do
    batch
    |> cast(attrs, [:item, :quantity, :batch, :expiry, :production, :description, :active, :user_id])
    |> validate_required([:item, :quantity, :batch, :expiry, :production])
  end
end
