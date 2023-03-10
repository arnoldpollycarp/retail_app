defmodule ThamaniWeb.OrdersAdminRetmanController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Manufacturer_orders
  alias Thamani.Inventories
  alias Thamani.Retman_orders
  alias Thamani.Retail_Returns
  alias Thamani.Returns

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "retman_order" when action in [:create, :update])

  def index(conn, _params) do
    retman_order = Retman_orders.list_retman_orders()
    count_stock = Inventories.get_count_restock_man_all()
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()

    render(
      conn,
      "index.html",
      retman_order: retman_order,
      count_stock: count_stock,
      count_order_retman: count_order_retman,
      count_order: count_order,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end

  def show(conn, %{"id" => id}) do
    retman_order = Retman_orders.get_retman_order!(id)
    count_stock = Inventories.get_count_restock_man_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_order = Manufacturer_orders.get_count_order_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()

    render(
      conn,
      "show.html",
      retman_order: retman_order,
      count_stock: count_stock,
      count_order_retman: count_order_retman,
      count_order: count_order,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end
end
