defmodule ThamaniWeb.RecievedAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Dispatches

  alias Thamani.Warehouse_orders

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "dispatch" when action in [:create, :update])

  def index(conn, _params) do
    recieved = Dispatches.list_recieved_all()
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()

    render(conn, "index.html", recieved: recieved, count_7: count_7, count_order: count_order)
  end

  def show(conn, %{"id" => id}) do
    recieved = Dispatches.get_recieved(id)
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()

    render(conn, "show.html", recieved: recieved, count_7: count_7, count_order: count_order)
  end
end
