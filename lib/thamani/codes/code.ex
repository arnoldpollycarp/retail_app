defmodule Thamani.Codes.Code do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Codes.Code
  alias Thamani.Accounts.User
  alias Thamani.GTIN.Barcode
  use Rummage.Ecto

  schema "codes" do
    field(:active, :integer)
    field(:batch, :string)
    field(:code, :string)
    field(:expiry, :string)
    belongs_to(:barcode, Barcode, foreign_key: :gtin)
    field(:number, :integer)
    field(:production, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(%Code{} = code, attrs) do
    code
    |> cast(attrs, [:gtin, :number, :batch, :expiry, :production, :active, :code])
    |> validate_required([:gtin, :number, :batch, :expiry, :production])
    |> gdsn
  end

  defp gdsn(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{code: code}} ->
        put_change(
          changeset,
          :code,
          Enum.join([":batch", :expiry, :production])
        )

      _ ->
        changeset
    end
  end
end
