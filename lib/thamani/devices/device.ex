defmodule Thamani.Devices.Device do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User

  schema "device" do
    field(:active, :string)
    field(:description, :string)
    field(:imei, :string)
    field(:name, :string)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:name, :imei, :description, :active, :user_id])
    |> validate_required([:name, :imei, :description, :active])
    |> unique_constraint(:imei)
  end
end
