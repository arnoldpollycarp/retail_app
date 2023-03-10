defmodule ThamaniWeb.StorageAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Storages

  alias Thamani.Dispatches

  alias Thamani.Warehouse_orders

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "storage" when action in [:create, :update])

  def index(conn, _params) do
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()
    storage = Storages.list_storages()

    render(conn, "index.html", storage: storage, count_7: count_7, count_order: count_order)
  end

  def show(conn, %{"id" => id}) do
    storage = Storages.get_storage!(id)
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()

    render(conn, "show.html", storage: storage, count_7: count_7, count_order: count_order)
  end
end
