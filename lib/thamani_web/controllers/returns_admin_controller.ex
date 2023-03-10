defmodule ThamaniWeb.ReturnAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema

  alias Thamani.Dispatches
  alias Thamani.Warehouse_orders
  alias Thamani.Returns

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "return" when action in [:create, :update])

  def index(conn, _params) do
    return = Returns.list_returns()
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()

    render(conn, "index.html", return: return, count_7: count_7, count_order: count_order)
  end

  def show(conn, %{"id" => id}) do
    return = Returns.get_return!(id)
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()

    render(conn, "show.html", return: return, count_7: count_7, count_order: count_order)
  end
end
