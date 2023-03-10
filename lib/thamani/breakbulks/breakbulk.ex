defmodule Thamani.Breakbulks.Breakbulk do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Breakbulks.Breakbulk
  alias Thamani.Dispatches.Dispatch
  alias Thamani.Accounts.User

  schema "breakbulk" do
    field(:code, :string)
    field(:active, :string)
    field(:description, :string)
    field(:quantity, :integer)
    field(:uom, :string)
    belongs_to(:dispatch, Dispatch, foreign_key: :scode)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(%Breakbulk{} = breakbulk, attrs) do
    breakbulk
    |> cast(attrs, [:code, :scode, :quantity, :uom ,:description, :active, :user_id])
    |> validate_required([:code, :scode])
    |> validate_confirmation(:quantity, message: "Add All Corresponding Quantities")
  end
end
