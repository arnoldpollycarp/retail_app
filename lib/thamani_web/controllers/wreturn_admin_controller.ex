defmodule ThamaniWeb.WreturnAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Retail_Returns
  alias Thamani.Inventories
  alias Thamani.Returns
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "return" when action in [:create, :update])

  def index(conn, _params) do
    recieved = Returns.list_returns()
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_stock = Inventories.get_count_restock_man_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()

    render(
      conn,
      "index.html",
      recieved: recieved,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end

  def show(conn, %{"id" => id}) do
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_stock = Inventories.get_count_restock_man_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()
    recieved = Returns.get_return!(id)

    render(
      conn,
      "show.html",
      recieved: recieved,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end
end
