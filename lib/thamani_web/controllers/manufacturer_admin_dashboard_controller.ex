defmodule ThamaniWeb.ManufacturerAdminDashboardController do
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

  plug(:put_layout, "manufacturer.html")

  def index(conn, _params) do
    dispatch = Dispatches.get_dispatches!()
    dispatch_retailer = Dispatches_Retailer.get_dispatches!()

    count_1 = Items.get_countall_sku()
    count_0 = Dispatches.get_count_dispatch_value_all()
    count_3 = Dispatches.get_count_dispatch_all()
    count_4 = Dispatches.get_count_quantity_all()
    count_5 = Dispatches.get_count_confirmed_all()
    count_7 = Batches.get_count_batches_all()
    sales = Sales.list_sales_manufacturer_dash_all()
    count_stock = Inventories.get_count_restock_man_all()
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()

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
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end
end
