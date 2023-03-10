defmodule ThamaniWeb.DispatchAdminWarehouseController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Dispatches_Warehouse

  alias Thamani.Dispatches

  alias Thamani.Warehouse_orders

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "dispatch__warehouse" when action in [:create, :update])

  def index(conn, _params) do
    dispatch__warehouse = Dispatches_Warehouse.list_dispatches_warehouse()
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()

    render(
      conn,
      "index.html",
      dispatch__warehouse: dispatch__warehouse,
      count_7: count_7,
      count_order: count_order
    )
  end

  def show(conn, %{"id" => id}) do
    dispatch__warehouse = Dispatches_Warehouse.get_dispatch__warehouse!(id)
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()

    render(
      conn,
      "show.html",
      dispatch__warehouse: dispatch__warehouse,
      count_7: count_7,
      count_order: count_order
    )
  end
end
