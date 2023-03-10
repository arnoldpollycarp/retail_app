defmodule ThamaniWeb.WarehouseDashboardController do
  use ThamaniWeb, :controller

  require Ecto.Query
  require Ecto
  require Ecto.Schema
  alias Thamani.Items
  alias Thamani.Inventories
  alias Thamani.Dispatches
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Warehouse_orders
  alias Thamani.Repo

  plug(:put_layout, "warehouse.html")

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    date = String.slice(to_string(DateTime.utc_now()), 0..9)
    date_1 = String.slice(to_string(Timex.shift(DateTime.utc_now(), days: 60)), 0..9)
    list_expiry = Dispatches.list_inventory_by_expiry(date_1, date, current_user)
    count = Dispatches.get_count_recieved(current_user.id)
    dispatch = Dispatches_Warehouse.get_dispatches(current_user)

    count_1 = Items.get_count_sku(current_user)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_3 = Dispatches_Warehouse.get_count_dispatch(current_user)
    count_4 = Dispatches_Warehouse.get_count_quantity(current_user)
    count_5 = Dispatches_Warehouse.get_count_confirmed(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    count_7 = Dispatches.get_count_recieved!(current_user.id)

    render(
      conn,
      "dashboard.html",
      list_expiry: list_expiry,
      count_stock: count_stock,
      count: count,
      count_1: count_1,
      count_order: count_order,
      count_2: "Loading",
      count_3: count_3,
      count_4: count_4,
      count_5: count_5,
      count_6: "Loading",
      count_7: count_7,
      dispatch: dispatch,
      user: user
    )
  end
end
