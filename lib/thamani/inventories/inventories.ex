defmodule Thamani.Inventories do
  @moduledoc """
  The Inventories context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Inventories.Inventory
  alias Thamani.Dispatches.Dispatch
  alias Thamani.Dispatches_Warehouse.Dispatch_Warehouse
  alias Thamani.Dispatches_Retailer.Dispatch_Retailer
  alias Thamani.Items.Sku
  alias Thamani.Sales.Sale
  alias Thamani.Breakbulks.Breakbulk
  alias Thamani.Discounts.Discount
  alias Thamani.Accounts.User
  alias Thamani.Reorders.Reorder

  @doc """
  Returns the list of inventories.

  ## Examples

      iex> list_inventories()
      [%Inventory{}, ...]

  """

  def list_inventories(current_user) do
    Inventory

    Repo.all(
      from(d in Inventory, where: d.user_id == ^current_user.id, distinct: true, select: d.item)
    )
  end

  def list_inventories_admin() do
    Inventory

    Repo.all(Inventory)
    |> Repo.preload(:sku)
    |> Repo.preload(:discounts)
    |> Repo.preload(:user)
  end

  def list_inventories!(user_id) do
    Repo.all(from(d in Inventory, where: d.user_id == ^user_id))
    |> Repo.preload(:sku)
    |> Repo.preload(:discounts)
    |> Repo.preload(:user)
  end

  def list_inventory_by_expiry(date_1, date, user_id) do
    Repo.all(
      from(
        d in Inventory,
        where: d.expiry >= ^date and d.expiry <= ^date_1 and d.user_id == ^user_id.id
      )
    )
    |> Repo.preload(:sku)
    |> Repo.preload(:discounts)
    |> Repo.preload(:user)
  end

  def list_inventories_by_item!(user_id, item) do
    Repo.all(from(d in Inventory, where: d.user_id == ^user_id.id and d.item == ^item))
    |> Repo.preload(:sku)
    |> Repo.preload(:discounts)
    |> Repo.preload(:user)
  end

  def list_inventories_by_item_admin!(item) do
    Repo.all(from(d in Inventory, where: d.item == ^item))
    |> Repo.preload(:sku)
    |> Repo.preload(:discounts)
    |> Repo.preload(:user)
  end

  def list_inventories_by_item_one!(user_id, item) do
    Repo.all(from(d in Inventory, where: d.user_id == ^user_id.id and d.item == ^item, limit: 1))
    |> Repo.preload(:sku)
    |> Repo.preload(:discounts)
    |> Repo.preload(:user)
  end

  def list_inventories_by_item_admin_one!(item) do
    Repo.all(from(d in Inventory, where: d.item == ^item, limit: 1))
    |> Repo.preload(:sku)
    |> Repo.preload(:discounts)
    |> Repo.preload(:user)
  end

  def list_reorder(companies) do
    Repo.all(from(d in Inventory, where: d.mid == ^companies and d.remain < ^11))
    |> Repo.preload(:sku)
    |> Repo.preload(:discounts)
    |> Repo.preload(:user)
  end

  def list_reorder_all() do
    Repo.all(from(d in Inventory, where: d.remain < ^11))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single inventory.

  Raises `Ecto.NoResultsError` if the Inventory does not exist.

  ## Examples

      iex> get_inventory!(123)
      %Inventory{}

      iex> get_inventory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inventory!(id) do
    Repo.get!(Inventory, id)
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def get_inventory_by_gtin(id, user_id) do
    Repo.one(
      from(
        d in Inventory,
        join: c in Sku,
        where: c.gtin == ^id and d.item == c.id and d.user_id == ^user_id,
        limit: 1
      )
    )
    |> Repo.preload(:sku)
    |> Repo.preload(:discounts)
    |> Repo.preload(:user)
  end

  def get_inventory_by_gtin!(id) do
    Repo.one(
      from(d in Inventory, join: c in Sku, where: c.gtin == ^id and d.item == c.id, limit: 1)
    )
    |> Repo.preload(:sku)
    |> Repo.preload(:discounts)
    |> Repo.preload(:user)
  end

  def get_reorder(companies, id) do
    Repo.one(from(d in Inventory, where: d.mid == ^companies and d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def get_reorder!(id) do
    Repo.one(from(d in Inventory, where: d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a inventory.

  ## Examples

      iex> create_inventory(%{field: value})
      {:ok, %Inventory{}}

      iex> create_inventory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inventory(attrs \\ %{}) do
    %Inventory{}
    |> Inventory.changeset(attrs)
    |> Repo.insert()
  end

  def create_inventory_node(
        item,
        price,
        mid,
        manufacturer,
        warehouse,
        wid,
        gs1,
        description,
        quantity,
        active,
        reorderstock,
        reorderlevel,
        batch,
        expiry,
        production,
        breakbulk_code,
        type,
        current_user
      ) do
    %Inventory{
      item: item,
      price: price,
      mid: mid,
      manufacturer: manufacturer,
      warehouse: warehouse,
      wid: wid,
      gs1: gs1,
      description: description,
      quantity: quantity,
      active: active,
      reorderstock: reorderstock,
      reorderlevel: reorderlevel,
      batch: batch,
      expiry: expiry,
      production: production,
      breakbulk_code: breakbulk_code,
      type: type,
      user_id: current_user
    }
    |> Repo.insert()
  end

  def create_inventory_node_manufacturer(
        item,
        price,
        mid,
        manufacturer,
        warehouse,
        wid,
        gs1,
        description,
        quantity,
        active,
        reorderstock,
        reorderlevel,
        batch,
        expiry,
        production,
        recieved_id,
        type,
        current_user
      ) do
    %Inventory{
      item: item,
      price: price,
      mid: mid,
      manufacturer: manufacturer,
      warehouse: warehouse,
      wid: wid,
      gs1: gs1,
      description: description,
      quantity: quantity,
      active: active,
      reorderstock: reorderstock,
      reorderlevel: reorderlevel,
      batch: batch,
      expiry: expiry,
      production: production,
      recieved_id: recieved_id,
      type: type,
      user_id: current_user
    }
    |> Repo.insert()
  end

  @doc """
  Updates a inventory.

  ## Examples

      iex> update_inventory(inventory, %{field: new_value})
      {:ok, %Inventory{}}

      iex> update_inventory(inventory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inventory(%Inventory{} = inventory, attrs) do
    inventory
    |> Inventory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Inventory.

  ## Examples

      iex> delete_inventory(inventory)
      {:ok, %Inventory{}}

      iex> delete_inventory(inventory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inventory(%Inventory{} = inventory) do
    Repo.delete(inventory)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inventory changes.

  ## Examples

      iex> change_inventory(inventory)
      %Ecto.Changeset{source: %Inventory{}}

  """
  def change_inventory(%Inventory{} = inventory) do
    Inventory.changeset(inventory, %{})
  end

  def get_price(item, current_user) do
    Repo.one(
      from(
        i in Inventory,
        where: i.item == ^item and i.user_id == ^current_user.id,
        select: i.price,
        limit: 1
      )
    )
  end

  def get_item_discount(item, current_user) do
    Repo.one(
      from(
        i in Inventory,
        where: i.item == ^item and i.user_id == ^current_user.id,
        select: i.discount,
        limit: 1
      )
    )
  end

  def get_item_discount_value(item) do
    Repo.one(from(d in Discount, where: d.id == ^item, select: d.value, limit: 1))
  end

  def get_price!(item, user_id) do
    Repo.all(
      from(
        i in Inventory,
        where: i.item == ^item and i.user_id == ^user_id,
        select: i.price,
        limit: 1
      )
    )
  end

  def get_price_adding_item(item, current_user) do
    Repo.one(
      from(
        i in Inventory,
        where: i.item == ^item and i.user_id == ^current_user,
        select: i.price,
        limit: 1
      )
    )
  end

  def get_reorderlevel_adding_item(item, current_user) do
    Repo.one(
      from(
        i in Inventory,
        where: i.item == ^item and i.user_id == ^current_user,
        select: i.reorderlevel,
        limit: 1
      )
    )
  end

  def get_reorderstock_adding_item(item, current_user) do
    Repo.one(
      from(
        i in Inventory,
        where: i.item == ^item and i.user_id == ^current_user,
        select: i.reorderstock,
        limit: 1
      )
    )
  end

  def get_items(current_user) do
    Repo.all(from(b in Dispatch_Warehouse, where: b.retailer == ^current_user.id))
  end

  def get_items!(current_user) do
    Repo.all(
      from(b in Dispatch_Warehouse, where: b.retailer == ^current_user.id, select: {b.item, b.id})
    )
  end

  def get_items_manufacturer!(current_user) do
    Repo.all(
      from(
        b in Dispatch_Retailer,
        join: c in Sku,
        where: c.id == b.item and b.retailer == ^current_user.id,
        preload: [:sku]
      )
    )
  end

  def get_sum_inventory_price(current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.user_id == ^current_user.id,
        select: fragment("sum(i0.`price` * i0.`quantity`)")
      )
    )
  end

  def get_sum_quantity_sales(current_user) do
    Repo.one(
      from(
        d in Sale,
        where: d.user_id == ^current_user.id,
        select: fragment("sum(s0.`retailer` * s0.`quantity`)")
      )
    )
  end

  def get_count_inventory(current_user) do
    Repo.one(
      from(d in Inventory, where: d.user_id == ^current_user.id, select: count(d.item, :distinct))
    )
  end

  def get_count_inventory_all() do
    Repo.one(from(d in Inventory, select: count(d.id)))
  end

  def get_count_restock(current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.user_id == ^current_user.id and d.remain < 11,
        select: count(d.id)
      )
    )
  end

  def get_count_restock_man(current_user) do
    Repo.one(
      from(
        d in Reorder,
        where: d.mid == ^current_user.id and d.type ==^ "Manufacturer" and d.active == ^"false",
        select: count(d.id)
      )
    )
  end

  def get_count_restock_warehouse(current_user) do
    Repo.one(
      from(
        d in Reorder,
        where: d.wid == ^current_user.id and d.type ==^ "Warehouse"  and d.active == ^"false",
        select: count(d.id)
      )
    )
  end

  def get_count_restock_man_all() do
    Repo.one(from(d in Inventory, where: d.remain < 11, select: count(d.id)))
  end

  def check_item(item, current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.user_id == ^current_user and d.item == ^item,
        select: count(d.id)
      )
    )
  end

  def check_code(code, current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.user_id == ^current_user and d.breakbulk_code == ^code,
        select: count(d.id)
      )
    )
  end

  def check_recieved_code(current_user, code) do
    Repo.one(
      from(
        d in Inventory,
        where: d.user_id == ^current_user and d.recieved_id == ^code,
        select: count(d.id)
      )
    )
  end

  def get_item_count_quantity(item, current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.item == ^item and d.user_id == ^current_user.id,
        select: sum(d.quantity)
      )
    )
  end
  def get_item_count_quantity_pos(id, current_user) do
  Repo.one(
  from(
    d in Inventory,
    join: c in Sku,
    where: c.gtin == ^id and d.item == c.id and d.user_id == ^current_user,
    select: sum(d.quantity)
  ))
end

def get_item_count_quantity_stock(id, current_user) do
Repo.one(
from(
  d in Inventory,
  where:  d.item == ^id and d.user_id == ^current_user,
  select: sum(d.quantity)
))
end

def get_item_count_quantity_stock_ware(id,current_user) do
Repo.one(
from(
  b in Breakbulk,
  join: d in Dispatch,
  join: dw in Dispatch_Warehouse,
  where:  b.scode == d.id and d.item == ^id and b.code == dw.item and dw.retailer == ^current_user,
  select: sum(b.quantity)
))
end

def get_item_count_quantity_stock_ware_dispatch(id, current_user) do
Repo.one(
from(
  b in Breakbulk,
  join: dw in Dispatch_Warehouse,
  where:   b.scode == ^id and b.code == dw.item and dw.retailer == ^current_user,
  select: sum(b.quantity)
))
end

def get_breakbulk_id(item) do
  Repo.one(
    from(
      b in Breakbulk,
      join: d in Dispatch,
      where: b.scode == ^item and b.scode == d.id,
      select: d.item,
      limit: 1
    )
  )
end

def get_item_count_quantity_stock_ret(id, current_user) do
Repo.one(
from(
  d in Dispatch_Retailer,
  where:  d.item == ^id and d.retailer == ^current_user,
  select: sum(d.quantity)
))
end


  def get_sum_inventory_price_item(current_user, item) do
    Repo.one(
      from(
        d in Inventory,
        where: d.user_id == ^current_user.id and d.item == ^item,
        select: fragment("sum(i0.`price` * i0.`quantity`)")
      )
    )
  end

  def get_item_gtin(item) do
    Repo.one(from(d in Sku, where: d.id == ^item, select: d.gtin))
  end

  def get_item_name(item) do
    Repo.one(from(d in Sku, where: d.id == ^item, select: d.name))
  end

  def get_item_manufacturer(item, current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.item == ^item and d.user_id == ^current_user.id,
        select: d.manufacturer,
        limit: 1
      )
    )
  end

  def get_item_manufacturer_id(item, current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.item == ^item and d.user_id == ^current_user.id,
        select: d.mid,
        limit: 1
      )
    )
  end

  def get_manufacturer_id_name(manufacturer) do
    Repo.one(from(d in User, where: d.id == ^manufacturer, select: d.company))
  end

  def get_manufacturer_id_phone(manufacturer) do
    Repo.one(from(d in User, where: d.id == ^manufacturer, select: d.phone))
  end

  def get_item_warehouse(item, current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.item == ^item and d.user_id == ^current_user.id,
        select: d.warehouse,
        limit: 1
      )
    )
  end

  def get_item_warehouse_id(item, current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.item == ^item and d.user_id == ^current_user.id,
        select: d.wid,
        limit: 1
      )
    )
  end

  def get_warehouse_id_name(warehouse) do
    Repo.one(from(d in User, where: d.id == ^warehouse, select: d.company))
  end

  def get_warehouse_id_phone(warehouse) do
    Repo.one(from(d in User, where: d.id == ^warehouse, select: d.phone))
  end

  def get_item_reorderlevel(item, current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.item == ^item and d.user_id == ^current_user.id,
        select: d.reorderlevel,
        limit: 1
      )
    )
  end

  def get_item_reorderstock(item, current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.item == ^item and d.user_id == ^current_user.id,
        select: d.reorderstock,
        limit: 1
      )
    )
  end

  def get_item_id(item, current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.item == ^item and d.user_id == ^current_user.id,
        select: d.id,
        limit: 1
      )
    )
  end

  def get_item_type(item) do
    Repo.one(from(d in Inventory, where: d.id == ^item, select: d.item, limit: 1))
  end

  def get_item_order_type(item, current_user) do
    Repo.one(
      from(
        d in Inventory,
        where: d.item == ^item and d.user_id == ^current_user.id,
        select: d.type,
        limit: 1
      )
    )
  end
end
