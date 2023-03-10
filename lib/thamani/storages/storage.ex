defmodule Thamani.Storages.Storage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User
  alias Thamani.Dispatches.Dispatch
  alias Thamani.Items.Sku

  schema "storages" do
    field(:active, :string)
    field(:description, :string)
    belongs_to(:dispatch, Dispatch, foreign_key: :serial)
    belongs_to(:sku, Sku, foreign_key: :item)
    field(:name, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(storage, attrs) do
    storage
    |> cast(attrs, [:name, :item, :serial, :description, :active])
    |> validate_required([:name, :item, :description, :active])
    |> unique_constraint(:name)
  end
end
