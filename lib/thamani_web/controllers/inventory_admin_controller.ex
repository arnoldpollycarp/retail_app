defmodule ThamaniWeb.InventoryAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Inventories
  alias Thamani.Dispatches_Warehouse

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "inventory" when action in [:create, :update])

  def index(conn, _params) do
    inventory = Inventories.list_inventories_admin()

    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()

    render(conn, "index.html", inventory: inventory, count_4: count_4, count_5: count_5)
  end

  def show(conn, %{"id" => id}) do
    inventory = Inventories.get_inventory!(id)
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    item_id = Inventories.get_item_type(id)
    inventories = Inventories.list_inventories_by_item_admin!(item_id)
    inventories_price = Inventories.list_inventories_by_item_admin_one!(item_id)

    render(
      conn,
      "show.html",
      inventory: inventory,
      inventories: inventories,
      inventories_price: inventories_price,
      count_4: count_4,
      count_5: count_5
    )
  end
end
