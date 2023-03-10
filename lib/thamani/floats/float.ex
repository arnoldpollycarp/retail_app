defmodule Thamani.Floats.Float do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User

  schema "float" do
    field(:account, :integer)
    field(:active, :string)
    field(:amount, :integer)
    field(:description, :string)
    field(:from, :string)
    field(:type, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(float, attrs) do
    float
    |> cast(attrs, [:account, :type, :amount, :from, :description, :active, :user_id])
    |> validate_required([:account, :type, :amount, :from, :description, :active, :user_id])
  end
end
