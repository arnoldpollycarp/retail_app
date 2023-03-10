defmodule ThamaniWeb.ReorderAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Inventories

  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer

  alias Thamani.Reorders

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "inventory" when action in [:create, :update])

  def index(conn, _params) do
    reorder = Reorders.list_reorders()
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    count_6 = Dispatches_Retailer.get_count_recieved_all!()

    render(
      conn,
      "index.html",
      reorder: reorder,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end

  def show(conn, %{"id" => id}) do
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    count_6 = Dispatches_Retailer.get_count_recieved_all!()
    reorder = Reorders.get_reorder!(id)

    render(
      conn,
      "show.html",
      reorder: reorder,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end
end
