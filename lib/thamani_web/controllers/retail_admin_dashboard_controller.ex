defmodule ThamaniWeb.RetailAdminDashboardController do
  use ThamaniWeb, :controller

  require Ecto.Query
  require Ecto
  require Ecto.Schema

  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Inventories

  plug(:put_layout, "retail.html")

  def index(conn, _params) do
    count = Dispatches_Warehouse.get_count_recieved_all()
    count_1 = Inventories.get_count_inventory_all()

    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    count_6 = Dispatches_Retailer.get_count_recieved_all()

    render(
      conn,
      "dashboard.html",
      count: count,
      count_1: count_1,
      count_2: "Loading",
      count_3: "Loading",
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end
end
