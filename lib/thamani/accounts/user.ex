defmodule Thamani.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Accounts.User
  alias Comeonin.Bcrypt
  alias Thamani.GTIN.Barcode
  alias Thamani.Items.Sku
  alias Thamani.Codes.Code
  alias Thamani.Companies.Company
  alias Thamani.Dispatches.Dispatch
  alias Thamani.Dispatches_Warehouse.Dispatch_Warehouse
  alias Thamani.Dispatches_Retailer.Dispatch_Retailer
  alias Thamani.Inventories.Inventory
  alias Thamani.Sales.Sale
  alias Thamani.Storages.Storage
  alias Thamani.Staffs.Staff
  alias Thamani.Batches.Batch
  alias Thamani.Returns.Return
  alias Thamani.Retail_Returns.Retail_Return
  alias Thamani.Manufacturer_orders.Manufacturer_order
  alias Thamani.Warehouse_orders.Warehouse_order
  alias Thamani.Shops.Shop
  alias Thamani.Devices.Device
  alias Thamani.Discounts.Discount
  alias Thamani.Floats.Float
  alias Thamani.Retman_orders.Retman_order
  alias Thamani.Breakbulks.Breakbulk
  alias Thamani.Reorders.Reorder
  alias Thamani.Invoicing.Invoice
  alias Thamani.Credit_note.Notes
  use Arc.Ecto.Schema
  use Rummage.Ecto
  @derive {Phoenix.Param, key: :slug}

  schema "users" do
    field(:active, :string)
    field(:email, :string)
    field(:company, :string)
    field(:phone, :integer)
    field(:account_number, :string)
    field(:paybill, :string)
    field(:tillnumber, :string)
    field(:firstname, :string)
    field(:lastname, :string)
    field(:loggedin, :integer)
    field(:password, :string)
    field(:slug, :string)
    field(:userlevel, :boolean)
    field(:manufacturer, :boolean)
    field(:warehouse, :boolean)
    field(:retailer, :boolean)
    field(:registercode, :string)
    field(:verified, :integer)
    field(:resetcode, :string)
    field(:token, :string)
    field(:location, :integer)
    field(:image, Thamani.ImageUploader.Type)
    field(:password_confirmation, :string, virtual: true)
    has_many(:barcode, Barcode)
    has_many(:sku, Sku)
    has_many(:codes, Code)
    has_many(:companies, Company)
    has_many(:dispatches, Dispatch)
    has_many(:dispatches_warehouse, Dispatch_Warehouse)
    has_many(:dispatches_retailer, Dispatch_Retailer)
    has_many(:inventories, Inventory)
    has_many(:sales, Sale)
    has_many(:batches, Batch)
    has_many(:storages, Storage)
    has_many(:returns, Return)
    has_many(:retail_returns, Retail_Return)
    has_many(:warehouse_orders, Warehouse_order)
    has_many(:manufacturer_orders, Manufacturer_order)
    has_many(:staff, Staff)
    has_many(:shop, Shop)
    has_many(:device, Device)
    has_many(:discount, Discount)
    has_many(:floats, Float)
    has_many(:breakbulk, Breakbulk)
    has_many(:retman_orders, Retman_order)
    has_many(:reorders, Reorder)
    has_many(:invoice, Invoice)
    has_many(:note, Notes)
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    attrs = Map.merge(attrs, slug_map(attrs))

    user
    |> cast(attrs, [
      :firstname,
      :lastname,
      :email,
      :company,
      :phone,
      :location,
      :account_number,
      :tillnumber,
      :paybill,
      :password,
      :userlevel,
      :image,
      :loggedin,
      :active,
      :slug,
      :registercode,
      :resetcode,
      :token,
      :verified,
      :manufacturer,
      :warehouse,
      :retailer
    ])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:firstname, :lastname, :company, :phone, :email, :location, :password])
    |> unique_constraint(:email, message: "Already Exists")
    |> unique_constraint(:company, message: "Already Exists")
    |> unique_constraint(:slug, message: "Already Exists")
    |> validate_confirmation(:password, message: "Passwords does not match")
    |> validate_length(:password, min: 6, max: 100)
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(
          changeset,
          :password,
          Comeonin.Bcrypt.hashpwsalt(password)
        )

      _ ->
        changeset
    end
  end

  defp slug_map(%{"email" => firstname}) do
    slug = String.reverse(firstname) |> String.replace("@", "") |> String.replace(".", "")
    %{"slug" => slug}
  end

  defp slug_map(_params) do
    %{}
  end

  defimpl Phoenix.Param, for: Thamani.Accounts.User do
    def to_param(%{slug: slug}) do
      "#{slug}"
    end
  end

  # def random_string(length) do
  #  :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  # end

  # random_string(64)
end
