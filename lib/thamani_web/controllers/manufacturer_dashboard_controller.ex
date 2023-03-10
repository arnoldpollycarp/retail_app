defmodule ThamaniWeb.ManufacturerDashboardController do
  use ThamaniWeb, :controller

  require Ecto.Query
  require Ecto
  require Ecto.Schema
  alias Thamani.Items
  alias Thamani.Dispatches
  alias Thamani.Dispatches_Retailer
  alias Thamani.Inventories
  alias Thamani.Sales
  alias Thamani.Retail_Returns
  alias Thamani.Returns
  alias Thamani.Batches
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    dispatch = Dispatches.get_dispatches(current_user)
    dispatch_retailer = Dispatches_Retailer.get_dispatches(current_user)
    count_1 = Items.get_count_sku(current_user)
    count_0 = Dispatches.get_count_dispatch_value(current_user)
    count_3 = Dispatches.get_count_dispatch(current_user)
    count_4 = Dispatches.get_count_quantity(current_user)
    count_5 = Dispatches.get_count_confirmed(current_user)
    count_7 = Batches.get_count_batches(current_user)
    sales = Sales.list_sales_manufacturer_dash(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    render(
      conn,
      "dashboard.html",
      access_log: "",
      count_0: count_0,
      count_1: count_1,
      count_2: "loading",
      count_3: count_3,
      count_4: count_4,
      count_5: count_5,
      count_6: "loading",
      count_7: count_7,
      sales: sales,
      dispatch: dispatch,
      dispatch_retailer: dispatch_retailer,
      user: user,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end
end
