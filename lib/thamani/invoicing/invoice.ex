defmodule Thamani.Invoicing.Invoice do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User

  schema "invoice" do
    field(:active, :string)
    field(:invoice_number, :string)
    field(:items, :integer)
    field(:type, :string)
    belongs_to(:user, User, foreign_key: :user_id)

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:invoice_number, :type, :items, :active, :user_id])
    |> validate_required([:invoice_number, :items])
  end
end
