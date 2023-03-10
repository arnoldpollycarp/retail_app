defmodule ThamaniWeb.ManufacturerAdmOrdersController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Manufacturer_orders

  alias Thamani.Retman_orders

  alias Thamani.Dispatches

  alias Thamani.Retman_orders
  alias Thamani.Warehouse_orders

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "manufacturer_orders" when action in [:create, :update])

  def index(conn, _params) do
    manufacturer_order = Manufacturer_orders.list_manufacturer_orders()
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()

    render(
      conn,
      "index.html",
      manufacturer_order: manufacturer_order,
      count_7: count_7,
      count_order: count_order,
      count_order_retman: count_order_retman,
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
    count_7 = Dispatches.get_count_recieved_all!()
    count_order = Warehouse_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    manufacturer_order = Manufacturer_orders.get_manufacturer_order!(id)

    render(
      conn,
      "show.html",
      manufacturer_order: manufacturer_order,
      count_7: count_7,
      count_order: count_order,
      count_order_retman: count_order_retman
    )
  end
end
