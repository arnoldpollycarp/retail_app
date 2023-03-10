defmodule Thamani.Manufacturer_orders do
  @moduledoc """
  The Manufacturer_orders context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo
  alias Thamani.Items.Sku
  alias Thamani.Accounts.User

  alias Thamani.Manufacturer_orders.Manufacturer_order

  @doc """
  Returns the list of manufacturer_orders.

  ## Examples

      iex> list_manufacturer_orders()
      [%Manufacturer_order{}, ...]

  """
  def list_manufacturer_orders do
    Manufacturer_order
    |> Repo.all()
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
    |> Repo.preload(:pmaster)
  end

  def list_orders_manufacturer(mid) do
    Manufacturer_order

    Repo.all(from(d in Manufacturer_order, where: d.manufacturer == ^mid))
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:pmaster)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
  end

  def list_companies(cat) do
    Dispatch
    Repo.all(from(s in Sku, where: s.category == ^cat, distinct: true, select: s.user_id))
  end

  def list_sku_name(cat, manufacturer) do
    Dispatch

    Repo.all(
      from(
        s in Sku,
        where: s.category == ^cat and s.user_id == ^manufacturer and s.active == ^"true",
        distinct: true,
        select: s.id
      )
    )
  end

  def list_uom(item) do
    Repo.all(
      from(
        s in Sku,
        where: s.id == ^item,
        select: [fragment("concat(?, ' ( ', ?,' ) ')", s.weight2, s.min_quantity)]
      )
    )
  end

  def get_manufacturer(item) do
    Repo.all(
      from(
        s in Sku,
        join: c in User,
        where: s.id == ^item and s.user_id == c.id,
        select: c.company,
        limit: 1
      )
    )
  end

  def get_manufacturer_name(name) do
    Repo.all(from(c in User, where: c.id == ^name, select: c.company))
  end

  def get_manufacturer_phone(name) do
    Repo.one(from(c in User, where: c.id == ^name, select: c.phone))
  end

  def get_sku_name(item) do
    Repo.all(from(c in Sku, where: c.id == ^item, select: c.name))
  end

  def get_sku_weight(item) do
    Repo.all(from(c in Sku, where: c.id == ^item, select: c.weight))
  end

  def get_sku_weight2(item) do
    Repo.all(from(c in Sku, where: c.id == ^item, select: c.weight2))
  end

  def get_sku_gtin(item) do
    Repo.all(from(c in Sku, where: c.id == ^item, select: c.gtin))
  end

  def get_manufacturer_id(item) do
    Repo.all(
      from(
        s in Sku,
        join: c in User,
        where: s.id == ^item and s.user_id == c.id,
        select: c.id,
        limit: 1
      )
    )
  end

  def get_delivery(item) do
    Repo.all(from(s in Sku, where: s.id == ^item, select: s.delivery, limit: 1))
  end

  def get_price(item) do
    Repo.one(from(s in Sku, where: s.id == ^item, select: fragment("sum(s0.`price` + s0.`markup`)"), limit: 1))
  end

  def get_description(item) do
    Repo.all(from(s in Sku, where: s.id == ^item, select: s.description, limit: 1))
  end

  def get_min_quantity(item) do
    Repo.all(from(s in Sku, where: s.id == ^item, select: s.min_quantity, limit: 1))
  end

  def get_quantity_unit(item) do
    Repo.one(from(s in Sku, where: s.id == ^item, select: s.quantity))
  end

  def get_sku(item) do
    Sku

    Repo.all(from(s in Sku, join: c in User, where: s.id == ^item and s.user_id == c.id))
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single manufacturer_order.

  Raises `Ecto.NoResultsError` if the Manufacturer order does not exist.

  ## Examples

      iex> get_manufacturer_order!(123)
      %Manufacturer_order{}

      iex> get_manufacturer_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_manufacturer_order!(id) do
    Manufacturer_order
    |> Repo.get!(id)
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
    |> Repo.preload(:pmaster)
  end

  def get_orders_manufacturer(mid, id) do
    Repo.one(from(d in Manufacturer_order, where: d.manufacturer == ^mid and d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:company)
    |> Repo.preload(:pmaster)
  end

  @doc """
  Creates a manufacturer_order.

  ## Examples

      iex> create_manufacturer_order(%{field: value})
      {:ok, %Manufacturer_order{}}

      iex> create_manufacturer_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_manufacturer_order(attrs \\ %{}) do
    %Manufacturer_order{}
    |> Manufacturer_order.changeset(attrs)
    |> Repo.insert()
  end

  def create_orders(
        cid,
        category,
        item,
        delivery,
        city,
        manufacturer,
        quantity,
        description,
        current_user
      ) do
    %Manufacturer_order{
        order_id: cid,
	category: category,
      item: item,
      delivery: delivery,
      city: city,
      manufacturer: manufacturer,
      quantity: quantity,
      description: description,
      user_id: current_user
    }
    |> Repo.insert()
  end

  @doc """
  Updates a manufacturer_order.

  ## Examples

      iex> update_manufacturer_order(manufacturer_order, %{field: new_value})
      {:ok, %Manufacturer_order{}}

      iex> update_manufacturer_order(manufacturer_order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_manufacturer_order(%Manufacturer_order{} = manufacturer_order, attrs) do
    manufacturer_order
    |> Manufacturer_order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Manufacturer_order.

  ## Examples

      iex> delete_manufacturer_order(manufacturer_order)
      {:ok, %Manufacturer_order{}}

      iex> delete_manufacturer_order(manufacturer_order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_manufacturer_order(%Manufacturer_order{} = manufacturer_order) do
    Repo.delete(manufacturer_order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking manufacturer_order changes.

  ## Examples

      iex> change_manufacturer_order(manufacturer_order)
      %Ecto.Changeset{source: %Manufacturer_order{}}

  """
  def change_manufacturer_order(%Manufacturer_order{} = manufacturer_order) do
    Manufacturer_order.changeset(manufacturer_order, %{})
  end

  def get_count_order(current_user) do
    Repo.one(
      from(
        d in Manufacturer_order,
        where: d.manufacturer == ^current_user.id and d.active == ^"false",
        select: count(d.id)
      )
    )
  end

  def get_count_order_all() do
    Repo.one(from(d in Manufacturer_order, where: d.active == ^"false", select: count(d.id)))
  end
end
