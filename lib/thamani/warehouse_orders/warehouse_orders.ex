defmodule Thamani.Warehouse_orders do
  @moduledoc """
  The Warehouse_orders context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo
  alias Thamani.Items.Sku
  alias Thamani.Accounts.User
  alias Thamani.Dispatches.Dispatch
  alias Thamani.Dispatches_Warehouse.Dispatch_Warehouse
  alias Thamani.Warehouse_orders.Warehouse_order

  @doc """
  Returns the list of warehouse_orders.

  ## Examples

      iex> list_warehouse_orders()
      [%Warehouse_order{}, ...]

  """
  def list_warehouse_orders do
    Warehouse_order
    |> Repo.all()
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:user)
    |> Repo.preload(:pmaster)
  end

  def list_warehouse_orders!(current_user) do
    Warehouse_order

    Repo.all(from(w in Warehouse_order, where: w.user_id == ^current_user.id))
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:user)
    |> Repo.preload(:pmaster)
  end

  def list_orders_warehouse(mid) do
    Warehouse_order

    Repo.all(from(d in Warehouse_order, where: d.warehouse == ^mid))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
    |> Repo.preload(:kcity)
    |> Repo.preload(:pmaster)
  end

  def list_orders_warehouse_all() do
    Warehouse_order
    |> Repo.all()
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:user)
    |> Repo.preload(:pmaster)
  end

  def list_companies(cat) do
    Dispatch

    Repo.all(
      from(
        c in Dispatch,
        join: s in Sku,
        where: c.item == s.id and s.category == ^cat and c.active == ^"true",
        distinct: true,
        select: c.warehouse
      )
    )
  end

  def list_sku_name(cat, warehouse) do
    Dispatch

    Repo.all(
      from(
        c in Dispatch,
        join: s in Sku,
        where:
          c.item == s.id and s.category == ^cat and c.warehouse == ^warehouse and
            c.active == ^"true",
        distinct: true,
        select: c.item
      )
    )
  end

  def list_uom(item) do
    Repo.all(from(d in Dispatch, where: d.id == ^item, select: d.min_quantity))
  end

  def get_warehouse(item) do
    Repo.all(
      from(
        d in Dispatch,
        join: c in User,
        where: d.id == ^item and d.warehouse == c.id,
        select: c.company,
        limit: 1
      )
    )
  end

  def get_warehouse_name(name) do
    Repo.all(from(c in User, where: c.id == ^name, select: c.company))
  end

  def get_warehouse_phone(name) do
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

  def get_warehouse_id(item) do
    Repo.one(
      from(
        d in Dispatch,
        join: c in User,
        where: d.id == ^item and d.warehouse == c.id,
        select: c.id
      )
    )
  end

  def get_item_id(item) do
    Repo.one(from(d in Dispatch, where: d.id == ^item, select: d.item))
  end

  def get_delivery(item) do
    Repo.one(from(d in Dispatch, where: d.id == ^item, select: d.delivery, limit: 1))
  end

  def get_description(item) do
    Repo.all(from(d in Sku, where: d.id == ^item, select: d.description, limit: 1))
  end

  def get_availble_quantity(id, item_id) do
    Repo.one(
      from(
        d in Dispatch,
        where: d.warehouse == ^id and d.item == ^item_id,
        select: sum(d.quantity)
      )
    )
  end

  def get_count_quantity_item(id, item) do
    Repo.one(
      from(
        d in Dispatch_Warehouse,
        where: d.user_id == ^id and d.item == ^item,
        select: sum(d.quantity)
      )
    )
  end

  @doc """
  Gets a single warehouse_order.

  Raises `Ecto.NoResultsError` if the Warehouse order does not exist.

  ## Examples

      iex> get_warehouse_order!(123)
      %Warehouse_order{}

      iex> get_warehouse_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_warehouse_order!(id) do
    Repo.get!(Warehouse_order, id)
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:user)
  end

  def get_orders_warehouse(mid, id) do
    Warehouse_order

    Repo.one(from(d in Warehouse_order, where: d.warehouse == ^mid and d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:company)
  end

  def get_orders_warehouse(id) do
    Warehouse_order

    Repo.one(from(d in Warehouse_order, where: d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a warehouse_order.

  ## Examples

      iex> create_warehouse_order(%{field: value})
      {:ok, %Warehouse_order{}}

      iex> create_warehouse_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_warehouse_order(attrs \\ %{}) do
    %Warehouse_order{}
    |> Warehouse_order.changeset(attrs)
    |> Repo.insert()
  end

  def create_orders(
        cid,
        category,
        item,
        delivery,
        city,
        warehouse,
        quantity,
        description,
        current_user
      ) do
    %Warehouse_order{
      order_id: cid,
      category: category,
      item: item,
      delivery: delivery,
      city: city,
      warehouse: warehouse,
      quantity: quantity,
      description: description,
      user_id: current_user
    }
    |> Repo.insert()
  end

  @doc """
  Updates a warehouse_order.

  ## Examples

      iex> update_warehouse_order(warehouse_order, %{field: new_value})
      {:ok, %Warehouse_order{}}

      iex> update_warehouse_order(warehouse_order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_warehouse_order(%Warehouse_order{} = warehouse_order, attrs) do
    warehouse_order
    |> Warehouse_order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Warehouse_order.

  ## Examples

      iex> delete_warehouse_order(warehouse_order)
      {:ok, %Warehouse_order{}}

      iex> delete_warehouse_order(warehouse_order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_warehouse_order(%Warehouse_order{} = warehouse_order) do
    Repo.delete(warehouse_order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking warehouse_order changes.

  ## Examples

      iex> change_warehouse_order(warehouse_order)
      %Ecto.Changeset{source: %Warehouse_order{}}

  """
  def change_warehouse_order(%Warehouse_order{} = warehouse_order) do
    Warehouse_order.changeset(warehouse_order, %{})
  end

  def get_count_order(current_user) do
    Repo.one(
      from(
        d in Warehouse_order,
        where: d.warehouse == ^current_user.id and d.active == ^"false",
        select: count(d.id)
      )
    )
  end

  def get_count_order_all() do
    Repo.one(from(d in Warehouse_order, where: d.active == ^"false", select: count(d.id)))
  end
end
