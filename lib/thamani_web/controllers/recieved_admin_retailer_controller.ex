defmodule ThamaniWeb.RecievedAdminRetailerController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Dispatches_Warehouse

  alias Thamani.Inventories

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "dispatch__warehouse" when action in [:create, :update])

  def index(conn, _params) do
    recieved = Dispatches_Warehouse.list_recieved_all()
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()

    render(conn, "index.html", recieved: recieved, count_5: count_5, count_4: count_4)
  end

  def show(conn, %{"id" => id}) do
    recieved = Dispatches_Warehouse.get_recieved_all(id)
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()

    render(conn, "show.html", recieved: recieved, count_5: count_5, count_4: count_4)
  end
end
