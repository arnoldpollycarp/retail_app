defmodule ThamaniWeb.BatchAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Batches
  alias Thamani.Inventories
  alias Thamani.Retail_Returns
  alias Thamani.Returns
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "batch" when action in [:create, :update])

  def index(conn, _params) do
    batch = Batches.list_batches()
    count_stock = Inventories.get_count_restock_man_all()
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()

    render(
      conn,
      "index.html",
      batch: batch,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end

  def show(conn, %{"id" => id}) do
    batch = Batches.get_batch!(id)
    count_stock = Inventories.get_count_restock_man_all()
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()

    if batch do
      render(
        conn,
        "show.html",
        batch: batch,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: batch_admin_path(conn, :index))
    end
  end
end
