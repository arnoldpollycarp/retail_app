defmodule Thamani.Mpesaapi.Mpesa do
  use Ecto.Schema
  import Ecto.Changeset
  use Arc.Ecto.Schema
  use Rummage.Ecto

  schema "mpesa" do
    field(:amount, :float)
    field(:description, :string)
    field(:phone, :integer)
    field(:receipt, :string)
    field(:transactiondate, :integer)

    timestamps()
  end

  @doc false
  def changeset(mpesa, attrs) do
    mpesa
    |> cast(attrs, [:amount, :receipt, :transactiondate, :description, :phone])
  end
end
