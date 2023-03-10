defmodule ThamaniWeb.WarehouseAdmOrdersController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Warehouse_orders

  alias Thamani.Inventories

  alias Thamani.Dispatches_Warehouse

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "warehouse_orders" when action in [:create, :update])

  def index(conn, _params) do
    warehouse_order = Warehouse_orders.list_warehouse_orders()

    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()

    render(
      conn,
      "index.html",
      warehouse_order: warehouse_order,
      count_4: count_4,
      count_5: count_5,
      list_item: [],
      list_city: [],
      id: ["none"],
      company: ["none"],
      delivery: ["none"],
      quantity: "none",
      total: "none",
      used: "none",
      loader_class: " ",
      field_class: "display:none ",
      field_class2: "display:none ",
      loader_class2: " ",
      loader_class3: " ",
      message_class: " ",
      alert_class: " ",
      long_process_button_text: " ",
      category_text: " ",
      item_text: " ",
      uom_text: " ",
      quantity_text: " "
    )
  end

  def show(conn, %{"id" => id}) do
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    warehouse_order = Warehouse_orders.get_warehouse_order!(id)

    render(
      conn,
      "show.html",
      warehouse_order: warehouse_order,
      count_4: count_4,
      count_5: count_5
    )
  end
end
