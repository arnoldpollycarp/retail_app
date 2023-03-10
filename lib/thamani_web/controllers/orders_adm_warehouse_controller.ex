defmodule ThamaniWeb.OrdersAdmWarehouseController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Warehouse_orders

  alias Thamani.Dispatches

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "warehouse_order" when action in [:create, :update])

  def index(conn, _params) do
    warehouse_order = Warehouse_orders.list_orders_warehouse_all()
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()

    render(
      conn,
      "index.html",
      warehouse_order: warehouse_order,
      count_7: count_7,
      count_order: count_order
    )
  end

  def show(conn, %{"id" => id}) do
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()

    warehouse_order = Warehouse_orders.get_orders_warehouse(id)

    render(
      conn,
      "show.html",
      warehouse_order: warehouse_order,
      count_7: count_7,
      count_order: count_order
    )
  end
end
