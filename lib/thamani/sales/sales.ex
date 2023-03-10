defmodule Thamani.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Sales.Sale
  alias Thamani.Inventories.Inventory
  alias Thamani.Items.Sku
  alias Thamani.Dispatches_Warehouse.Dispatch_Warehouse
  alias Thamani.Accounts.User
  alias Thamani.Pmasters.Pmaster

  @doc """
  Returns the list of sales.

  ## Examples

      iex> list_sales()
      [%Sale{}, ...]

  """
  def list_sales do
    Repo.all(Sale)
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def list_sales_by_user(user_id) do
    Repo.all(from(d in Sale, where: d.user_id == ^user_id))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def list_sales_by_mode() do
    Repo.all(from(d in Sale, where: d.mode == ^"cash"))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def list_sales_manufacturer(mid) do
    Dispatch

    Repo.all(from(d in Sale, where: d.mid == ^mid, order_by: [desc: d.id]))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def list_sales_warehouse(wid) do
    Dispatch

    Repo.all(from(d in Sale, where: d.wid == ^wid))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def list_sales_manufacturer_invoice(mid, date, date_1) do
    Sale

    Repo.all(from(d in Sale, where: d.mid == ^mid and d.date >= ^date and d.date <= ^date_1))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def list_sales_manufacturer_invoice_uniq(mid, date, date_1) do
    Sale
   Repo.all(from d in Sale, where: d.mid == ^mid and d.date >= ^date and d.date <= ^date_1, distinct: true,select: d.item)

  end
  def get_name_sale_uniq(item) do
    Repo.one(from(d in Sku, where:  d.id == ^item , select: (d.name)))
  end
  def get_price_sale_uniq_man(item) do
    Repo.one(from(d in Sku, where:  d.id == ^item , select: (d.price)))
  end
  def get_quantity_sale_uniq_man(mid, item,date,date_1) do
    Repo.one(from(d in Sale, where: d.mid == ^mid and d.item == ^item and d.date >= ^date and d.date <= ^date_1, select: count(d.id)))
  end

  def get_price_sale_uniq_man(mid, item,date,date_1) do
    Repo.one(from(d in Sale, where: d.mid == ^mid and d.item == ^item and d.date >= ^date and d.date <= ^date_1, select: sum(d.manufacturer)))
  end



  def count_sales_manufacturer_invoice(mid, date, date_1) do
    Repo.one(
      from(
        d in Sale,
        where: d.mid == ^mid and d.date >= ^date and d.date <= ^date_1,
        select: count(d.id)
      )
    )
  end

  def sum_sales_price_manufacturer_invoice(mid, date, date_1) do
    Repo.one(
      from(
        d in Sale,
        where: d.mid == ^mid and d.date >= ^date and d.date <= ^date_1,
        select: sum(d.manufacturer)
      )
    )
  end

  def list_sales_warehouse_invoice(wid, date, date_1) do
    Sale

    Repo.all(from(d in Sale, where: d.wid == ^wid and d.date >= ^date and d.date <= ^date_1))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def list_sales_warehouse_invoice_uniq(wid, date, date_1) do
    Sale
   Repo.all(from d in Sale, where: d.wid == ^wid and d.date >= ^date and d.date <= ^date_1, distinct: true,select: d.item)

  end


    def get_quantity_sale_uniq_ware(wid, item,date,date_1) do
      Repo.one(from(d in Sale, where: d.wid == ^wid and d.item == ^item and d.date >= ^date and d.date <= ^date_1, select: count(d.id)))
    end

    def get_price_sale_uniq_ware(wid, item,date,date_1) do
      Repo.one(from(d in Sale, where: d.wid == ^wid and d.item == ^item and d.date >= ^date and d.date <= ^date_1, select: sum(d.warehouse)))
    end


  def count_sales_warehouse_invoice(wid, date, date_1) do
    Repo.one(
      from(
        d in Sale,
        where: d.wid == ^wid and d.date >= ^date and d.date <= ^date_1,
        select: count(d.id)
      )
    )
  end

  def sum_sales_price_warehouse_invoice(wid, date, date_1) do
    Repo.one(
      from(
        d in Sale,
        where: d.wid == ^wid and d.date >= ^date and d.date <= ^date_1,
        select: sum(d.warehouse)
      )
    )
  end

  def list_sales_retail_invoice(id, date, date_1) do
    Sale

    Repo.all(from(d in Sale, where: d.user_id == ^id and d.date >= ^date and d.date <= ^date_1))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def list_sales_retailer_invoice_uniq(id, date, date_1) do
    Sale
   Repo.all(from d in Sale, where: d.user_id == ^id and d.date >= ^date and d.date <= ^date_1, distinct: true,select: d.item)

  end

  def get_quantity_sale_uniq_retailer(id, item,date,date_1) do
    Repo.one(from(d in Sale, where: d.user_id == ^id and d.item == ^item and d.date >= ^date and d.date <= ^date_1, select: count(d.id)))
  end

  def get_price_sale_uniq_retailer(id, item,date,date_1) do
    Repo.one(from(d in Sale, where: d.user_id == ^id and d.item == ^item and d.date >= ^date and d.date <= ^date_1, select: sum(d.retailer)))
  end

  def count_sales_retail_invoice(id, date, date_1) do
    Repo.one(
      from(
        d in Sale,
        where: d.user_id == ^id and d.date >= ^date and d.date <= ^date_1,
        select: count(d.id)
      )
    )
  end

  def sum_sales_price_retail_invoice(id, date, date_1) do
    Repo.one(
      from(
        d in Sale,
        where: d.user_id == ^id and d.date >= ^date and d.date <= ^date_1,
        select: sum(d.retailer)
      )
    )
  end



  def list_sales_manufacturer_dash(current_user) do
    Dispatch

    Repo.all(
      from(
        d in Sale,
        where: d.mid == ^current_user.id,
        order_by: [desc: d.id],
        preload: [:sku],
        preload: [:user],
        limit: 5
      )
    )
  end

  def list_sales_manufacturer_dash_all() do
    Dispatch
    Repo.all(from(d in Sale, order_by: [desc: d.id], preload: [:sku], preload: [:user], limit: 5))
  end

  @doc """
  Gets a single sale.

  Raises `Ecto.NoResultsError` if the Sale does not exist.

  ## Examples

      iex> get_sale!(123)
      %Sale{}

      iex> get_sale!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sale!(id) do
    Repo.get!(Sale, id)
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def get_sale_by_user!(user_id, id) do
    Repo.one(from(d in Sale, where: d.user_id == ^user_id and d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def get_sale_manufacturer(mid, id) do
    Dispatch

    Repo.one(from(d in Sale, where: d.mid == ^mid and d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a sale.

  ## Examples

      iex> create_sale(%{field: value})
      {:ok, %Sale{}}

      iex> create_sale(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sale(attrs \\ %{}) do
    %Sale{}
    |> Sale.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sale.

  ## Examples

      iex> update_sale(sale, %{field: new_value})
      {:ok, %Sale{}}

      iex> update_sale(sale, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sale(%Sale{} = sale, attrs) do
    sale
    |> Sale.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Sale.

  ## Examples

      iex> delete_sale(sale)
      {:ok, %Sale{}}

      iex> delete_sale(sale)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sale(%Sale{} = sale) do
    Repo.delete(sale)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sale changes.

  ## Examples

      iex> change_sale(sale)
      %Ecto.Changeset{source: %Sale{}}

  """
  def change_sale(%Sale{} = sale) do
    Sale.changeset(sale, %{})
  end

  def get_items(current_user) do
    Repo.all(
      from(
        b in Inventory,
        join: c in Sku,
        where: b.item == c.id and b.user_id == ^current_user.id and b.active == ^"true",
        select: {c.name, b.item}
      )
    )
  end

  def get_count_sales(current_user) do
    Repo.one(from(d in Sale, where: d.user_id == ^current_user.id, select: count(d.id)))
  end

  def get_count_sales_today(current_user, date) do
    Repo.one(
      from(
        d in Sale,
        where: d.user_id == ^current_user.id and d.date == ^date,
        select: count(d.id)
      )
    )
  end

  def get_sum_sales_price(current_user) do
    Repo.one(from(d in Sale, where: d.user_id == ^current_user.id, select: sum(d.retailer)))
  end

  def get_count_sales_all() do
    Repo.one(from(d in Sale, select: count(d.id)))
  end

  def get_count_quantity_item(current_user, item) do
    Repo.one(
      from(
        d in Sale,
        where: d.user_id == ^current_user.id and d.item == ^item,
        select: sum(d.quantity)
      )
    )
  end

  def get_count_quantity_item_pos(current_user, id) do
    Repo.one(
      from(
        d in Sale,
        join: c in Sku,
        where: c.gtin == ^id and d.item == c.id and d.user_id == ^current_user,
        select: sum(d.quantity)
      )
    )
  end
  def get_count_quantity_item_stock(current_user, id) do
    Repo.one(
      from(
        d in Sale,
        where:  d.item == ^id and d.user_id == ^current_user,
        select: sum(d.quantity)
      )
    )
  end

  def get_count_quantity_item!(current_user, item) do
    Repo.one(
      from(
        d in Sale,
        where: d.user_id == ^current_user.id and d.item == ^item,
        select: sum(d.quantity)
      )
    )
  end

  def get_sum_quantity_sales(current_user, item) do
    Repo.one(
      from(
        d in Sale,
        where: d.user_id == ^current_user.id and d.item == ^item,
        select: fragment("sum(s0.`retailer` * s0.`quantity`)")
      )
    )
  end

  def get_item_manufacturer(item) do
    Repo.one(from(c in Sku, where: c.id == ^item, select: c.user_id))
  end

  def get_item_manufacturer_name(item) do
    Repo.one(
      from(
        c in Sku,
        join: u in User,
        where: c.id == ^item and c.user_id == u.id,
        select: u.company
      )
    )
  end

  def get_item_warehouse(item, current_user) do
    Repo.one(
      from(
        c in Dispatch_Warehouse,
        where: c.item == ^item and c.retailer == ^current_user.id,
        select: c.user_id,
        limit: 1
      )
    )
  end

  def get_item_warehouse!(item, current_user) do
    Repo.one(
      from(
        c in Dispatch_Warehouse,
        where: c.item == ^item and c.retailer == ^current_user,
        select: c.user_id,
        limit: 1
      )
    )
  end

  def get_count_manufacturer_value(current_user) do
    Repo.one(from(d in Sale, where: d.mid == ^current_user.id, select: sum(d.manufacturer)))
  end

  def get_count_manufacturer_value_api(user) do
    Repo.one(from(d in Sale, where: d.mid == ^user, select: sum(d.manufacturer)))
  end

  def get_count_manufacturer_value_today(current_user, date) do
    Repo.one(
      from(
        d in Sale,
        where: d.mid == ^current_user.id and d.date == ^date,
        select: sum(d.manufacturer)
      )
    )
  end

  def get_count_manufacturer_value_today_api(user, date) do
    Repo.one(
      from(d in Sale, where: d.mid == ^user and d.date == ^date, select: sum(d.manufacturer))
    )
  end

  def get_count_manufacturer_value_card_today_api(user, date) do
    Repo.one(
      from(d in Sale,
        where: d.mid == ^user and d.date == ^date and d.mode == ^"card",
        select: sum(d.manufacturer)
      )
    )
  end

  def get_count_manufacturer_value_by_search(current_user, date_search, date_search_2) do
    Repo.one(
      from(
        d in Sale,
        where: d.mid == ^current_user.id and d.date >= ^date_search and d.date <= ^date_search_2,
        select: sum(d.manufacturer)
      )
    )
  end

  def get_count_manufacturer_value_by_search_retailer(current_user, date_search, date_search_2, retailer) do
    Repo.one(
      from(
        d in Sale,
        where: d.mid == ^current_user.id and d.date >= ^date_search and d.date <= ^date_search_2 and d.user_id == ^retailer,
        select: sum(d.manufacturer)
      )
    )
  end

  def get_countall_manufacturer_value_by_search(date_search, date_search_2) do
    Repo.one(
      from(
        d in Sale,
        where: d.date >= ^date_search and d.date <= ^date_search_2,
        select: sum(d.manufacturer)
      )
    )
  end

  def get_countall_manufacturer_value_by_search_retailer(date_search, date_search_2, retailer) do
    Repo.one(
      from(
        d in Sale,
        where: d.date >= ^date_search and d.date <= ^date_search_2 and d.user_id == ^retailer,
        select: sum(d.manufacturer)
      )
    )
  end

  def get_countall_manufacturer_value() do
    Repo.one(from(d in Sale, select: sum(d.manufacturer)))
  end

  def get_countall_manufacturer_value_today(date) do
    Repo.one(from(d in Sale, where: d.date == ^date, select: sum(d.manufacturer)))
  end

  def get_count_warehouse_value(current_user) do
    Repo.one(from(d in Sale, where: d.wid == ^current_user.id, select: sum(d.warehouse)))
  end

  def get_count_warehouse_value_today(current_user, date) do
    Repo.one(
      from(
        d in Sale,
        where: d.wid == ^current_user.id and d.date == ^date,
        select: sum(d.warehouse)
      )
    )
  end

  def get_count_warehouse_value_today_api(user, date) do
    Repo.one(from(d in Sale, where: d.wid == ^user and d.date == ^date, select: sum(d.warehouse)))
  end

  def get_count_warehouse_value_card_today_api(user, date) do
    Repo.one(
      from(d in Sale,
        where: d.wid == ^user and d.date == ^date and d.mode == ^"card",
        select: sum(d.warehouse)
      )
    )
  end

  def get_count_warehouse_value_by_search(current_user, date_search, date_search_2) do
    Repo.one(
      from(
        d in Sale,
        where: d.wid == ^current_user.id and d.date >= ^date_search and d.date <= ^date_search_2,
        select: sum(d.warehouse)
      )
    )
  end

  def get_count_warehouse_value_by_search_retailer(current_user, date_search, date_search_2, retailer) do
    Repo.one(
      from(
        d in Sale,
        where: d.wid == ^current_user.id and d.date >= ^date_search and d.date <= ^date_search_2 and d.user_id == ^retailer,
        select: sum(d.warehouse)
      )
    )
  end

  def get_countall_warehouse_value_by_search(date_search, date_search_2) do
    Repo.one(
      from(
        d in Sale,
        where: d.date >= ^date_search and d.date <= ^date_search_2,
        select: sum(d.warehouse)
      )
    )
  end

  def get_countall_warehouse_value_by_search_retailer(date_search, date_search_2, retailer) do
    Repo.one(
      from(
        d in Sale,
        where: d.date >= ^date_search and d.date <= ^date_search_2 and d.user_id ==^ retailer,
        select: sum(d.warehouse)
      )
    )
  end

  def get_countall_warehouse_value() do
    Repo.one(from(d in Sale, select: sum(d.warehouse)))
  end

  def get_countall_warehouse_value_today(date) do
    Repo.one(from(d in Sale, where: d.date == ^date, select: sum(d.warehouse)))
  end

  def get_count_retailer_value(current_user) do
    Repo.one(from(d in Sale, where: d.user_id == ^current_user.id, select: sum(d.retailer)))
  end

  def get_count_retailer_value_today(current_user, date) do
    Repo.one(
      from(
        d in Sale,
        where: d.user_id == ^current_user.id and d.date == ^date,
        select: sum(d.retailer)
      )
    )
  end

  def get_count_retailer_value_today_api(user, date) do
    Repo.one(
      from(d in Sale, where: d.user_id == ^user and d.date == ^date, select: sum(d.retailer))
    )
  end

  def get_count_retailer_value_card_today_api(user, date) do
    Repo.one(
      from(d in Sale,
        where: d.user_id == ^user and d.date == ^date and d.mode == ^"card",
        select: sum(d.retailer)
      )
    )
  end

  def get_count_retailer_value_by_search(current_user, date_search, date_search_2) do
    Repo.one(
      from(
        d in Sale,
        where:
          d.user_id == ^current_user.id and d.date >= ^date_search and d.date <= ^date_search_2,
        select: sum(d.retailer)
      )
    )
  end

  def get_count_retailer_value_by_search_retailer(current_user, date_search, date_search_2, retailer) do
    Repo.one(
      from(
        d in Sale,
        where:
          d.user_id == ^current_user.id and d.date >= ^date_search and d.date <= ^date_search_2 and d.user_id == ^retailer,
        select: sum(d.retailer)
      )
    )
  end

  def get_countall_retailer_value_by_search(date_search, date_search_2) do
    Repo.one(
      from(
        d in Sale,
        where: d.date >= ^date_search and d.date <= ^date_search_2,
        select: sum(d.retailer)
      )
    )
  end

  def get_countall_retailer_value_by_search_retailer(date_search, date_search_2, retailer) do
    Repo.one(
      from(
        d in Sale,
        where: d.date >= ^date_search and d.date <= ^date_search_2 and d.user_id ==^ retailer,
        select: sum(d.retailer)
      )
    )
  end

  def get_countall_retailer_value() do
    Repo.one(from(d in Sale, select: sum(d.retailer)))
  end

  def get_countall_retailer_value_today(date) do
    Repo.one(from(d in Sale, where: d.date == ^date, select: sum(d.retailer)))
  end

  def get_countall_gs1_value() do
    Repo.one(from(d in Sale, select: sum(d.gs1)))
  end

  def get_countall_gs1_value_today(date) do
    Repo.one(from(d in Sale, where: d.date == ^date, select: sum(d.gs1)))
  end

  def get_countall_gs1_value_by_search(date_search, date_search_2) do
    Repo.one(
      from(
        d in Sale,
        where: d.date >= ^date_search and d.date <= ^date_search_2,
        select: sum(d.gs1)
      )
    )
  end

  def get_countall_gs1_value_by_search_retailer(date_search, date_search_2, retailer) do
    Repo.one(
      from(
        d in Sale,
        where: d.date >= ^date_search and d.date <= ^date_search_2 and d.user_id ==^ retailer,
        select: sum(d.gs1)
      )
    )
  end

  def check_item(sale_id) do
    Repo.one(from(d in Sale, where: d.sale_id == ^sale_id, select: count(d.id)))
  end

  def get_gs1_value() do
    Repo.one(from(p in Pmaster, where: p.names == "thamani-online", select: p.max))
  end
end
