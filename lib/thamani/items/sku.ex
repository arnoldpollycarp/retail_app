defmodule Thamani.Items.Sku do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Items.Sku
  alias Thamani.Accounts.User
  alias Thamani.Pmasters.Pmaster
  use Arc.Ecto.Schema
  use Rummage.Ecto

  schema "sku" do
    field(:active, :string)
    field(:description, :string)
    belongs_to(:pmaster, Pmaster, foreign_key: :category)
    field(:gtin, :string)
    field(:height, :string)
    field(:min_quantity, :integer)
    field(:quantity, :string)
    field(:quantity_unit, :integer)
    field(:image, Thamani.ImageUploader.Type)
    field(:length, :string)
    field(:name, :string)
    field(:price, :string)
    field(:markup, :float)
    field(:delivery, :string)
    field(:radius, :string)
    field(:weight, :string)
    field(:weight2, :string)
    field(:width, :string)
    field(:scode, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(%Sku{} = sku, attrs) do
    sku
    |> cast(attrs, [
      :name,
      :price,
      :delivery,
      :description,
      :category,
      :weight,
      :weight2,
      :length,
      :width,
      :radius,
      :height,
      :quantity,
      :quantity_unit,
      :markup,
      :min_quantity,
      :gtin,
      :scode,
      :image,
      :active
    ])
    |> cast_attachments(attrs, [:image])
    |> validate_required([
      :name,
      :price,
      :delivery,
      :description,
      :weight,
      :weight2,
      :min_quantity,
      :gtin
    ])
  end
end
