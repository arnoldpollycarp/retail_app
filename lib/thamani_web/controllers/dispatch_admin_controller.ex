defmodule ThamaniWeb.DispatchAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Dispatches

  alias Thamani.Inventories
  alias Thamani.Retail_Returns
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders
  alias Thamani.Returns

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "dispatch" when action in [:create, :update])

  def index(conn, _params) do
    count_stock = Inventories.get_count_restock_man_all()
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()
    dispatch = Dispatches.list_dispatches()

    render(
      conn,
      "index.html",
      dispatch: dispatch,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end

  def show(conn, %{"id" => id}) do
    count_stock = Inventories.get_count_restock_man_all()
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()

    dispatch = Dispatches.get_dispatch!(id)

    render(
      conn,
      "show.html",
      dispatch: dispatch,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end
end
