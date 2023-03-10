defmodule Thamani.Credit_note.Notes do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User

  schema "note" do
    field(:active, :string)
    field(:customer, :string)
    field(:description, :string)
    field(:item, :integer)
    field(:note_number, :string)
    field(:quantity, :integer)
    field(:phone, :string)
    field(:staff, :integer)
    field(:receipt_number, :string)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(notes, attrs) do
    notes
    |> cast(attrs, [
      :note_number,
      :receipt_number,
      :item,
      :customer,
      :phone,
      :quantity,
      :staff,
      :description,
      :active,
      :user_id
    ])
    |> validate_required([
      :note_number,
      :receipt_number,
      :item,
      :customer,
      :phone,
      :quantity,
      :staff
    ])
  end
end
