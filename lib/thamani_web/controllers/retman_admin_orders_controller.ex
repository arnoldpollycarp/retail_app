defmodule ThamaniWeb.RetmanAdminOrdersController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Retman_orders

  alias Thamani.Inventories

  alias Thamani.Dispatches_Warehouse

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "retman_orders" when action in [:create, :update])

  def index(conn, _params) do
    retman_order = Retman_orders.list_retman_orders()
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()

    render(
      conn,
      "index.html",
      retman_order: retman_order,
      count_4: count_4,
      count_5: count_5,
      list_item: [],
      sku: [],
      list_city: [],
      company: ["none"],
      id: ["none"],
      delivery: ["none"],
      min_quantity: ["none"],
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
    retman_order = Retman_orders.get_retman_order!(id)

    render(conn, "show.html", retman_order: retman_order, count_4: count_4, count_5: count_5)
  end
end
