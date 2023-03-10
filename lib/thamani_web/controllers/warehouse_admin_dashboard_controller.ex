defmodule ThamaniWeb.WarehouseAdminDashboardController do
  use ThamaniWeb, :controller

  require Ecto.Query
  require Ecto
  require Ecto.Schema
  alias Thamani.Items
  alias Thamani.Dispatches
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Warehouse_orders

  plug(:put_layout, "warehouse.html")

  def index(conn, _params) do
    count = Dispatches.get_count_recieved_all()
    dispatch = Dispatches_Warehouse.get_dispatches_all()

    count_1 = Items.get_countall_sku()
    count_order = Warehouse_orders.get_count_order_all()
    count_3 = Dispatches_Warehouse.get_count_dispatch_all()
    count_4 = Dispatches_Warehouse.get_count_quantity_all()
    count_5 = Dispatches_Warehouse.get_count_confirmed_all()

    count_7 = Dispatches.get_count_recieved_all!()

    render(
      conn,
      "dashboard.html",
      count: count,
      count_1: count_1,
      count_order: count_order,
      count_2: "Loading",
      count_3: count_3,
      count_4: count_4,
      count_5: count_5,
      count_6: "Loading",
      count_7: count_7,
      dispatch: dispatch
    )
  end
end
